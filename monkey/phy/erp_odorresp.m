%% set path
monkeys = {'RM035','RM033'};
% monkeys = {'RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/erp_odorresp/' m '_HA/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
%% generate data
level = 6;
trl_type = 'odorresp';
% combine 2 monkeys
[roi_lfp,roi_resp,cur_level_roi] = save_merge_2monkey(level,trl_type,monkeys);
% get number of roi
roi_num=size(cur_level_roi,1);
odor_num=7;
%% plot setting
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#000000', '#E12A3C', '#777DDD', '#41AB5D','#B2B2B2'};
colors_cp = colors([1:5 7 10]);
%linewidth
lw=cell(1,9);
%linestyle
ls=lw;
for i=1:9
    if i<=5
        lw{i}=1.5;
        if i<=3
            ls{i}='-';
        else
            ls{i}='-';
        end

    else
        lw{i}=1.5;
        ls{i}='-';
    end
end
ls{8}='-';
ls{9}='-';
%% analyze
% frequencies={[0.7 80],[0.7 2],[2 4],[4 8],[8 13],[13 30],[30 80]};
frequencies={[0.7 50]};
for fre_i=1:length(frequencies)
frequency=frequencies{fre_i};
frequency_range = ['(' num2str(frequency(1)) '-' num2str(frequency(2)) 'Hz)'];
select_time_range = [-3.5 9.5];
time_ranges = {[-0.2 2],[-0.2 1]};
baseline = [-0.2 0];
for roi_i=1:roi_num
cur_roi=cur_level_roi{roi_i,1};
lfp=roi_lfp{roi_i};

% select time
cfg         = [];
cfg.latency = select_time_range;
lfp_filt=ft_selectdata(cfg, lfp);

% filter
% cfg = [];
% cfg.bpfilter = 'yes';
% cfg.bpfilttype = 'fir';
% cfg.bpfreq = frequency;
% lfp_filt = ft_preprocessing(cfg,lfp_filt);
cfg = [];
cfg.lpfilter = 'yes';
cfg.lpfilttype = 'fir';
cfg.lpfreq = frequency(2);
lfp_filt = ft_preprocessing(cfg,lfp_filt);

% baseline correction
cfg = [];
cfg.keeptrials = 'yes';
erp = ft_timelockanalysis(cfg, lfp_filt);
cfg              = [];
cfg.baseline     = baseline;
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

%% statistics
% 5odor+air vs. odor plea vs. unplea
stat_t=cell(1,7);
for odor_i=1:7
    design=erp_blc_all.trialinfo;
    if odor_i==6
        design(design~=6)=1;
        design(design==6)=2;
    elseif odor_i==7
        design(design<=3)=1;
        design(design==4|design==5)=2;
    else
        design(design==odor_i)=1;
        design(design==6)=2;
    end    
    cfg           = [];
    cfg.method    = 'analytic'; % using a parametric test
    cfg.statistic = 'ft_statfun_indepsamplesT'; % using independent samples
    cfg.correctm  = 'no'; % no multiple comparisons correction
    cfg.alpha     = 0.05;
    cfg.design    = design;
    cfg.ivar      = 1; 
    stat_t{odor_i} = ft_timelockstatistics(cfg, erp_blc_all);
end
%% plot
smooth_win=1;
for time_i=1:length(time_ranges)
time_range = time_ranges{time_i};
t_range = ['(' num2str(time_range(1)) '-' num2str(time_range(2)) 's)'];
% plot 5 odors and air
figure('position',[20,0,600,400]);
subplot(2,1,1)
hold on
for i=1:7
plot(erp_blc{1}.time,smooth(1000*erp_blc{i}.trial,smooth_win),'LineStyle',ls{i},'Color',hex2rgb(colors{i}),'LineWidth',lw{i})
end
xlabel('Time (s)')
ylabel('Voltage (μV)')
set(gca,'xlim',time_range);
title([cur_roi '-odor' frequency_range ' ' t_range])
legend('Indole', 'Iso_l', 'Iso_h', 'Peach', 'Banana', 'Air', 'Odor', 'Location', 'northeastoutside')

subplot(2,1,2)
hold on
for odor_i=1:7
    % replace 0 with eps
    stat_t{odor_i}.prob=max(stat_t{odor_i}.prob,eps);
    plot(stat_t{odor_i}.time, smooth(stat_t{odor_i}.prob,smooth_win),'Color',hex2rgb(colors_cp{odor_i}),'linewidth', lw{i})
end
time_num=length(stat_t{odor_i}.time);
% number of comparision
cmp_num=sum(stat_t{odor_i}.time >time_range(1) & stat_t{odor_i}.time <time_range(2));
plot(stat_t{odor_i}.time,0.05*ones(1,time_num),'k','linestyle','--','LineWidth',2)
plot(stat_t{odor_i}.time,0.05/cmp_num*ones(1,time_num),'r','linestyle','--','LineWidth',2)
set(gca,'yscale','log');
set(gca,'ylim',[0 1]);
set(gca,'xlim',time_range);
xlabel('Time (s)')
ylabel('p')
legend('Ind','Iso_l','Iso_h','Pea','Ban','Odor','Va','Location','northeastoutside')

saveas(gcf, [pic_dir cur_roi '-5odor' frequency_range ' ' t_range '.fig'],'fig')
saveas(gcf, [pic_dir cur_roi '-5odor' frequency_range ' ' t_range '.png'],'png')
close all
end
% cfg=[];
% cfg.parameter='trial';
% cfg.operation='(x1+x2+x3)/3';
% erp_h_blc{8}=ft_math(cfg,erp_h_blc{1},erp_h_blc{2},erp_h_blc{3});
% cfg.operation='(x1+x2)/2';
% erp_h_blc{9}=ft_math(cfg,erp_h_blc{4},erp_h_blc{5});
end
end