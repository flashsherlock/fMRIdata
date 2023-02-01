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
load([data_dir 'tf_sep_' m '.mat'])
%% analysis
% get number of roi
roi_con = {'HA'};
roi_connum=length(roi_con);
data_time=[-3:0.05:3];
% time before -1s (41) may contain nan
time=[-0.25:0.05:2.5];
% each tf data point represent 0.05s
time_win=0.5;
conditions = {'5odor'};
results = cell(roi_connum,length(conditions));
% permutated results
per_num = 1000;
results_per = cell(roi_connum,length(conditions),per_num);
% run decoding for each condition
for condition_i = 1:length(conditions)
    condition = conditions{condition_i};        
    % each roi_condition
    for roi_coni=1:roi_connum
        % save results for this condition
        results{roi_coni,condition_i} = sample_tf_decoding(data_pca, condition, roi_con{roi_coni},time,time_win,data_time );
        % save permutated results
        for per_i=1:per_num
            % display progress
            len = 50;
            fin = floor(len*per_i/per_num);
            disp([num2str([condition_i roi_coni per_i]) repmat('=',1,fin) '>' repmat('_',1,len-fin)])
            % time range for selecting tf data
            time_range = [data_time(1) data_time(end)];
            data_pca_per = pca_permutation_sep( freq_sep_all, cur_level_roi, time_range, per_i );
            results_per{roi_coni,condition_i,per_i} = sample_tf_decoding(data_pca_per, condition, roi_con{roi_coni},time,time_win,data_time );
        end
    end
end
save([pic_dir 'results_HA_sep-33_' num2str(time_win) '.mat'],'results','results_per','-v7.3')
%% plot
for condition_i = 1:length(conditions)
    condition = conditions{condition_i};        
    % each roi_condition
    for roi_coni=1:roi_connum
        roic = roi_con{roi_coni};
        results_odor = results{roi_coni,condition_i};
        % get acc
        acc = cellfun(@(x) x.output+x.chancelevel,results_odor(:,3:end));
        figure
        plot(time,acc')
        set(gca,'xlim',[time(1),time(end)],'ylim',[0,100])
        legend(results_odor(:,2))
        ylabel('Accuracy')
        title([roic '-' condition])
    end
end