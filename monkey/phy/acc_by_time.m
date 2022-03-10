%% load and reorganize data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/decoding/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
times=[0:0.2:1.4];
time_win=0.6;
tnum=50;
time_bin=cell(1,length(times));
% time_bin={'0.2-0.8s','0.8-1.4s','1.4-2s'};
conditions={'5odor','vaodor','airodor'};
% condition  chance acc_matrix roi-repeats-time_bin
results_bytime=cell(length(conditions),4);
results_bytime(:,1)=conditions;

% find data for each timebin
for time_i=1:length(times)
    time=[num2str(times(time_i)) '-' num2str(times(time_i)+time_win) 's'];
    time_bin{time_i}=time;
    load([pic_dir 'decoding_results' num2str(tnum) '_linear_' time '.mat']);
    % find each condition
    for condition_i = 1:length(conditions)
        condition = conditions{condition_i};
        % find results for this condition
        results_odor = results{strcmp(results(:,1),condition),2};
        repeat_num = size(results_odor,2);
        roi_num = size(results_odor,1);
        % plot acc
        [acc, rois, chance]=odor_decoding_acc(results_odor);
        results_bytime{condition_i,3}=cat(3,results_bytime{condition_i,3},acc);
        results_bytime{condition_i,2}=chance;
        % ttest
        % [h,p,ci,stats]=ttest(acc',chance);
    end
    
end

% calculate mean acc and plot
for condition_i = 1:length(conditions)
    condition = results_bytime{condition_i,1};
    % roi-timebin
    results_bytime{condition_i,4} = squeeze(mean(results_bytime{condition_i,3},2));
    % plot
    figure
    plot(results_bytime{condition_i,4})
    title(condition)
    legend(time_bin)
    ylabel('ACC')
    xlabel('ROI')
    set(gca,'XTickLabel',rois)
end

line_wid=1.5;
roi_select=[3:5 7:11 13];
roi_select=[4 7 9 11];
roi_select=[4 5 7:9 11];
for condition_i = 1:length(conditions)
    condition = results_bytime{condition_i,1};
    % line plot
    figure
    data_select=results_bytime{condition_i,4};
    data_select=data_select(roi_select,:);
    plot(data_select','linewidth', line_wid)
    % plot chance
    chance=results_bytime{condition_i,2};
    title(condition)
    legend(rois(roi_select))
    ylabel('ACC')
    xlabel('ROI')
    set(gca,'XTickLabel',time_bin)
    set(gca,'ylim',[chance chance+0.1*chance]);
end