%% load and reorganize data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/decoding/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
time_bin={'0.2-0.8s','0.8-1.4s','1.4-2s'};
conditions={'5odor','vaodor','airodor'};
% condition acc_matrix roi-repeats-time_bin
results_bytime=cell(length(conditions),3);
results_bytime(:,1)=conditions;

% find data for each timebin
for time_i=1:length(time_bin)
    time=time_bin{time_i};
    load([pic_dir 'linear_' time '/decoding_results_linear_' time '.mat']);
    % find each condition
    for condition_i = 1:length(conditions)
        condition = conditions{condition_i};
        % find results for this condition
        results_odor = results{strcmp(results(:,1),condition),2};
        repeat_num = size(results_odor,2);
        roi_num = size(results_odor,1);
        % plot acc
        [acc, rois, chance]=odor_decoding_acc(results_odor);
        results_bytime{condition_i,2}=cat(3,results_bytime{condition_i,2},acc);
        % ttest
        % [h,p,ci,stats]=ttest(acc',chance);
    end
    
end

% calculate mean acc and plot
for condition_i = 1:length(conditions)
    condition = results_bytime{condition_i,1};
    results_bytime{condition_i,3} = squeeze(mean(results_bytime{condition_i,2},2));
    % plot
    figure
    bar(results_bytime{condition_i,3})
    title(condition)
    legend(time_bin)
    ylabel('ACC')
    xlabel('ROI')
    set(gca,'XTickLabel',rois)
end
