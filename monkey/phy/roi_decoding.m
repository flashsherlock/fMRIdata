%% load and reorganize data
monkeys = {'RM035','RM033'};
% monkeys = {'RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/decoding/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% generate data
level = 5;
trl_type = 'odorresp';
% combine 2 monkeys
[roi_lfp,~,cur_level_roi] = save_merge_2monkey(level,trl_type,monkeys);

% one monkey data
% one_data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
% label=[one_data_dir 'RM035_datpos_label.mat'];
% dates=16;
% [roi_lfp,~,cur_level_roi] = save_merge_position(one_data_dir,label,dates,level,trl_type);

%% analysis
% set seed
rng(666);
% get number of roi
roi_num=size(cur_level_roi,1);
% number of repeats
repeat_num=100;
% time_range=[1.4 2];
time=[-0.4:0.05:1];
% time=[0 0.4 0.6 1 1.2];
time_win=0.2;

conditions = {'5odor','vaodor'};
% number of classes
nlabels = [5 2];
% conditions = [conditions {'6odor','banana','intensity','fakeva'}];
% trial_num = [100 100 100 100 100 100 100];
trial_num = 120*ones(1,length(conditions));
results_all = cell(length(conditions),2);
results_all(:,1) = conditions';

% run decoding for each condition
for condition_i = 1:length(conditions)
    condition = conditions{condition_i};
    results_odor = cell(roi_num,repeat_num,length(time));
    tnum = trial_num(condition_i);
    nlabel = nlabels(condition_i);
    % each roi
    for roi_i=1:roi_num
        % change data format and select odor condition
        cfg         = [];            
        cfg.keeptrials = 'yes';
        lfp_odor    = ft_timelockanalysis(cfg, roi_lfp{roi_i});
        % baseline correction
        cfg              = [];
        cfg.baseline     = [-0.2 0];
        lfp_odor = ft_timelockbaseline(cfg, lfp_odor);
        % select time range
        cfg = [];
        cfg.latency = [time(1) time(end)+time_win];
        lfp_odor = ft_selectdata(cfg, lfp_odor);
        lfp_odor.trialinfo_add = roi_lfp{roi_i}.trialinfo_add;
        % sampleling
        sample = cell(repeat_num,1);
        parfor repeat_i=1:repeat_num
            sample{repeat_i}=sample_lfp_decoding(lfp_odor, condition, tnum);
        end
    
        % decoding
        fs = 1000;
        % start column of additional trial infomation
        add_minus = abs(time(1))*fs;
        data_add = add_minus+2+(time(end)+time_win)*fs;
        for time_i = 1:length(time)
            start = add_minus+1+time(time_i)*fs;
            stop = add_minus+1+(time(time_i)+time_win)*fs;
            parfor repeat_i=1:repeat_num
                passed_data = sample{repeat_i};
                passed_data.data = [passed_data.data(:,start:stop) passed_data.data(:,data_add:end)];
                [results_odor{roi_i,repeat_i,time_i},~]=odor_decoding_function(passed_data,nlabel);
                % return condtion and number of selection
                select_num = size(passed_data.data,1)/nlabel;
                results_odor{roi_i,repeat_i,time_i}.analysis=[condition '_' num2str(select_num')];
            end
            % analysis label
            results_odor{roi_i,1,time_i}.analysis = [cur_level_roi{roi_i,1}, '_' results_odor{roi_i,1,time_i}.analysis];        
        end
    end
    % save results for this condition
    results_all{condition_i,2}=results_odor;  
end   

for time_i = 1:length(time)
     % save results
    time_bin=[num2str(time(time_i)) '-' num2str(time(time_i)+time_win) 's'];
    matname = ['decoding_results' num2str(tnum) '_base_linear_' time_bin '.mat'];
    % results for each time bin
    results = results_all(:,1);
    for condition_i = 1:length(conditions)
        results_odor = results_all{condition_i,2};
        results{condition_i,2} = results_odor(:,:,time_i);
    end
    save([pic_dir matname],'results')
    % plot acc
    % odor_decoding_results(matname,monkeys);
    % close all
end