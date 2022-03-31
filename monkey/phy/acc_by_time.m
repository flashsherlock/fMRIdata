%% load and reorganize data
m = 'RM035';
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/decoding/tf/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
times=[0:0.2:1];
time_win=1;
tnum=80;
time_bin=cell(1,length(times));
% time_bin={'0.2-0.8s','0.8-1.4s','1.4-2s'};
% conditions = {'5odor', 'vaodor', 'airodor'};
conditions={'5odor','vaodor'};
% condition  2-chance 3-acc_matrix:roi-repeats-time_bin 4-mean acc 5-p-value
results_bytime=cell(length(conditions),5);
results_bytime(:,1)=conditions;

% find data for each timebin
for time_i=1:length(times)
    time=[num2str(times(time_i)) '-' num2str(times(time_i)+time_win) 's'];
    time_bin{time_i}=time;
    load([pic_dir 'decoding_results' num2str(tnum) '_tf_linear_' time '.mat']);
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
        [h,p,ci,stats]=ttest(acc',chance);
        results_bytime{condition_i,5}=cat(2,results_bytime{condition_i,5},p');
    end
    
end

% calculate mean acc and plot
for condition_i = 1:length(conditions)
    condition = results_bytime{condition_i,1};
    % roi-timebin
    results_bytime{condition_i,4} = squeeze(mean(results_bytime{condition_i,3},2));
    % bar plot
%     figure
%     plot(results_bytime{condition_i,4})
%     title(condition)
%     legend(time_bin)
%     ylabel('ACC')
%     xlabel('ROI')
%     set(gca,'XTickLabel',rois)
end

line_wid=1.5;
% large regiion
% roi_select=[3:5 7:11 13];
switch m
    case 'RM033'
        roi_select=[4 5 8 9 7 11];
    case 'RM035'
        roi_select=[2 3 5 6 4 8];
    otherwise
        roi_select=[4 5 8 9 7 11];
end
colors = {'#cf3f4f', '#DE7B14', '#ECB556', '#41AB5D', '#149ade', '#69b4d9', '#4292C6', '#E12A3C', '#cb2111'};
for condition_i = 1:length(conditions)
    condition = results_bytime{condition_i,1};
    % line plot
    figure('Position',[20 20 800 600])
    subplot(2,1,1)
    hold on
    data_select=results_bytime{condition_i,4};
    for i=1:length(roi_select)
        plot(data_select(roi_select(i),:),'Color',hex2rgb(colors{i}),'linewidth', line_wid)
    end
    % plot chance
    chance=results_bytime{condition_i,2};
    title(condition)
    legend(rois(roi_select),'Location','eastoutside')
    ylabel('ACC')    
    set(gca,'xlim',[1 length(times)])
    set(gca,'XTick',1:length(times))
    set(gca,'XTickLabel',time_bin)
    set(gca,'ylim',[min(min(data_select(roi_select,:))) max(max(data_select(roi_select,:)))]);
    % p-value
    subplot(2,1,2)
    hold on
    p_select=results_bytime{condition_i,5};
    % replace zeros with eps
    p_select=max(p_select,eps);
    for i=1:length(roi_select)
        plot(p_select(roi_select(i),:),'Color',hex2rgb(colors{i}),'linewidth', line_wid);
    end
    ylabel('p')
    xlabel('Time')
    set(gca,'yscale','log');
    set(gca,'xlim',[1 length(times)])
    set(gca,'XTick',1:length(times))
    set(gca,'XTickLabel',time_bin)
    legend(rois(roi_select),'Location','eastoutside')
    xnum = get(gca,'Xlim');
    plot(xnum,[0.05 0.05],'k','linestyle','--','LineWidth',2)
    % save plot
    saveas(gcf, [pic_dir condition '_tf_linear_' num2str(tnum) , '.png'], 'png')
    close all
end