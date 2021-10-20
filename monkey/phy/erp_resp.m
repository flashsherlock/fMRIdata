%% load data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
pic_dir=[data_dir 'pic/erp_resp/'];
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
cfg.trl=data.trl(i).resp;
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
% average resperation
cfg=[];
cfg.trials = find(resp.trialinfo==1);
resavg=ft_timelockanalysis(cfg, resp);
%% show low frequency signal
cfg=[];
cfg.bpfilter = 'yes';
cfg.bpfilttype = 'fir';
cfg.bpfreq = [0.1 0.6];
cfg.trials = find(lfp.trialinfo==1);
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
cfg.trials = find(erp_blc.trialinfo==1);
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
title([cur_date '-' num2str(channel) ' 0-4s:' num2str(r4) ' -1-4s:' num2str(r7)])
hold off
saveas(gcf, [pic_dir cur_date '-' num2str(channel)],'png')
close all
% figure
% scatter(resavg.avg(select)',squeeze(mean(erp_blc.trial(:,select),1)'))
% figure
% scatter(resavg.avg',squeeze(mean(erp_blc.trial,1))')
end