% function lfp_odorresp(monkeys)
%% load and reorganize data
monkeys = {'RM035','RM033'};
% monkeys = {'RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/lfp_odorresp/' m '_0.5base_HA/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
%% generate data
level = 6;
trl_type = 'odorresp';
% combine 2 monkeys
[roi_lfp,roi_resp,cur_level_roi] = save_merge_2monkey(level,trl_type,monkeys);
% get number of roi
roi_num=size(cur_level_roi,1);
%% TF analysis
if exist([data_dir 'tf_level' num2str(level) '_' m '.mat'],'file')
    load([data_dir 'tf_level' num2str(level) '_' m '.mat'])
elseif level==6
    [freq_sep_all, cur_level_roi] = roi_merge_tf(m);
    % get new number of roi
    roi_num = size(cur_level_roi, 1);
else
    freq_sep_all=cell(roi_num,1);
    for roi_i=1:roi_num
        cur_roi=cur_level_roi{roi_i,1};
        % filt data
        cfg=[];
        cfg.bsfilter    = 'yes';
        cfg.bsfilttype = 'fir';
        cfg.bsfreq      = [99 101;149 151;199 201];
        lfp = ft_preprocessing(cfg,roi_lfp{roi_i});
        % time frequency analysis
        cfgtf=[];
        cfgtf.method     = 'mtmconvol';
        cfgtf.toi        = -3.5:0.05:9.5;
        % cfgtf.foi        = 1:1:100;
        % other wavelet parameters
        cfgtf.foi = logspace(log10(1),log10(200),51);
        % cfgtf.t_ftimwin  = ones(length(cfgtf.foi),1).*0.5;
        cfgtf.t_ftimwin  = 5./cfgtf.foi;
        cfgtf.taper      = 'hanning';
        cfgtf.output     = 'pow';
        cfgtf.keeptrials = 'yes';
        freq_sep_all{roi_i} = ft_freqanalysis(cfgtf, lfp);
    end
    save([data_dir 'tf_level' num2str(level) '_' m '.mat'],'freq_sep_all','-v7.3')
end
%% parameters
if exist([pic_dir 'tf_results_' m '.mat'],'file')
    load([pic_dir 'tf_results_' m '.mat'])
else
    freq_range = [1.5 200];
    time_ranges = {[-0.5 7.5],[-0.5 4]};
    bsline = [-0.5 -0.05];
    conditions = {'-oddtrial',''};
    % set comparison
    comp = cell(7,3);
    for comp_i=1:7
        comp{comp_i,1}=comp_i;
        comp{comp_i,2}=6;
        comp{comp_i,3}=['-' num2str(comp_i) '-vs-air'];
    end
    comp{7,1}=1:5;
    % valence
    comp{6,1}=4:5;    
    comp{6,2}=1:3;
    comp{6,3}='-valence';
    lfp_results = cell(roi_num,7*length(time_ranges)+size(comp,1));
    %% odor and air
    for roi_i=1:roi_num
        % current roi    
        cur_roi=cur_level_roi{roi_i,1};    
        for time_i=1:length(time_ranges)
            % get time range
            time_range = time_ranges{time_i};
            % select data
            cfg=[];        
            cfg.latency=time_range;
            resp=ft_selectdata(cfg,roi_resp{roi_i});
            cfg.frequency=freq_range;
            freq_sep = ft_selectdata(cfg,freq_sep_all{roi_i});
            % average and seperated data
            for i=1:7
                % average across trials
                cfg = [];
                if i==7
                    cfg.trials = find(freq_sep.trialinfo~=6);
                else
                    cfg.trials = find(freq_sep.trialinfo==i);
                end
                % odd trials only
                if strcmp(conditions{time_i},'-oddtrial')
                    cfg.trials = cfg.trials(1:2:end);
                end
                freq_blc=ft_freqdescriptives(cfg,freq_sep);            
                % seperated data
                freq_sepi=ft_selectdata(cfg,freq_sep);
                % respiration
                cfg.keeptrials = 'yes';
                resavg=ft_timelockanalysis(cfg, resp);
                % baseline correction
                cfgbs              = [];
                cfgbs.baseline     = bsline;
                cfgbs.baselinetype = 'db';
                freq_blc = ft_freqbaseline(cfgbs, freq_blc); 

                % generate data
                data = rmfield(freq_blc,{'cfg','dimord'});
                data.label = [data.label{1} '-' trl_type conditions{time_i} '-' num2str(i)];
                data.resp_mean = mean(resavg.trial);
                data.resp_sem = std(resavg.trial)/sqrt(size(resavg.trial,1));
                data.pic_dir = pic_dir;
                data.freq_range = freq_range;
                data.time_range = time_range;
                data.cbarlabel = 'Baseline-normalized power (dB)';
                data.clim = [-2 2];
                data.bs=bsline;
                % permutation test
                [data.un_zmapthresh, data.zmapthresh]= lfp_ptest(freq_blc,freq_sepi,cfgbs);

                % save results
                lfp_results{roi_i,7*(time_i-1)+i} = data;           

                % plot by contourf 1-cluster 0-uncorr
                lfp_tfplot(data,0);
                lfp_tfplot(data,1);            
            end
        end
    %% comparison t-test        
        for comp_i=1:size(comp,1)
            % select data
            cfg=[];
            cfg.trials = find(ismember(freq_sep.trialinfo,[comp{comp_i,1} comp{comp_i,2}])==1);
            freq_cp=ft_selectdata(cfg,freq_sep);
            % respiration
            cfg.trials = find(ismember(freq_sep.trialinfo,comp{comp_i,1})==1);
            cfg.keeptrials = 'yes';
            resavg=ft_timelockanalysis(cfg, resp);
            % baseline correction
            cfgbs.baselinetype = 'absolute';
            freq_cp = ft_freqbaseline(cfgbs, freq_cp);

            % generate data
            data = rmfield(freq_cp,{'cfg','dimord','trialinfo'});
            data.label = [data.label{1} '-' trl_type comp{comp_i,3}];
            data.resp_mean = mean(resavg.trial);
            data.resp_sem = std(resavg.trial)/sqrt(size(resavg.trial,1));
            data.pic_dir = pic_dir;
            data.freq_range = freq_range;
            data.time_range = time_range;
            data.cbarlabel = 't-value';
            data.clim = [-5 5];
            data.bs=bsline;        
            % permutation test
            [data.powspctrm, data.un_zmapthresh, data.zmapthresh]= lfp_comptest(freq_cp,comp(comp_i,:));

            % save results
            lfp_results{roi_i,7*length(time_ranges)+comp_i} = data;           

            % plot by contourf 1-cluster 0-uncorr
            lfp_tfplot(data,0);
            lfp_tfplot(data,1);
        end
    end
    % save results
    save([pic_dir 'tf_results_' m '.mat'],'lfp_results');
end

%% plot data
roi_num = size(lfp_results,1);
data_num = size(lfp_results,2);
for roi_i=1:roi_num
%     data = lfp_results{roi_i,20};
%     lfp_tfplot(data,1);
%     data = lfp_results{roi_i,21};
%     lfp_tfplot(data,1);
    for data_i=1:data_num
        data = lfp_results{roi_i,data_i};
        lfp_tfplot(data,0);
        lfp_tfplot(data,1);
    end
end
% end