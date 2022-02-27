%% set path
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/erp_resp/'];
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
for roi_i=1:roi_num
cur_roi=cur_level_roi{roi_i,1};
lfp=roi_lfp{roi_i};
resp=roi_resp{roi_i};
% select air condition
condition=6;
cfg=[];
cfg.trials = find(resp.trialinfo==condition);
resavg=ft_timelockanalysis(cfg, resp);
%% show low frequency signal
cfg=[];
cfg.bpfilter = 'yes';
cfg.bpfilttype = 'fir';
cfg.bpfreq = [0.1 0.6];
cfg.trials = find(lfp.trialinfo==condition);
lfp_l = ft_preprocessing(cfg,lfp);
% cfg          = [];
% cfg.method   = 'trial';
% dummy        = ft_rejectvisual(cfg,lfp_l);
% cfg = [];
% cfg.viewmode = 'vertical';
% cfg.ylim = 'maxmin';
% lfp_l = rmfield(lfp_l,'sampleinfo');
% eegplot = ft_databrowser(cfg,lfp_l);
%% ERP
% baseline correction
cfg = [];
cfg.keeptrials = 'yes';
erp = ft_timelockanalysis(cfg, lfp_l);
cfg              = [];
cfg.baseline     = [-1 -0.5];
bs=linspace(cfg.baseline(1),cfg.baseline(2),100);
erp_blc = ft_timelockbaseline(cfg, erp);
% average trials
cfg = [];
cfg.trials = find(erp_blc.trialinfo==condition);
cfg.avgoverrpt =  'yes';
erp_blc=ft_selectdata(cfg,erp_blc);
% compute correlation
time_range = [-1 4];
select=resavg.time>=0&resavg.time<=time_range(2);
r4=corr(resavg.avg(select)',squeeze(mean(erp_blc.trial(:,select),1))');
select=resavg.time>=time_range(1)&resavg.time<=time_range(2);
r7=corr(resavg.avg',squeeze(mean(erp_blc.trial,1))');

figure
hold on
plot(erp_blc.time,1000*erp_blc.trial,'b','LineWidth',1.5)
xlabel('Time (s)')
ylabel('Voltage (μV)')
yyaxis right
plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
set(gca,'xlim',time_range,'ytick',[]);
title([cur_roi ' 0-4s:' num2str(r4) ' -1-4s:' num2str(r7)])
hold off
saveas(gcf, [pic_dir cur_roi],'png')
close all
% figure
% scatter(resavg.avg(select)',squeeze(mean(erp_blc.trial(:,select),1)'))
% figure
% scatter(resavg.avg',squeeze(mean(erp_blc.trial,1))')
end