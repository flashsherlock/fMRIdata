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

%% calculate percentage of trials
roi_num=size(cur_level_roi,1);
percent(:,1)=cur_level_roi(:,1);
percent(:,2)=count(:,2);
number=cellfun(@length,count(:,2));
per=number/sum(number)*100;
for roi_i=1:roi_num
    percent{roi_i,2}=number(roi_i);
    percent{roi_i,3}=sprintf('%0.2f%%',per(roi_i));
    % RM035 points
    percent{roi_i,4}=size(cur_level_roi{roi_i,2},1);
    % RM033 points
    percent{roi_i,5}=size(cur_level_roi{roi_i,3},1);
end

% sum(cell2mat(percent(:,4)));
% sum(cell2mat(percent(:,5)));
%% calculate trial percentage for each monkey
monkey=cell(1,2);
monkeys=load([pic_dir 'odor_level3_trial_count_2monkey']);
monkey33=load([pic_dir 'odor_level3_trial_count_RM033']);
monkey35=load([pic_dir 'odor_level3_trial_count_RM035']);
roi_num=size(monkeys.cur_level_roi,1);
percent=cell(roi_num,7);
percent(:,1)=monkeys.cur_level_roi(:,1);
% calculate trial and percentage
number=cellfun(@length,monkeys.count(:,2));
per=number/sum(number)*100;
number33=cellfun(@length,monkey33.count(:,2));
per33=number33/sum(number33)*100;
number35=cellfun(@length,monkey35.count(:,2));
per35=number35/sum(number35)*100;
for roi_i=1:roi_num
    cur_roi = monkeys.cur_level_roi{roi_i,1};
    % monkeys trial number and percentage
    percent{roi_i,2}=number(roi_i);
    percent{roi_i,3}=sprintf('%0.2f%%',per(roi_i));
    % roi index
    idx33=find(strcmp(cur_roi,monkey33.cur_level_roi(:,1))==1);
    idx35=find(strcmp(cur_roi,monkey35.cur_level_roi(:,1))==1);
    % RM033 points
    if ~isempty(idx33)
        percent{roi_i,4}=number33(idx33);
        percent{roi_i,5}=sprintf('%0.2f%%',per33(idx33));
    end
    % RM035 points
    if ~isempty(idx35)
        percent{roi_i,6}=number35(idx35);
        percent{roi_i,7}=sprintf('%0.2f%%',per35(idx35));
    end
end
% convert to table and write to exel 
writetable(cell2table(percent),[pic_dir 'odor_trial.xlsx'])