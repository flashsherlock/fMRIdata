%% set path
monkeys = {'RM035','RM033'};
% monkeys = {'RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir = [data_dir 'pic/erp_resp/' m '_HA0.2cb/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
time_ranges = {[-1 3], [-1 4]};
%% generate data or load data
if exist([pic_dir 'correlation.mat'],'file')
    load([pic_dir 'correlation.mat']);
else
    level = 6;
    trl_type = 'odorresp';
    % combine 2 monkeys
    [roi_lfp,roi_resp,cur_level_roi] = save_merge_2monkey(level,trl_type,monkeys);
    % get number of roi
    roi_num=size(cur_level_roi,1);
    %% analyze    
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
            % cfg.lpfilter = 'yes';
            % cfg.lpfilttype = 'fir';
            % cfg.lpfreq = 0.6;
            cfg.bpfilter = 'yes';
            cfg.bpfilttype = 'fir';
            cfg.bpfreq = [0.2 0.6];
            if condition<=6
                % air
                cfg.trials = find(lfp.trialinfo==condition);
            else
                % odor
                cfg.trials = find(lfp.trialinfo~=6);
            end
            lfp_l = ft_preprocessing(cfg,lfp);
            % cfg          = [];
            % cfg.method   = 'trial';
            % dummy        = ft_rejectvisual(cfg,lfp_l);
            % cfg = [];
            % cfg.viewmode = 'vertical';
            % cfg.ylim = 'maxmin';
            % lfp_l = rmfield(lfp_l,'sampleinfo');
            % eegplot = ft_databrowser(cfg,lfp_l);
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
                    results{roi_i,3+2*range_i,condition-5}=[results{roi_i,3+2*range_i,condition-5};r3_per];                           
                end
            end
        end
    % figure
    % scatter(resavg.avg(select)',squeeze(mean(erp_blc.trial(:,select),1)'))
    % figure
    % scatter(resavg.avg',squeeze(mean(erp_blc.trial,1))')
    end
    save([pic_dir 'correlation.mat'],'results');
end
%% plot
roi_num = size(results,1);
for roi_i=1:roi_num
    for condition = 1:2
        for range_i = 1:length(time_ranges)
            time_range = time_ranges{range_i};
            % load results
            cur_roi = results{roi_i,1,condition};
            resavg = results{roi_i, 2, condition};
            erp_blc = results{roi_i, 3, condition};
            r3 = results{roi_i, 2 + 2 * range_i, condition};
            true = atanh(r3);
            r3_pers = results{roi_i, 3 + 2 * range_i, condition};
            % fix previous storage bug
            % results{roi_i, 3 + 2 * range_i, condition} = r3_pers(end,:);
            % r3_pers = results{roi_i, 3 + 2 * range_i, condition};
            for step = 1:size(r3_pers,1)
                r3_per = r3_pers(step,:);
                % fisher-z
                r3_per = atanh(r3_per);
                cut1 = prctile(r3_per, 97.5);
                cut2 = prctile(r3_per, 2.5);
                sig = '';
                if true > cut1 || true < cut2
                    sig = '*';
                end
                figure('position',[20 20 1000 450],'Renderer','Painters')
                subplot(1,2,1)
                hold on
                plot(erp_blc.time,1000*erp_blc.trial,'b','LineWidth',1.5)
                xlabel('Time (s)')
                ylabel('Voltage')
                yyaxis right
                plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
                set(gca,'xlim',time_range,'ytick',[]);
                set(gca,'FontSize',18);
                % permutation test
                subplot(1,2,2)
                hold on
                hist(r3_per,50)
                set(gca,'xlim',[-3 3],'ylim',[0 60]);
                plot([cut1 cut1],get(gca,'Ylim'),'b','linewidth',1.5)
                plot([cut2 cut2],get(gca,'Ylim'),'b','linewidth',1.5)
                plot(true,1,'r.','MarkerSize',30)
                text(-2.8,50,[sprintf('R: %0.2f',round(r3,2)) sig],'Fontsize',18)
                xlabel('Z')
                ylabel('Iterations')
                set(gca,'FontSize',18);
                suptitle([cur_roi ' 0-' num2str(time_range(2)) 's:' num2str(r3)])
%                 saveas(gcf, [pic_dir cur_roi num2str(step) '_' num2str(condition+5) '_' num2str(time_range(2)) 's' '.png'],'png')
                saveas(gcf, [pic_dir cur_roi num2str(step) '_' num2str(condition+5) '_' num2str(time_range(2)) 's' '.svg'],'svg')
                % saveas(gcf, [pic_dir cur_roi num2str(step) '_' num2str(condition+5) '_' num2str(time_range(2)) 's' '.fig'],'fig')
                close all
            end
        end
    end
end
% save([pic_dir 'correlation.mat'],'results');
%% rearrange
results4s = results(:,6:7,:);
for con_i=1:2
    for roi_i = 1:size(results4s,1)
        true = atanh(results4s{roi_i,1,con_i});
        r3_per=results4s{roi_i,2,con_i}(end,:);
        % fisher-z
        r3_per=atanh(r3_per);
        % compare at both side
        if true >=0
            p=2*(sum(bsxfun(@gt, r3_per, true),2))./(size(r3_per,2));
        else
            p=2*(sum(bsxfun(@lt, r3_per, true),2))./(size(r3_per,2));
        end
        cut1=prctile(r3_per,97.5);
        cut2=prctile(r3_per,2.5);
        sig='';
        if true>cut1 || true<cut2
            sig='*';
        end
        results4s{roi_i,2,con_i}=p;
        results4s{roi_i,3,con_i}=sig;
    end
end
results4s=cat(2,repmat(results(:,1),1,1,2),results4s);
save([pic_dir,'results4s.mat'],'results4s')
%% write results to xls
m33=load([data_dir 'pic/erp_resp/RM033/results4s.mat']);
m35=load([data_dir 'pic/erp_resp/RM035/results4s.mat']);
rois=union(m33.results4s(:,1),m35.results4s(:,1));
roi_num=size(rois,1);
results4s=cell(roi_num,7,2);
results4s(:,1,:)=repmat(rois(:,1),1,1,2);
for roi_i=1:roi_num
    cur_roi = rois{roi_i};
    % roi index
    idx33=find(strcmp(cur_roi,m33.results4s(:,1))==1);
    idx35=find(strcmp(cur_roi,m35.results4s(:,1))==1);
    % RM033 points
    if ~isempty(idx33)
        results4s(roi_i,2:4,:)=m33.results4s(idx33,2:4,:);
    end
    % RM035 points
    if ~isempty(idx35)
        results4s(roi_i,5:7,:)=m35.results4s(idx35,2:4,:);
    end
end
% convert results air condition to table and write to exel 
air=results4s(:,:,1);
% round 2 digits
air(:,[2,5])=cellfun(@(x) round(x,2), air(:,[2,5]),'UniformOutput',false);
writetable(cell2table(air),[data_dir 'pic/erp_resp/reults4s_air.xlsx'])