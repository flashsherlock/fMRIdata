%% load data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
cur_date='200807';
data=load([data_dir cur_date '_rm035_ane.mat']);
%% cut to trials
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
% select channel
channel=48;
cfg.channel=strcat('WB',num2str(channel));
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
for i=2
freq_range = [1.5 200];
time_range = [-1 7.5];
% inhale
cfgtf=[];
cfgtf.trials = find(lfp.trialinfo==1);
cfgtf.trials = cfgtf.trials(i:2:end);
cfgtf.method     = 'mtmconvol';
cfgtf.toi        = -3.5:0.1:9.5;
% cfgtf.foi        = 1:1:100;
% other wavelet parameters
cfgtf.foi = logspace(log10(1),log10(200),51);
% cfgtf.t_ftimwin  = ones(length(cfgtf.foi),1).*0.5;
cfgtf.t_ftimwin  = 5./cfgtf.foi;
cfgtf.taper      = 'hanning';
cfgtf.output     = 'pow';
cfgtf.keeptrials = 'yes';
freq_sep = ft_freqanalysis(cfgtf, lfp);
% average across channels
cfg = [];
cfg.keeptrials    = 'yes';
cfg.frequency=freq_range;
cfg.latency=time_range;
freq_sep = ft_freqdescriptives(cfg,freq_sep);
% average across trials
cfg.keeptrials    = 'no';
freq=ft_freqdescriptives(cfg,freq_sep);
% baseline correction
cfg              = [];
cfg.baseline     = [-1 -0.5];
cfg.baselinetype = 'db';
freq_blc = ft_freqbaseline(cfg, freq);
bs=linspace(cfg.baseline(1),cfg.baseline(2),100);
% check if some of the trials drive the results
%             freq_blc.powspctrm=permute(freq_blc.powspctrm,[3 2 1 4]);
%             freq_blc.freq=freq_blc.freq(1):1:freq_blc.freq(1)+194;
% plot
% cfg = [];
% % cfg.trials = find(freq_blc.trialinfo==1);
% cfg.xlim = [-1.5 8];
% cfg.zlim = [-2 2];
% cfg.colormap = 'jet';
% ft_singleplotTFR(cfg, freq_blc);
% filt resp
% cfg=[];
% cfg.lpfilter = 'yes';
% cfg.lpfilttype = 'fir';
% cfg.lpfreq = 10;
% resp = ft_preprocessing(cfg,resp);

% threshold by permutation test
voxel_pval   = 0.05;
cluster_pval = 0.05;
n_permutes = 1000;
num_frex = length(freq_blc.freq);
nTimepoints = length(freq_blc.time);
baseidx(1) = dsearchn(freq_sep.time',cfg.baseline(1));
baseidx(2) = dsearchn(freq_sep.time',cfg.baseline(2));
% initialize null hypothesis matrices
permuted_maxvals = zeros(n_permutes,2,num_frex);
permuted_vals    = zeros(n_permutes,num_frex,nTimepoints);
max_clust_info   = zeros(n_permutes,1);
% rpt_chan_freq_time
realbaselines = squeeze(mean(freq_sep.powspctrm(:,:,:,baseidx(1):baseidx(2)),4));
for permi=1:n_permutes
    cutpoint = randsample(2:nTimepoints-diff(baseidx)-2,1);
    permuted_vals(permi,:,:) = 10*log10(bsxfun(@rdivide,squeeze(mean(freq_sep.powspctrm(:,:,:,[cutpoint:end 1:cutpoint-1]),1)),mean(realbaselines,1)'));
end
realmean=squeeze(freq_blc.powspctrm);
zmap = (realmean-squeeze(mean(permuted_vals))) ./ squeeze(std(permuted_vals));
threshmean = realmean;
threshmean(abs(zmap)<=norminv(1-voxel_pval/2))=0;

% plot by contourf
figure;
contourf(freq_blc.time,freq_blc.freq,realmean,40,'linecolor','none');
set(gca,'ytick',round(logspace(log10(cfgtf.foi(1)),log10(cfgtf.foi(end)),10)*100)/100,'yscale','log');
set(gca,'ylim',freq_range,'xlim',time_range,'clim',[-2 2]);
% colorbarlabel('Baseline-normalized power (dB)')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colormap jet
ylabel(colorbar,'Baseline-normalized power (dB)')
% plot respiration
cfg.trials = find(resp.trialinfo==1);
cfg.trials = cfg.trials(i:2:end);
resavg=ft_timelockanalysis(cfg, resp);
hold on
plot(bs,1.5*ones(1,100),'k','LineWidth',5)
yyaxis right
plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
set(gca,'xlim',time_range,'ytick',[]);
title([cur_date '-' num2str(channel) '-trial' num2str(i)])
hold off
% exhale
% cfgtf.trials = find(lfp.trialinfo==2);
% freq2 = ft_freqanalysis(cfgtf, lfp);
% cfg              = [];
% cfg.baseline     = [-1.5 -0.5];
% cfg.baselinetype = 'db';
% freq_blc2 = ft_freqbaseline(cfg, freq2);
% cfg = [];
% % cfg.trials = find(freq_blc.trialinfo==2);
% cfg.xlim = [-1.5 8];
% cfg.zlim = [-2 2];
% cfg.colormap = 'jet';
% ft_singleplotTFR(cfg, freq_blc2);
end
%% statistics
% cfg=cfgtf;
% cfg.keeptrials = 'yes';
% freq_sep = ft_freqanalysis(cfg, lfp);
% cfg              = [];
% cfg.baseline     = [-1 -0.5];
% cfg.baselinetype = 'relchange';
% freq_sep_blc = ft_freqbaseline(cfg, freq_sep);
% 
% cfg = [];
% cfg.latency          = [0 7.5];
% cfg.frequency        = [1.5 200];
% cfg.method           = 'stats';
% cfg.statistic        = 'ttest';
% % cfg.correctm         = 'fdr';
% cfg.alpha            = 0.05;
% cfg.design    = ones(1, length(freq_sep.trialinfo));
% 
% [stat] = ft_freqstatistics(cfg, freq_sep);
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