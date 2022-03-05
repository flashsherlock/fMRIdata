%% load and reorganize data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/decoding/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% generate data
level = 3;
trl_type = 'odorresp';
% combine 2 monkeys
[roi_lfp,~,cur_level_roi] = save_merge_2monkey(level,trl_type);

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
time_range=[0 2];
conditions = {'6odor','banana','5odor'};
trial_num = [100 100 100];
results = cell(length(conditions),2);
results(:,1) = conditions';

% run decoding for each condition
for condition_i = 1:length(conditions)
    condition = conditions{condition_i};
    results_odor = cell(roi_num,repeat_num);
    tnum = trial_num(condition_i);
    % each roi
    for roi_i=1:roi_num
        % change data format and select odor condition
        cfg         = [];
        cfg.latency = time_range;
        cfg.keeptrials = 'yes';
        lfp_odor    = ft_timelockanalysis(cfg, roi_lfp{roi_i});
        % run decoding
        parfor repeat_i=1:repeat_num
            results_odor{roi_i,repeat_i}=sample_lfp_decoding(lfp_odor, condition, tnum);
        end
        results_odor{roi_i,1}.analysis = [cur_level_roi{roi_i,1}, '_' results_odor{roi_i,1}.analysis];        
    end
    % save results for this condition
    results{condition_i,2}=results_odor;
    % plot acc
    [acc, rois]=odor_decoding_acc(results_odor);
    figure
    bar(mean(acc,2))
    set(gca,'ylim',[0 100])
    ylabel('ACC')
    xlabel('ROI')
    set(gca,'XTickLabel',rois)
    title([condition '-repeat: ' num2str(repeat_num)])
end
% save results
save([pic_dir 'decoding_results_other.mat'],'results')