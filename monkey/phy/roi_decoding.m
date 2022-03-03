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
% [roi_lfp,~,cur_level_roi] = save_merge_2monkey(level,trl_type);

% one monkey data
one_data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
label=[one_data_dir 'RM035_datpos_label.mat'];
dates=16;
[roi_lfp,~,cur_level_roi] = save_merge_position(one_data_dir,label,dates,level,trl_type);

% get number of roi
roi_num=size(cur_level_roi,1);
results_5odor=cell(roi_num,1);
%% analysis
for roi_i=1:roi_num
    lfp=roi_lfp{roi_i};
    % change data format and select odor condition
    cfg         = [];
    cfg.keeptrials = 'yes';
    cfg.trials  = find(lfp.trialinfo<=5);
    lfp_odor    = ft_timelockanalysis(cfg, lfp);
    % calculate trial numbers
    t=tabulate(lfp_odor.trialinfo);
    min_trial_num=min(t(:,2));
    % t(:,2)=t(:,2)-min_trial_num;
    % number of trials
    select_num = min(100,min_trial_num);
    
    for t_i=1:size(t,1)
        % remove first several trials to balance conditions
%        if t(t_i,2)~=0
%           lfp_odor.trialinfo(find(lfp_odor.trialinfo==t(t_i,1),t(t_i,2)))=0;          
%        end
        % randomly select
       trials=find(lfp_odor.trialinfo==t(t_i,1));
       trials=trials(datasample(1:t(t_i,2),t(t_i,2)-select_num,'Replace',false));
       lfp_odor.trialinfo(trials)=0;
    end
    % select time and trial
    cfg         = [];
    cfg.latency = [0 2];
    cfg.trials  = find(lfp_odor.trialinfo~=0);
    lfp_odor=ft_selectdata(cfg, lfp_odor);
    % sort data according to conditions
    [label,I] = sort(lfp_odor.trialinfo);
    passed_data.data=squeeze(lfp_odor.trial(I,:,:));
    % zscore
%     passed_data.data=zscore(passed_data.data,0,2);
    clear lfp lfp_odor
    %% plot in 2D spaces
%     colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556',...
%         '#000000', '#E12A3C', '#777DDD', '#41AB5D'};  
%     colors = cellfun(@(x) hex2rgb(x),colors,'UniformOutput',false);
%     n_dim=2;
%     init_dim = 30;
%     perplex = 25;
%     mapped = compute_mapping(passed_data.data,'t-SNE', n_dim, init_dim, perplex);
%     mapped = compute_mapping(passed_data.data,'PCA', n_dim);
    
%     p_color = colors(label);
%     figure;
%     hold on
%     for p_i = 1:length(unique(label))
%         if n_dim==3
%             scatter3(mapped(label==p_i,1), mapped(label==p_i,2),...
%                 mapped(label==p_i,3), 15, colors{p_i},'filled');
%         else
%             scatter(mapped(label==p_i,1), mapped(label==p_i,2), 15, colors{p_i},'filled');
%     
%         end
%     end
%     title(cur_level_roi{roi_i,1})
%     legend('Ind','Iso_l','Iso_h','Peach','Banana')
    
    %% decoding
    [results_5odor{roi_i},~]=odor_decoding_function(passed_data,size(t,1));
    % only save useful information
    field_rm = setdiff(fieldnames(results_5odor{roi_i}),...
        {'analysis','accuracy_minus_chance', 'confusion_matrix'});    
    results_5odor{roi_i} = rmfield(results_5odor{roi_i},field_rm);
    results_5odor{roi_i}.analysis = [cur_level_roi{roi_i,1}, '_odors'];
end
%% plot acc
acc=zeros(1,length(results_5odor));
rois=cell(1,length(results_5odor));
for roi_i=1:length(results_5odor)
    acc(roi_i)=results_5odor{roi_i}.accuracy_minus_chance.output;
    acc(roi_i)=acc(roi_i)+results_5odor{roi_i}.accuracy_minus_chance.chancelevel;
    roi=strsplit(results_5odor{roi_i}.analysis,'_');
    rois{roi_i}=roi{1};
end
figure
bar(acc)
set(gca,'ylim',[0 100])
ylabel('ACC')
xlabel('ROI')
set(gca,'XTickLabel',rois)
% save results
% save([pic_dir 'decoding_results.mat'],'results_5odor')