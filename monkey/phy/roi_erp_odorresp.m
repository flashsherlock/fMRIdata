%% load and reorganize data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
pic_dir=[data_dir 'pic/odorresp_roi/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% generate data
label='/Volumes/WD_D/gufei/monkey_data/IMG/RM035_NMT/RM035_allpos_label5d.mat';
dates = {'200731', '200807', '200814', '200820', '200828'};
level = 4;
trl_type = 'odorresp';
[roi_lfp,roi_resp,cur_level_roi] = save_merge_position(data_dir,label,dates,level,trl_type);
% get number of roi
roi_num=size(cur_level_roi,1);
%% erp analysis
for roi_i=1:roi_num
    cur_roi=cur_level_roi{roi_i,1};
    lfp=roi_lfp{roi_i};
    resp=roi_resp{roi_i};
    % filter
    cfg = [];
    cfg.bpfilter = 'yes';
    cfg.bpfilttype = 'fir';
%     cfg.bpfreq = [0.1 0.6];
%     lfp_l = ft_preprocessing(cfg,lfp);
    cfg.bpfreq = [0.7 80];
    lfp_h = ft_preprocessing(cfg,lfp);

    % baseline correction
    cfg = [];
    cfg.keeptrials = 'yes';
    % erpl = ft_timelockanalysis(cfg, lfp_l);
    erph = ft_timelockanalysis(cfg, lfp_h);
    cfg              = [];
    cfg.baseline     = [-0.2 -0.05];
    bs=linspace(cfg.baseline(1),cfg.baseline(2),100);
    % erp_blcl = ft_timelockbaseline(cfg, erpl);
    erp_blch = ft_timelockbaseline(cfg, erph);

    erp_l_blc=cell(1,7);
    erp_h_blc=erp_l_blc;
    resavg=erp_l_blc;
    for i=1:7
    %% show low frequency signal
    % average resperation
    cfg=[];
    if i==7
        cfg.trials = find(resp.trialinfo~=6);
    else
        cfg.trials = find(resp.trialinfo==i);
    end
    resavg{i}=ft_timelockanalysis(cfg, resp);
    %% ERP
    % average trials
    cfg.avgoverrpt =  'yes';
%     erp_l_blc{i}=ft_selectdata(cfg,erp_blcl);
    erp_h_blc{i}=ft_selectdata(cfg,erp_blch);
    end
    cfg.trials = find(resp.trialinfo<=3);
    erp_h_blc{8}=ft_selectdata(cfg,erp_blch);
    cfg.trials = find(resp.trialinfo==4|resp.trialinfo==5);
    erp_h_blc{9}=ft_selectdata(cfg,erp_blch);

    time_range = [-0.2 1];
    colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#000000', '#E12A3C', '#777DDD', '#41AB5D'};
    %linewidth
    lw=cell(1,7);
    %linestyle
    ls=lw;
    for i=1:9
        if i<=5
            lw{i}=1.5;
            if i<=3
                ls{i}='-.';
            else
                ls{i}=':';
            end

        else
            lw{i}=2;
            ls{i}='-';
        end
    end
    ls{8}='-.';
    ls{9}=':';

%     figure
%     hold on
%     for i=1:7
%     plot(erp_l_blc{1}.time,1000*erp_l_blc{i}.trial,'LineStyle',ls{i},'Color',hex2rgb(colors{i}),'LineWidth',lw{i})
%     end
%     xlabel('Time (s)')
%     ylabel('Voltage (μV)')
%     set(gca,'xlim',[-1 4]);
%     title([cur_roi '-low'])
%     legend('Ind','Iso_l','Iso_h','Pea','Ban','Air','Odor')
%     hold off
%     saveas(gcf, [pic_dir cur_roi '-low'],'png')
%     close all

    % odor vs. air
    design=erp_blch.trialinfo;
    design(design~=6)=1;
    design(design==6)=2;
    cfg           = [];
    cfg.method    = 'analytic'; % using a parametric test
    cfg.statistic = 'ft_statfun_indepsamplesT'; % using independent samples
    cfg.correctm  = 'fdr'; % no multiple comparisons correction
    cfg.alpha     = 0.05;
    cfg.design    = design;
    cfg.ivar      = 1; 
    stat_t_oa = ft_timelockstatistics(cfg, erp_blch);
    % pleasant vs. unpleasant
    design=erp_blch.trialinfo;
    design(design<=3)=2;
    design(design==4|design==5)=1;
    cfg.design    = design;
    stat_t_pu = ft_timelockstatistics(cfg, erp_blch);

    % plot 5 odors and air
    figure('position',[20,0,1000,400]);
    hold on
    for i=1:6
    plot(erp_h_blc{1}.time,1000*erp_h_blc{i}.trial,'LineStyle',ls{i},'Color',hex2rgb(colors{i}),'LineWidth',lw{i})
    end
    xlabel('Time (s)')
    ylabel('Voltage (μV)')
    set(gca,'xlim',time_range);
    title([cur_roi '-odor'])
    legend('Ind','Iso_l','Iso_h','Pea','Ban','Air')
    hold off
    saveas(gcf, [pic_dir cur_roi '-high-odor'],'fig')
    saveas(gcf, [pic_dir cur_roi '-high-odor'],'png')
    close all

    % plot odor and air and valence
    figure('position',[20,0,1000,400]);
    hold on
    for i=6:9
    plot(erp_h_blc{1}.time,1000*erp_h_blc{i}.trial,'LineStyle',ls{i},'Color',hex2rgb(colors{i}),'LineWidth',lw{i})
    end
    xlabel('Time (s)')
    ylabel('Voltage (μV)')
    set(gca,'xlim',time_range);
    % ft_plot_vector(erp_l_blc{1}.time,1000*erp_h_blc{i}.trial, 'highlight', stat_t_oa.mask, 'highlightstyle', 'box','facealpha', 0.5);
    begsample = find(diff([0 stat_t_oa.mask 0])== 1);
    endsample = find(diff([0 stat_t_oa.mask 0])==-1)-1;
    for i=1:length(begsample)
      begx = erp_h_blc{1}.time(begsample(i));
      endx = erp_h_blc{1}.time(endsample(i));
      ft_plot_box([begx endx get(gca,'Ylim')], 'facecolor', [0.6 0 0], 'facealpha', 0.3, 'edgecolor', 'none');
    end
    begsample = find(diff([0 stat_t_pu.mask 0])== 1);
    endsample = find(diff([0 stat_t_pu.mask 0])==-1)-1;
    for i=1:length(begsample)
      begx = erp_h_blc{1}.time(begsample(i));
      endx = erp_h_blc{1}.time(endsample(i));
      ft_plot_box([begx endx get(gca,'Ylim')], 'facecolor', [0 0 0.6], 'facealpha', 0.3, 'edgecolor', 'none');
    end
    title([cur_roi '-valence'])
    legend('Air','Odor','Unplea','Plea')
    hold off
    saveas(gcf, [pic_dir cur_roi '-valence'],'fig')
    saveas(gcf, [pic_dir cur_roi '-valence'],'png')
    close all
end