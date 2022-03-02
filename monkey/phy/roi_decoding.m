%% load and reorganize data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/decoding/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% generate data
level = 3;
trl_type = 'odor';
% combine 2 monkeys
[roi_lfp,roi_resp,cur_level_roi] = save_merge_2monkey(level,trl_type);

% get number of roi
roi_num=size(cur_level_roi,1);
results_5odor=cell(roi_num,1);
%% power spectrum analysis
for roi_i=3:roi_num
    lfp=roi_lfp{roi_i};
    % change data format and select odor condition
    cfg         = [];
    cfg.keeptrials = 'yes';
    cfg.trials  = find(lfp.trialinfo<=5);
    lfp_odor    = ft_timelockanalysis(cfg, lfp);
    % remove first several trials to balance conditions
    t=tabulate(lfp_odor.trialinfo);
    t(:,2)=t(:,2)-min(t(:,2));
    for t_i=1:size(t,1)
       if t(t_i,2)~=0
          lfp_odor.trialinfo(find(lfp_odor.trialinfo==t(t_i,1),t(t_i,2)))=0; 
       end
    end
    % select time and trial
    cfg         = [];
    cfg.latency = [0 7];
    cfg.trials  = find(lfp_odor.trialinfo~=0);
    lfp_odor=ft_selectdata(cfg, lfp_odor);
    % sort data according to conditions
    [~,I] = sort(lfp_odor.trialinfo);
    passed_data.data=squeeze(lfp_odor.trial(I,:,:));
    clear lfp lfp_odor
    [results_5odor{roi_i},~]=odor_decoding_function(passed_data,size(t,1));
    % only save useful information
    field_rm = setdiff(fieldnames(results_5odor{roi_i}),...
        {'analysis','accuracy_minus_chance', 'confusion_matrix'});    
    results_5odor{roi_i} = rmfield(results_5odor{roi_i},field_rm);
    results_5odor{roi_i}.analysis = [cur_level_roi{roi_i,1}, '_odors'];
end
% save results
save([pic_dir 'decoding_results.mat'],'results_5odor')