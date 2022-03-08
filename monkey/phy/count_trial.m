%% load and reorganize data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/trial_count/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% % generate data
% level = 3;
% trl_type = 'odorresp';
% % combine 2 monkeys
% [roi_lfp,~,cur_level_roi] = save_merge_2monkey(level,trl_type);

%% count
% number of roi
roi_num=size(cur_level_roi,1);
odor_num=7;
count=cell(roi_num,3);
count_odor=zeros(1,odor_num+1);
for roi_i=1:roi_num
    count{roi_i,1}=[cur_level_roi{roi_i,1} '_' trl_type];
    % all trials
    count{roi_i,2}=roi_lfp{roi_i}.trialinfo;
    % select trials
    count_odor(end)=length(roi_lfp{roi_i}.trialinfo);
    for odor_i=1:odor_num
        cfg         = [];
        if odor_i==7
            cfg.trials  = find(roi_lfp{roi_i}.trialinfo~=6);
        else
            cfg.trials  = find(roi_lfp{roi_i}.trialinfo==odor_i);
        end
        count_odor(odor_i)=length(cfg.trials);
    end
    % odor trials
    count{roi_i,3}=count_odor;
    % num2str
    % count{roi_i,3}=num2str(count_odor);
end
% save
save([pic_dir trl_type '_level' num2str(level) '_trial_count'],'count','cur_level_roi');