%% load data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
pic_dir=[data_dir 'pic/erp_odorresp/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
dates = {'200731', '200807', '200814', '200820', '200828'};
for i_date=1:length(dates)
cur_date=dates{i_date};
data=load([data_dir cur_date '_rm035_ane.mat']);
%% cut to trials
lfp=cell(1,length(data.lfp));
resp=lfp;
for i=1:length(data.lfp)
cfg=[];
cfg.trl=data.trl(i).odorresp;
lfp{i} = ft_redefinetrial(cfg, data.lfp{i});
resp{i} = ft_redefinetrial(cfg, data.bioresp{i});
end
%% append data
cfg=[];
cfg.keepsampleinfo='no';
lfp = ft_appenddata(cfg,lfp{:});
resp = ft_appenddata(cfg,resp{:});
% remove trials containing nan values
cfg=[];
cfg.trials=~(cellfun(@(x) any(any(isnan(x),2)),lfp.trial)...
    |cellfun(@(x) any(any(isnan(x),2)),resp.trial));
resp=ft_selectdata(cfg,resp);
channel=0;
if channel~=0
cfg.channel=strcat('WB',num2str(channel));
end
% average across channels
cfg.avgoverchan =  'yes';
lfp=ft_selectdata(cfg,lfp);

% filter
cfg = [];
cfg.bpfilter = 'yes';
cfg.bpfilttype = 'fir';
% cfg.bpfreq = [0.1 0.6];
% lfp_l = ft_preprocessing(cfg,lfp);
lfp_l = lfp;%bypass filter

cfg.bpfreq = [0.7 80];
lfp_h = ft_preprocessing(cfg,lfp);
% save([data_dir cur_date 'lfp_allchannel_lh.mat'],'lfp_l','lfp_h')

% baseline correction
cfg = [];
cfg.keeptrials = 'yes';
erpl = ft_timelockanalysis(cfg, lfp_l);
erph = ft_timelockanalysis(cfg, lfp_h);
cfg              = [];
cfg.baseline     = [-0.2 -0.05];
bs=linspace(cfg.baseline(1),cfg.baseline(2),100);
erp_blcl = ft_timelockbaseline(cfg, erpl);
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
erp_l_blc{i}=ft_selectdata(cfg,erp_blcl);
erp_h_blc{i}=ft_selectdata(cfg,erp_blch);
end
cfg.trials = find(resp.trialinfo<=3);
erp_h_blc{8}=ft_selectdata(cfg,erp_blch);
cfg.trials = find(resp.trialinfo==4|resp.trialinfo==5);
erp_h_blc{9}=ft_selectdata(cfg,erp_blch);

time_range = [-0.2 3];
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

% low frequency signal
% figure
% hold on
% for i=1:7
% plot(erp_l_blc{1}.time,1000*erp_l_blc{i}.trial,'LineStyle',ls{i},'Color',hex2rgb(colors{i}),'LineWidth',lw{i})
% end
% xlabel('Time (s)')
% ylabel('Voltage (μV)')
% set(gca,'xlim',[-1 4]);
% title([cur_date '-' num2str(channel) '-low'])
% legend('Ind','Iso_l','Iso_h','Pea','Ban','Air','Odor')
% hold off
% saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-low'],'png')
% close all

% odor vs. air
design=erp_blch.trialinfo;
design(design~=6)=1;
design(design==6)=2;
cfg           = [];
cfg.method    = 'analytic'; % using a parametric test
cfg.statistic = 'ft_statfun_indepsamplesT'; % using independent samples
cfg.correctm  = 'no'; % no multiple comparisons correction
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
figure('position',[20,0,3000,400]);
hold on
for i=1:6
plot(erp_l_blc{1}.time,1000*erp_h_blc{i}.trial,'LineStyle',ls{i},'Color',hex2rgb(colors{i}),'LineWidth',lw{i})
end
xlabel('Time (s)')
ylabel('Voltage (μV)')
set(gca,'xlim',time_range);
title([cur_date '-' num2str(channel) '-odor'])
legend('Ind','Iso_l','Iso_h','Pea','Ban','Air')
hold off
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-high-odor'],'fig')
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-high-odor'],'png')
close all

% cfg=[];
% cfg.parameter='trial';
% cfg.operation='(x1+x2+x3)/3';
% erp_h_blc{8}=ft_math(cfg,erp_h_blc{1},erp_h_blc{2},erp_h_blc{3});
% cfg.operation='(x1+x2)/2';
% erp_h_blc{9}=ft_math(cfg,erp_h_blc{4},erp_h_blc{5});

% plot odor and air and valence
figure('position',[20,0,3000,400]);
hold on
for i=6:9
plot(erp_l_blc{1}.time,1000*erp_h_blc{i}.trial,'LineStyle',ls{i},'Color',hex2rgb(colors{i}),'LineWidth',lw{i})
end
xlabel('Time (s)')
ylabel('Voltage (μV)')
set(gca,'xlim',time_range);
% ft_plot_vector(erp_l_blc{1}.time,1000*erp_h_blc{i}.trial, 'highlight', stat_t_oa.mask, 'highlightstyle', 'box','facealpha', 0.5);
begsample = find(diff([0 stat_t_oa.mask 0])== 1);
endsample = find(diff([0 stat_t_oa.mask 0])==-1)-1;
for i=1:length(begsample)
  begx = erp_l_blc{1}.time(begsample(i));
  endx = erp_l_blc{1}.time(endsample(i));
  ft_plot_box([begx endx get(gca,'Ylim')], 'facecolor', [0.6 0 0], 'facealpha', 0.3, 'edgecolor', 'none');
end
begsample = find(diff([0 stat_t_pu.mask 0])== 1);
endsample = find(diff([0 stat_t_pu.mask 0])==-1)-1;
for i=1:length(begsample)
  begx = erp_l_blc{1}.time(begsample(i));
  endx = erp_l_blc{1}.time(endsample(i));
  ft_plot_box([begx endx get(gca,'Ylim')], 'facecolor', [0 0 0.6], 'facealpha', 0.3, 'edgecolor', 'none');
end
title([cur_date '-' num2str(channel) '-valence'])
legend('Air','Odor','Unplea','Plea')
hold off
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-valence'],'fig')
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-valence'],'png')
close all
end