%% load and reorganize data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/coherence/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% generate data
level = 3;
trl_type = 'odor';
% combine 2 monkeys
[roi_lfp,roi_resp,cur_level_roi] = save_merge_2monkey(level,trl_type);

% one monkey data
% one_data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
% label=[one_data_dir 'RM035_datpos_label.mat'];
% dates=16;
% [roi_lfp,roi_resp,cur_level_roi] = save_merge_position(one_data_dir,label,dates,level,trl_type);

%% parameters 
% number of roi
roi_num=size(cur_level_roi,1);
odor_num=7;
cross_freq_result=cell(roi_num,odor_num);
% filter
latency = [0 8];
freqs=13:3:85;
bandwidth=2;
% modulation index
nbins=20;
nsurrogates=1000;
randtype=2; %timesplice
% plot 
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#000000', '#E12A3C', '#777DDD', '#41AB5D'};
line_wid = 1.5;
%% cross frequency analysis
for roi_i=1:roi_num
    % select trials
    for odor_i=1:odor_num
        cfg         = [];
        if odor_i==7
            cfg.trials  = find(roi_lfp{roi_i}.trialinfo~=6);
        else
            cfg.trials  = find(roi_lfp{roi_i}.trialinfo==odor_i);
        end
        lfp = ft_selectdata(cfg, roi_lfp{roi_i});
        resp = ft_selectdata(cfg, roi_resp{roi_i});    
        % get low frequency phase and high frequency amplitude
        [xphase, xamp]=get_signal_pa(resp, lfp, latency, freqs, bandwidth);
        % compute modulation index
        cross_freq_result{roi_i,odor_i} = get_mi(xphase,xamp,nbins,nsurrogates,randtype);
    end
    % plot
    % 1-respiration 2-theta
    low={'-respiration','-theta'};
    for low_i=1:length(low)        
        figure('position',[20,20,600,600]);
        % modulation index
        subplot(2,1,1)
        hold on;
        title([cur_level_roi{roi_i,1} low{low_i}])
        for odor_i=1:odor_num
            plot(freqs,cross_freq_result{roi_i,odor_i}.MI(low_i,2:end),...
                'Color',hex2rgb(colors{odor_i}),'linewidth', line_wid)
        end
        set(gca,'xlim',[freqs(1) freqs(end)]);
        legend('Ind','Iso_l','Iso_h','Peach','Banana','Air','Odor')
        ylabel('Modulation Index')
        
        % p-value
        subplot(2,1,2)
        hold on;
        for odor_i=1:odor_num
            plot(freqs,cross_freq_result{roi_i,odor_i}.MIp(low_i,2:end),...
                'Color',hex2rgb(colors{odor_i}),'linewidth', line_wid)
        end
        % 0.05
        plot(freqs,0.05*ones(1,length(freqs)),'k','linestyle','--','LineWidth',2)
        set(gca,'xlim',[freqs(1) freqs(end)]);
        ylabel('p')
        xlabel('Frequency(Hz)')  
        % save picture
        saveas(gcf, [pic_dir cur_level_roi{roi_i,1} low{low_i} '-mi', '.fig'], 'fig')
        saveas(gcf, [pic_dir cur_level_roi{roi_i,1} low{low_i} '-mi', '.png'], 'png')
        close all
    end  
end
save([pic_dir 'coherence_8s.mat'],'cross_freq_result')