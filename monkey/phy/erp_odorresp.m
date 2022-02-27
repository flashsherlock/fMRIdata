%% load data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/erp_odorresp/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
%% generate data
level = 3;
trl_type = 'odorresp';
% combine 2 monkeys
[roi_lfp,roi_resp,cur_level_roi] = save_merge_2monkey(level,trl_type);
% get number of roi
roi_num=size(cur_level_roi,1);
odor_num=7;
%% analyze
frequency=[0.7 80];
time_range = [-0.2 1];
for roi_i=3:roi_num
cur_roi=cur_level_roi{roi_i,1};
lfp=roi_lfp{roi_i};

% filter
cfg = [];
cfg.bpfilter = 'yes';
cfg.bpfilttype = 'fir';
cfg.bpfreq = frequency;
lfp_filt = ft_preprocessing(cfg,lfp);

% baseline correction
cfg = [];
cfg.keeptrials = 'yes';
erp = ft_timelockanalysis(cfg, lfp_filt);
cfg              = [];
cfg.baseline     = [-0.2 -0.05];
bs=linspace(cfg.baseline(1),cfg.baseline(2),100);
erp_blc_all = ft_timelockbaseline(cfg, erp);

erp_blc=cell(1,odor_num);
resavg=erp_blc;
for i=1:7
%% ERP
% average trials
cfg=[];
if i==7
    cfg.trials = find(lfp.trialinfo~=6);
else
    cfg.trials = find(lfp.trialinfo==i);
end
resavg{i}=ft_timelockanalysis(cfg, lfp);
cfg.avgoverrpt =  'yes';
erp_blc{i}=ft_selectdata(cfg,erp_blc_all);
end
cfg.trials = find(lfp.trialinfo<=3);
erp_blc{8}=ft_selectdata(cfg,erp_blc_all);
cfg.trials = find(lfp.trialinfo==4|lfp.trialinfo==5);
erp_blc{9}=ft_selectdata(cfg,erp_blc_all);

% plot settings
frequency_range = ['(' num2str(frequency(1)) '-' num2str(frequency(2)) ')'];
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

% odor vs. air
design=erp_blc_all.trialinfo;
design(design~=6)=1;
design(design==6)=2;
cfg           = [];
cfg.method    = 'analytic'; % using a parametric test
cfg.statistic = 'ft_statfun_indepsamplesT'; % using independent samples
cfg.correctm  = 'no'; % no multiple comparisons correction
cfg.alpha     = 0.05;
cfg.design    = design;
cfg.ivar      = 1; 
stat_t_oa = ft_timelockstatistics(cfg, erp_blc_all);
% pleasant vs. unpleasant
design=erp_blc_all.trialinfo;
design(design<=3)=2;
design(design==4|design==5)=1;
cfg.design    = design;
stat_t_pu = ft_timelockstatistics(cfg, erp_blc_all);

% plot 5 odors and air
figure('position',[20,0,1000,400]);
hold on
for i=1:7
plot(erp_blc{1}.time,1000*erp_blc{i}.trial,'LineStyle',ls{i},'Color',hex2rgb(colors{i}),'LineWidth',lw{i})
end
xlabel('Time (s)')
ylabel('Voltage (μV)')
set(gca,'xlim',time_range);
title([cur_roi '-odor' frequency_range])
legend('Ind','Iso_l','Iso_h','Pea','Ban','Air','Odor')
hold off
saveas(gcf, [pic_dir cur_roi '-odor' frequency_range '.fig'],'fig')
saveas(gcf, [pic_dir cur_roi '-odor' frequency_range '.png'],'png')
close all

% cfg=[];
% cfg.parameter='trial';
% cfg.operation='(x1+x2+x3)/3';
% erp_h_blc{8}=ft_math(cfg,erp_h_blc{1},erp_h_blc{2},erp_h_blc{3});
% cfg.operation='(x1+x2)/2';
% erp_h_blc{9}=ft_math(cfg,erp_h_blc{4},erp_h_blc{5});

% plot odor and air and valence
figure('position',[20,0,1000,400]);
hold on
for i=6:9
plot(erp_blc{1}.time,1000*erp_blc{i}.trial,'LineStyle',ls{i},'Color',hex2rgb(colors{i}),'LineWidth',lw{i})
end
xlabel('Time (s)')
ylabel('Voltage (μV)')
set(gca,'xlim',time_range);
% ft_plot_vector(erp_blc{1}.time,1000*erp_h_blc{i}.trial, 'highlight', stat_t_oa.mask, 'highlightstyle', 'box','facealpha', 0.5);
begsample = find(diff([0 stat_t_oa.mask 0])== 1);
endsample = find(diff([0 stat_t_oa.mask 0])==-1)-1;
for i=1:length(begsample)
  begx = erp_blc{1}.time(begsample(i));
  endx = erp_blc{1}.time(endsample(i));
  ft_plot_box([begx endx get(gca,'Ylim')], 'facecolor', [0.6 0 0], 'facealpha', 0.3, 'edgecolor', 'none');
end
begsample = find(diff([0 stat_t_pu.mask 0])== 1);
endsample = find(diff([0 stat_t_pu.mask 0])==-1)-1;
for i=1:length(begsample)
  begx = erp_blc{1}.time(begsample(i));
  endx = erp_blc{1}.time(endsample(i));
  ft_plot_box([begx endx get(gca,'Ylim')], 'facecolor', [0 0 0.6], 'facealpha', 0.3, 'edgecolor', 'none');
end
title([cur_roi '-valence' frequency_range])
legend('Air','Odor','Unplea','Plea')
hold off
saveas(gcf, [pic_dir cur_roi '-valence' frequency_range '.fig'],'fig')
saveas(gcf, [pic_dir cur_roi '-valence' frequency_range '.png'],'png')
close all
end