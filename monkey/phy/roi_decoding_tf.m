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
% get number of roi
roi_con = {'roi7'};
roi_connum=length(roi_con);
data_time=[-3:0.05:3];
% time before -1s (41) may contain nan
time=[-0.25:0.05:2.5];
% each tf data point represent 0.05s
time_win=0.5;
% select freqency
data_freq = logspace(log10(1),log10(200),51);
data_freq = data_freq(1:42);% below 80
freq = data_freq>=13;
per_num = 1000;
conditions = {'5odor'};
% conditions = {'intensity'};
% conditions = {'valence'};

%% analysis
% load time-frequency data
% load([data_dir 'tf_level5_' m '.mat'],'freq_sep_all')
% load([data_dir 'pic/trial_count/odorresp_level5_trial_count_' m '.mat'],'cur_level_roi')
% load pca data
% load([data_dir 'pic/pca_power/noair/' m '/data_pca-33.mat'])
% load([data_dir 'pic/pca_power/noair/' m '/data_pca_per-33.mat'])
% load pca sep data
load([pic_dir '/data_pca-33.mat'])
load([data_dir 'tf_sep_' m '.mat'])
results = cell(roi_connum,length(conditions));
% permutated results
results_per = cell(roi_connum,length(conditions),per_num);
% run decoding for each condition
for condition_i = 1:length(conditions)
    condition = conditions{condition_i};        
    % each roi_condition
    for roi_coni=1:roi_connum
        % save results for this condition
        results{roi_coni,condition_i} = sample_tf_decoding(data_pca, condition, roi_con{roi_coni},time,time_win,data_time,freq );
        % save permutated results
        for per_i=1:per_num
            % display progress
            len = 50;
            fin = floor(len*per_i/per_num);
            disp([num2str([condition_i roi_coni per_i]) repmat('=',1,fin) '>' repmat('_',1,len-fin)])
            % time range for selecting tf data
            time_range = [data_time(1) data_time(end)];
            % data_pca_per = pca_permutation_sep( freq_sep_all, cur_level_roi, time_range, per_i );
            data_pca_per = data_pca;
            results_per{roi_coni,condition_i,per_i} = sample_tf_decoding(data_pca_per, condition, roi_con{roi_coni},time,time_win,data_time,freq,per_i );
        end
    end
end
save([pic_dir 'results_sep-33_freq13_' num2str(time_win) '.mat'],'results','results_per','-v7.3')
%% plot
% load([pic_dir 'results_sep-33_freq13_' num2str(time_win) '.mat'])
linew = 1.5;
fontsize = 18;
for condition_i = 1:length(conditions)
    condition = conditions{condition_i};        
    % each roi_condition
    for roi_coni=1:roi_connum        
        roic = roi_con{roi_coni};
        results_odor = results{roi_coni,condition_i};
        % get acc
        acc = cellfun(@(x) x.output+x.chancelevel,results_odor(:,3:end));
        % peprmutated acc
        acc_per = zeros(size(acc,1),size(acc,2),per_num);        
        for per_i=1:per_num
            results_odor_per = results_per{roi_coni,condition_i,per_i};
            % get acc
            acc_per(:,:,per_i) = cellfun(@(x) x.output+x.chancelevel,results_odor_per(:,3:end));
        end
        % substract baseline
        baseline = time<=0;
        acc = acc-mean(acc(:,baseline),2);
        acc_per = acc_per - mean(acc_per(:,baseline,:),2);
        per_mean = mean(acc_per,3);
        per_std = std(acc_per,0,3);
        p = (sum(bsxfun(@gt, acc_per, acc),3)+1 )./(size(acc_per,3)+1);
        % zacc = (acc-per_mean)./per_std;
        figure('position',[20,1000,1000,600]);
        subplot(2,2,1)
        plot(time,acc','LineWidth',linew)
        set(gca,'xlim',[time(1),time(end)])
        ylabel('Accuracy') 
        legend(results_odor(:,2)) 
        set(gca, 'FontSize',fontsize)
        
        subplot(2,2,2)
        plot(time,(acc-per_mean)','LineWidth',linew)
        set(gca,'xlim',[time(1),time(end)])
        ylabel('Acc-Per') 
        set(gca, 'FontSize',fontsize)
        
        subplot(2,2,3)
        plot(time,per_mean','LineWidth',linew)
        set(gca,'xlim',[time(1),time(end)])
        ylabel('Permutated Acc')
        set(gca, 'FontSize',fontsize)
        
        subplot(2,2,4)
        plot(time,p','LineWidth',linew)
        hold on
        plot(time,0.05*ones(length(time),1),'r','linestyle','--','LineWidth',linew)
        set(gca,'xlim',[time(1),time(end)])
        set(gca,'yscale','log');
        set(gca,'ylim',[0 1]);
        ylabel('p') 
        % legend([results_odor(:,2);'p']) 
        set(gca, 'FontSize',fontsize)
        suptitle([roic '-' condition])
        saveas(gcf,[pic_dir roic '-' condition '.svg'],'svg')
    end
end
%% plot results when roi_con=='each'
% % combine to 7 rois
% roi_focus = {{'CoA'},{'APir','VCo'}; {'BA'}, {'BL','PaL'};{'CeMe'},{'Ce','Me'};...
%     {'BM'},{'BM'};{'BL'},{'BL'};{'Hi'},{'Hi'};{'S'},{'S'}};
% roisdata = cell(size(roi_focus,1),2);
% % get acc
% results_odor = results{roi_coni,condition_i};
% acc = cellfun(@(x) x.output+x.chancelevel,results_odor(:,3:end));
% for roi_i=1:size(roisdata,1)
%     roisdata(roi_i,1) = roi_focus{roi_i,1};    
%     roisdata{roi_i,2} = mean(acc(ismember(results_odor(:,2),roi_focus{roi_i,2}),:),1);
% end
% figure
% plot(time,cell2mat(roisdata(:,2))')
% set(gca,'xlim',[time(1),time(end)])
% ylabel('Accuracy') 
% legend(roisdata(:,1))