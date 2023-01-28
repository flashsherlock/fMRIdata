%% load and reorganize data
monkeys = {'RM035','RM033'};
% monkeys = {'RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/decoding/tf/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% load time-frequency data
% load([data_dir 'tf_level5_' m '.mat'],'freq_sep_all')
% load([data_dir 'pic/trial_count/odorresp_level5_trial_count_' m '.mat'],'cur_level_roi')
% load pca data
% load([data_dir 'pic/pca_power/noair/' m '/data_pca-33.mat'])
% load([data_dir 'pic/pca_power/noair/' m '/data_pca_per-33.mat'])
% load pca sep data
load([pic_dir '/data_pca-33.mat'])
%% analysis
% get number of roi
roi_con = {'roi7'};
roi_connum=length(roi_con);
data_time=[-3:0.05:3];
% time before -1s (41) may contain nan
time=[-0.25:0.05:2.5];
% each tf data point represent 0.05s
time_win=0.5;
conditions = {'5odor'};
results = cell(roi_connum,length(conditions));
% run decoding for each condition
for condition_i = 1:length(conditions)
    condition = conditions{condition_i};        
    % each roi_condition
    for roi_coni=1:roi_connum
        % save results for this condition
        results{roi_coni,condition_i} = sample_tf_decoding(data_pca, condition, roi_con{roi_coni},time,time_win,data_time );
        % save permutated results
    end
end
%% plot
for condition_i = 1:length(conditions)
    condition = conditions{condition_i};        
    % each roi_condition
    for roi_coni=1:roi_connum
        roic = roi_con{roi_coni};
        results_odor = results{roi_coni,condition_i};
        % get acc
        acc = cellfun(@(x) x.accuracy_minus_chance.output+x.accuracy_minus_chance.chancelevel,results_odor(:,3:end));
        figure
        plot(time,acc')
        set(gca,'xlim',[time(1),time(end)],'ylim',[0,100])
        legend(results_odor(:,2))
        ylabel('Accuracy')
        title([roic '-' condition])
    end
end