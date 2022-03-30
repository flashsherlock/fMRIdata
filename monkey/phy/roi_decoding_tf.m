%% load and reorganize data
monkeys = {'RM035','RM033'};
% monkeys = {'RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
tf_dir=[data_dir 'pic/tf_odorresp/' m '/'];
pic_dir=[data_dir 'pic/decoding/tf/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% load time-frequency data
load([tf_dir 'tf_' m '.mat'])
% get number of roi
load([data_dir 'pic/trial_count/odor_level3_trial_count_' m '.mat'])
%% analysis
% get number of roi
roi_num=size(cur_level_roi,1);
% number of repeats
repeat_num=100;
% time_range=[1.4 2];
time=[0:0.2:1.4];
% time=[0 0.4 0.6 1 1.2];
time_win=0.6;

conditions = {'5odor','vaodor'};
% conditions = [conditions {'6odor','banana','intensity','fakeva'}];
% trial_num = [100 100 100 100 100 100 100];
trial_num = 60*ones(1,length(conditions));
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
            % baseline correction
            cfg              = [];
            cfg.baseline     = [-1 -0.5];
            tf_odor = ft_freqbaseline(cfg, freq_sep_all{roi_i});
            % select time range
            cfg = [];
            cfg.latency = time_range;
            cfg.keeptrials = 'yes';
            tf_odor = ft_freqdescriptives(cfg, tf_odor);
            % average across time
            % tf_odor.trial = squeeze(mean(tf_odor.powspctrm,4));
            tf_odor.trial = reshape(permute(squeeze(tf_odor.powspctrm),...
                [2 3 1]),[],length(tf_odor.trialinfo))';
            % remove fields
            tf_odor = rmfield(tf_odor,{'powspctrm','cfg'});
            % run decoding
            parfor repeat_i=1:repeat_num
                results_odor{roi_i,repeat_i}=sample_lfp_decoding(tf_odor, condition, tnum);
            end
            results_odor{roi_i,1}.analysis = [cur_level_roi{roi_i,1}, '_' results_odor{roi_i,1}.analysis];        
        end
        % save results for this condition
        results{condition_i,2}=results_odor;    
    end
    % save results
    time_bin=[num2str(time(time_i)) '-' num2str(time(time_i)+time_win) 's'];
    matname = ['decoding_results' num2str(tnum) '_tf_linear_' time_bin '.mat'];
    save([pic_dir matname],'results')
    % plot acc
%     odor_decoding_results(matname);
%     close all
end
