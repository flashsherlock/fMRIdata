%% load and reorganize data
% monkeys = {'RM035','RM033'};
monkeys = {'RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/powerspec/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
%% generate data or load data
if exist([pic_dir 'powspec_odor_7s_1_80hz.mat'],'file')
    load([pic_dir 'powspec_odor_7s_1_80hz.mat']);
    roi_num=size(cur_level_roi,1);
else
    level = 3;
    trl_type = 'odorresp';

    % one monkey data
    % one_data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
    % label=[one_data_dir 'RM035_datpos_label.mat'];
    % dates=[1 16 17];
    % [roi_lfp,~,cur_level_roi] = save_merge_position(one_data_dir,label,dates,level,trl_type);

    % combine 2 monkeys
    [roi_lfp,roi_resp,cur_level_roi] = save_merge_2monkey(level,trl_type,monkeys);
    roi_num=size(cur_level_roi,1);
    % power spectrum analysis
    spectr_resp_all=cell(roi_num,1);
    spectr_lfp_all=spectr_resp_all;
    for roi_i=1:roi_num
        lfp=roi_lfp{roi_i};
    %     resp=roi_resp{roi_i};
        % select time
        cfg         = [];
        cfg.latency = [0 2];
        lfp=ft_selectdata(cfg, lfp);
    %     resp=ft_selectdata(cfg, resp);
        % frequency spectrum
        cfg         = [];
        cfg.output  = 'pow';
        cfg.method  = 'mtmfft';
        cfg.taper   = 'hanning';
        cfg.keeptrials = 'yes';
    %     cfg.foilim = [0.1 80];
        cfg.foi = 1:1:80;
    %     spectr_resp_all{roi_i}  = ft_freqanalysis(cfg, resp);
        spectr_lfp_all{roi_i}  = ft_freqanalysis(cfg, lfp);
    end
    % save data to mat file
    save([pic_dir 'powspec_odor_7s_1_80hz.mat'],'spectr_lfp_all','cur_level_roi')
end
%% average each condition
% number of odors
odor_num=7;
spectr_resp=cell(roi_num,odor_num);
spectr_lfp=spectr_resp;
% zscore
spectr_respz=cell(roi_num,odor_num);
spectr_lfpz=spectr_respz;
for roi_i=1:roi_num
    for odor_i=1:odor_num
        lfp = spectr_lfp_all{roi_i};
%         resp = spectr_resp_all{roi_i};
        % frequency spectrum
        cfg         = [];
        cfg.avgoverrpt =  'no';
        if odor_i==7
            cfg.trials  = find(lfp.trialinfo~=6);
        else
            cfg.trials  = find(lfp.trialinfo==odor_i);
        end
%         spectr_resp{roi_i,odor_i} = ft_selectdata(cfg, resp);
        spectr_lfp{roi_i,odor_i} = ft_selectdata(cfg, lfp);
        % zscore
        lfp.powspctrm = zscore(lfp.powspctrm,0,1);
%         resp = spectr_resp_all{roi_i};
%         resp.powspctrm = zscore(resp.powspctrm,0,1);
        spectr_lfpz{roi_i,odor_i} = ft_selectdata(cfg, lfp);
    end
end
%% statistics
spectr_resp_p=cell(roi_num,odor_num-1);
spectr_lfp_p=spectr_resp_p;
for roi_i=1:roi_num
    for odor_i=1:odor_num-1
    % odor vs. air
    design=spectr_lfp_all{roi_i}.trialinfo;
    if odor_i==odor_num-1
        design(design~=6)=1;
    else
        design(design==odor_i)=1;
    end
    design(design==6)=2;
    cfg           = [];
    cfg.method    = 'analytic'; % using a parametric test
    cfg.statistic = 'ft_statfun_indepsamplesT'; % using independent samples
    cfg.correctm  = 'no'; % no multiple comparisons correction
    cfg.alpha     = 0.05;
    cfg.design    = design;
    cfg.ivar      = 1; 
%     spectr_resp_p{roi_i,odor_i} = ft_freqstatistics(cfg, spectr_resp_all{roi_i});
    spectr_lfp_p{roi_i,odor_i} = ft_freqstatistics(cfg, spectr_lfp_all{roi_i});
    end
end
%% plot
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#000000', '#E12A3C', '#777DDD', '#41AB5D'};
colors_cp = colors([1:5 7]);
smooth_win=1;
freq_win=[1 80];
line_wid=1.5;
% lfp
for roi_i=1:roi_num
    % plot raw power
    figure('position',[20,20,600,600],'Renderer', 'Painters');
    subplot(3,1,1)
    hold on;
    for odor_i=1:odor_num
        plot(spectr_lfp{roi_i,odor_i}.freq, smooth(mean(spectr_lfp{roi_i,odor_i}.powspctrm,1),smooth_win),'Color',hex2rgb(colors{odor_i}),'linewidth', line_wid)
    end
    set(gca,'yscale','log');
    set(gca,'xlim',freq_win);
    title(cur_level_roi{roi_i,1})
    legend('Ind','Iso_l','Iso_h','Peach','Banana','Air','Odor')
    ylabel('Power')
    set(gca, 'FontSize', 18);
    % plot zscore
    subplot(3,1,2)
    hold on;
    for odor_i=1:odor_num
        plot(spectr_lfpz{roi_i,odor_i}.freq, smooth(mean(spectr_lfpz{roi_i,odor_i}.powspctrm,1),smooth_win),'Color',hex2rgb(colors{odor_i}),'linewidth', line_wid)
%         shadedEBar(spectr_lfpz{roi_i,odor_i}.freq,squeeze(mean(spectr_lfpz{roi_i,odor_i}.powspctrm,1)),...
%            1.96*squeeze(std(spectr_lfpz{roi_i,odor_i}.powspctrm,1)/sqrt(size(spectr_lfpz{roi_i,odor_i}.powspctrm,1))),...
%           'lineProps',{'Color',hex2rgb(colors{odor_i}),'LineWidth',line_wid},'patchSaturation',0.2)
    end
    set(gca,'xlim',freq_win);
    ylabel('ZPower')
    set(gca, 'FontSize', 18);
    % plot p value
    subplot(3,1,3)
    hold on
    for odor_i=1:odor_num-1
        % replace 0 with eps
        spectr_lfp_p{roi_i,odor_i}.prob=max(spectr_lfp_p{roi_i,odor_i}.prob,eps);
        plot(spectr_lfp_p{roi_i,odor_i}.freq, smooth(spectr_lfp_p{roi_i,odor_i}.prob,smooth_win),'Color',hex2rgb(colors_cp{odor_i}),'linewidth', line_wid)
    end
    freq_num=length(spectr_lfp_p{roi_i,odor_i}.freq);
    % number of comparision
    cmp_num=sum(spectr_lfp_p{roi_i,odor_i}.freq >freq_win(1) & spectr_lfp_p{roi_i,odor_i}.freq <freq_win(2));
    plot(spectr_lfp_p{roi_i,odor_i}.freq,0.05*ones(1,freq_num),'k','linestyle','--','LineWidth',2)
    plot(spectr_lfp_p{roi_i,odor_i}.freq,0.05/cmp_num*ones(1,freq_num),'r','linestyle','--','LineWidth',2)
    set(gca,'yscale','log');
    set(gca,'ylim',[0 1]);
    set(gca,'yminortick','off');
    set(gca,'xlim',freq_win);
    xlabel('Frequency (Hz)')
    ylabel('p')
    set(gca, 'FontSize', 18);
    saveas(gcf, [pic_dir cur_level_roi{roi_i,1} '-zpower', '.fig'], 'fig')
    saveas(gcf, [pic_dir cur_level_roi{roi_i,1} '-zpower', '.png'], 'png')
    saveas(gcf, [pic_dir cur_level_roi{roi_i,1} '-zpower', '.pdf'], 'pdf')
    close all
end
%% resp
% freq_win=[0.1 10];
% for roi_i=1:roi_num
%     % plot raw power
%     figure('position',[20,20,600,600]);
%     subplot(3,1,1)
%     hold on;
%     for odor_i=1:odor_num
%         plot(spectr_resp{roi_i,odor_i}.freq, smooth(mean(spectr_resp{roi_i,odor_i}.powspctrm,1),smooth_win),'Color',hex2rgb(colors{odor_i}),'linewidth', line_wid)
%     end
%     set(gca,'yscale','log');
%     set(gca,'xlim',freq_win);
%     title(cur_level_roi{roi_i,1})
%     legend('Ind','Iso_l','Iso_h','Peach','Banana','Air','Odor')
%     ylabel('Power')
%     % plot zscore
%     subplot(3,1,2)
%     hold on;
%     for odor_i=1:odor_num
%         plot(spectr_respz{roi_i,odor_i}.freq, smooth(mean(spectr_respz{roi_i,odor_i}.powspctrm,1),smooth_win),'Color',hex2rgb(colors{odor_i}),'linewidth', line_wid)
%     end
%     set(gca,'xlim',freq_win);
%     ylabel('ZPower')
%     % plot p value
%     subplot(3,1,3)
%     hold on
%     for odor_i=1:odor_num-1
%         % replace 0 with eps
%         spectr_resp_p{roi_i,odor_i}.prob=max(spectr_resp_p{roi_i,odor_i}.prob,eps);
%         plot(spectr_resp_p{roi_i,odor_i}.freq, smooth(spectr_resp_p{roi_i,odor_i}.prob,smooth_win),'Color',hex2rgb(colors_cp{odor_i}),'linewidth', line_wid)
%     end
%     freq_num=length(spectr_resp_p{roi_i,odor_i}.freq);
%     % number of comparision
%     cmp_num=sum(spectr_resp_p{roi_i,odor_i}.freq >freq_win(1) & spectr_resp_p{roi_i,odor_i}.freq <freq_win(2));
%     plot(spectr_resp_p{roi_i,odor_i}.freq,0.05*ones(1,freq_num),'k','linestyle','--','LineWidth',2)
%     plot(spectr_resp_p{roi_i,odor_i}.freq,0.05/cmp_num*ones(1,freq_num),'r','linestyle','--','LineWidth',2)
%     set(gca,'yscale','log');
%     set(gca,'ylim',[0 1]);
%     set(gca,'xlim',freq_win);
%     xlabel('Frequency (Hz)')
%     ylabel('p')
%     saveas(gcf, [pic_dir 'resp-' cur_level_roi{roi_i,1} '-zpower', '.fig'], 'fig')
%     saveas(gcf, [pic_dir 'resp-' cur_level_roi{roi_i,1} '-zpower', '.png'], 'png')
%     close all
% end