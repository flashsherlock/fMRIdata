data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
cur_date='200807';
channel=32:64;
bad_channel=[35 37 38 46 50 53 55 56 57];
channel(ismember(channel,bad_channel))=[];
resp_channel='AI08';

channel=num2str(48);
SPK_chan=strcat('SPK',channel);
CON_chan=strcat('WB',channel);

%% cut to trials
for i=1:length(lfp)
cfg=[];
cfg.trl=trl(i).resp;
lfp{i} = ft_redefinetrial(cfg, lfp{i});
resp{i} = ft_redefinetrial(cfg, resp{i});
end
%% append data
cfg=[];
cfg.keepsampleinfo='no';
lfp = ft_appenddata(cfg,lfp{:});
resp = ft_appenddata(cfg,resp{:});
% remove trials containing nan values
% lfpnan=find(cellfun(@(x) any(isnan(x)),lfp.trial)==1);
% respnan=find(cellfun(@(x) any(isnan(x)),resp.trial)==1);
% allnan=unique([lfpnan respnan]);
cfg=[];
cfg.trials=~(cellfun(@(x) any(any(isnan(x),2)),lfp.trial)...
    |cellfun(@(x) any(any(isnan(x),2)),resp.trial));
resp=ft_selectdata(cfg,resp);
cfg.channel={'WB48'};
lfp=ft_selectdata(cfg,lfp);
%% show low frequency signal
cfg=[];
cfg.bpfilter = 'yes';
cfg.bpfilttype = 'fir';
cfg.bpfreq = [0.1 0.8];
lfp_l = ft_preprocessing(cfg,lfp);
cfg = [];
cfg.trials = find(lfp_l.trialinfo==1);
ft_singleplotER(cfg, lfp_l); 
% cfg          = [];
% cfg.method   = 'trial';
% dummy        = ft_rejectvisual(cfg,lfp_l);
% cfg = [];
% cfg.viewmode = 'vertical';
% cfg.ylim = 'maxmin';
% lfp_l = rmfield(lfp_l,'sampleinfo');
% eegplot = ft_databrowser(cfg,lfp_l);
%% time frequency analysis
% inhale
cfgtf=[];
cfgtf.trials = find(lfp.trialinfo==1);
cfgtf.trials = cfgtf.trials(1:2:end);
cfgtf.method     = 'mtmconvol';
cfgtf.toi        = -3.5:0.1:9.5;
% cfgtf.foi        = 1:1:100;
% other wavelet parameters
cfgtf.foi = logspace(log10(1),log10(200),51);
% cfgtf.t_ftimwin  = ones(length(cfgtf.foi),1).*0.5;
cfgtf.t_ftimwin  = 5./cfgtf.foi;
cfgtf.taper      = 'hanning';
cfgtf.output     = 'pow';
cfgtf.keeptrials = 'no';
freq = ft_freqanalysis(cfgtf, lfp);
% baseline correction
cfg              = [];
cfg.baseline     = [-1.5 -0.5];
cfg.baselinetype = 'db';
freq_blc = ft_freqbaseline(cfg, freq);
bs=linspace(cfg.baseline(1),cfg.baseline(2),100);
% check if some of the trials drive the results
%             freq_blc.powspctrm=permute(freq_blc.powspctrm,[3 2 1 4]);
%             freq_blc.freq=freq_blc.freq(1):1:freq_blc.freq(1)+194;
% plot
cfg = [];
% cfg.trials = find(freq_blc.trialinfo==1);
cfg.xlim = [-1.5 8];
cfg.zlim = [-2 2];
cfg.colormap = 'jet';
ft_singleplotTFR(cfg, freq_blc);
%filt resp
% cfg=[];
% cfg.lpfilter = 'yes';
% cfg.lpfilttype = 'fir';
% cfg.lpfreq = 10;
% resp = ft_preprocessing(cfg,resp);
% plot by contourf
figure;
contourf(cfgtf.toi,cfgtf.foi,squeeze(freq_blc.powspctrm),40,'linecolor','none');
set(gca,'ytick',round(logspace(log10(cfgtf.foi(1)),log10(cfgtf.foi(end)),10)*100)/100,'yscale','log');
set(gca,'ylim',[1.5 200],'xlim',[-1.5 7.5],'clim',[-2 2]);
% colorbarlabel('Baseline-normalized power (dB)')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colormap jet
ylabel(colorbar,'Baseline-normalized power (dB)')
% plot respiration
cfg.trials = find(resp.trialinfo==1);
cfg.trials = cfg.trials(1:2:end);
resavg=ft_timelockanalysis(cfg, resp);
hold on
plot(bs,1.5*ones(1,100),'k','LineWidth',4)
yyaxis right
plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
set(gca,'xlim',[-1.5 7.5],'ytick',[]);
% title([cur_date '-' num2str(channel)])
hold off
% exhale
cfgtf.trials = find(lfp.trialinfo==2);
freq2 = ft_freqanalysis(cfgtf, lfp);
cfg              = [];
cfg.baseline     = [-1.5 -0.5];
cfg.baselinetype = 'db';
freq_blc2 = ft_freqbaseline(cfg, freq2);
cfg = [];
% cfg.trials = find(freq_blc.trialinfo==2);
cfg.xlim = [-1.5 8];
cfg.zlim = [-2 2];
cfg.colormap = 'jet';
ft_singleplotTFR(cfg, freq_blc2);
%% ERP
cfg = [];
cfg.keeptrials = 'yes';
erp = ft_timelockanalysis(cfg, lfp_l);
cfg              = [];
cfg.baseline     = [-2 0];
erp_blc = ft_timelockbaseline(cfg, erp);
cfg = [];
cfg.trials = find(erp_blc.trialinfo==1);
ft_singleplotER(cfg, erp_blc);

select=resavg.time>=0&resavg.time<=4;
r=corr(resavg.avg(select)',squeeze(mean(erp_blc.trial(:,:,select),1)));

hold on
yyaxis right
plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
set(gca,'xlim',[-1.5 7.5],'ytick',[]);
title([cur_date '-' num2str(channel) ' ' num2str(r)])
hold off

figure
scatter(resavg.avg(select)',squeeze(mean(erp_blc.trial(:,:,select),1)))
figure
scatter(resavg.avg',squeeze(mean(erp_blc.trial(:,:,select),1)))