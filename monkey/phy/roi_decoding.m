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
level = 3;
trl_type = 'odorresp';
% combine 2 monkeys
[roi_lfp,~,cur_level_roi] = save_merge_2monkey(level,trl_type,monkeys);

% one monkey data
% one_data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
% label=[one_data_dir 'RM035_datpos_label.mat'];
% dates=16;
% [roi_lfp,~,cur_level_roi] = save_merge_position(one_data_dir,label,dates,level,trl_type);

%% analysis
% get number of roi
roi_num=size(cur_level_roi,1);
% number of repeats
repeat_num=100;
% time_range=[1.4 2];
time=[0:0.2:1.8];
% time=[0 0.4 0.6 1 1.2];
time_win=0.2;

conditions = {'5odor','vaodor'};
% conditions = [conditions {'6odor','banana','intensity','fakeva'}];
% trial_num = [100 100 100 100 100 100 100];
trial_num = 120*ones(1,length(conditions));
results = cell(length(conditions),2);
results(:,1) = conditions';
for time_i = 1:length(time)
    time_range=[time(time_i) time(time_i)+time_win];
    % run decoding for each condition
    for condition_i = 1:length(conditions)
        condition = conditions{condition_i};
        results_odor = cell(roi_num,repeat_num);
        tnum = trial_num(condition_i);
        % each roi
        for roi_i=1:roi_num
            % change data format and select odor condition
            cfg         = [];            
            cfg.keeptrials = 'yes';
            lfp_odor    = ft_timelockanalysis(cfg, roi_lfp{roi_i});
            % baseline correction
            cfg              = [];
            cfg.baseline     = [-0.2 -0.1];
            lfp_odor = ft_timelockbaseline(cfg, lfp_odor);
            % select time range
            cfg = [];
            cfg.latency = time_range;
            lfp_odor = ft_selectdata(cfg, lfp_odor);
            % run decoding
            parfor repeat_i=1:repeat_num
                results_odor{roi_i,repeat_i}=sample_lfp_decoding(lfp_odor, condition, tnum);
            end
            results_odor{roi_i,1}.analysis = [cur_level_roi{roi_i,1}, '_' results_odor{roi_i,1}.analysis];        
        end
        % save results for this condition
        results{condition_i,2}=results_odor;    
    end
    % save results
    time_bin=[num2str(time(time_i)) '-' num2str(time(time_i)+time_win) 's'];
    matname = ['decoding_results' num2str(tnum) '_base_linear_' time_bin '.mat'];
    save([pic_dir matname],'results')
    % plot acc
%     odor_decoding_results(matname);
%     close all
end
