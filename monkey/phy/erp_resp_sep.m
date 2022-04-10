%% load and reorganize data
monkeys = {'RM035','RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/erp_resp/sep_elec/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
%% generate data
level = 3;
trl_type = 'odorresp';
% combine 2 monkeys
[roi_lfp,roi_resp,cur_level_roi] = save_sep_2monkey(level,trl_type,monkeys);
% get number of positions
roi_num=size(cur_level_roi,1);
odor_num=7;
%% analyze
time_ranges = {[-1 3],[-1 4]};
% save to results
results=cell(roi_num,3+2*length(time_ranges),2);
results(:,1,1)=cur_level_roi(:,1);
results(:,1,2)=cur_level_roi(:,1);
for roi_i=1:roi_num
    cur_roi=cur_level_roi{roi_i,1};
    lfp=roi_lfp{roi_i};
    resp=roi_resp{roi_i};
    % select air/odor condition
    for condition = 6:7
        % condition=7;
        cfg=[];
        if condition<=6
            % air
            cfg.trials = find(resp.trialinfo==condition);
        else
            % odor
            cfg.trials = find(resp.trialinfo~=6);
        end
        resavg=ft_timelockanalysis(cfg, resp);
        %% show low frequency signal
        cfg=[];
        cfg.lpfilter = 'yes';
        cfg.lpfilttype = 'fir';
        cfg.lpfreq = 0.6;
        if condition<=6
            % air
            cfg.trials = find(lfp.trialinfo==condition);
        else
            % odor
            cfg.trials = find(lfp.trialinfo~=6);
        end
        lfp_l = ft_preprocessing(cfg,lfp);
        %% ERP
        % baseline correction
        cfg = [];
        cfg.keeptrials = 'yes';
        erp = ft_timelockanalysis(cfg, lfp_l);
        cfg              = [];
        cfg.baseline     = [-1 -0.5];
        bs=linspace(cfg.baseline(1),cfg.baseline(2),100);
        erp_blc = ft_timelockbaseline(cfg, erp);
        % average trials
        cfg = [];
        cfg.avgoverrpt =  'yes';
        erp_blc=ft_selectdata(cfg,erp_blc);
        for range_i=1:length(time_ranges)
            time_range = time_ranges{range_i};
            % compute correlation        
            select=resavg.time>=0&resavg.time<=time_range(2);
            r3=corr(resavg.avg(select)',squeeze(mean(erp_blc.trial(:,select),1))');
            % select=resavg.time>=time_range(1)&resavg.time<=time_range(2);
            % r7=corr(resavg.avg',squeeze(mean(erp_blc.trial,1))');
            true=atanh(r3);
            % save results
            results{roi_i,2,condition-5}=resavg;
            results{roi_i,3,condition-5}=erp_blc;
            results{roi_i,2+2*range_i,condition-5}=r3;
            %% permutation test
            for step=1%[1 10 100 200 500]
            nper=1000;
            r3_per=zeros(1,nper);        
            parfor per_i=1:nper
                erp_per=zeros(length(erp.trialinfo),1000*time_range(2)+1);
                % randomly select 3s
                % r=randi([1 length(erp.time)-1000*time_range(2)],length(erp.trialinfo),1);
                % cut and move
                r=randi([1 1000*time_range(2)],length(erp.trialinfo),1);
                r=step*(ceil(r/step)-1)+1;
                for trial_i=1:length(erp.trialinfo)
                    % erp_per(trial_i,:)=erp.trial(trial_i,1,r(trial_i):r(trial_i)+1000*time_range(2));
                    time_0 = find(erp.time==0);
                    erp_per(trial_i,:)=erp.trial(trial_i,1,[time_0+r(trial_i):1000*time_range(2)+time_0 time_0:time_0+r(trial_i)-1]);
                end
                r3_per(per_i)=corr(resavg.avg(select)',mean(erp_per,1)');
            end
            % save raw permutated r, combine steps
            results{roi_i,3+2*range_i,condition-5}=[results{roi_i,5,condition-5};r3_per];            
            end
        end
    end
end
save([pic_dir 'correlation.mat'],'results');