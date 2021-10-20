%% load data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
pic_dir=[data_dir 'pic/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
dates = {'200731', '200807', '200814', '200820', '200828'};
for i_date=1:length(dates)
cur_date=dates{i_date};
load([data_dir cur_date '_resp_tf.mat'])
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

% cfg.channel=strcat('WB',num2str(channel));
% lfp=ft_selectdata(cfg,lfp);
%% time frequency analysis odd and even trials
% select channel
for channel=[34 39 45 48 60 63]
for i=1:2
freq_range = [1.5 200];
time_range = [-1 7.5];
% select channel and trial
cfg=[];
cfg.trials=find(freq_sep_resp.trialinfo==1);
cfg.trials = cfg.trials(i:2:end);
if channel~=0
cfg.channel=strcat('WB',num2str(channel));
end
% average across channels
cfg.avgoverchan =  'yes';
cfg.frequency=freq_range;
cfg.latency=time_range;
freq_sep = ft_selectdata(cfg,freq_sep_resp);
% average across trials
cfg=[];
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
un_zmapthresh=abs(sign(threshmean));

% this time, the cluster correction will be done on the permuted data, thus
% making no assumptions about parameters for p-values
for permi = 1:n_permutes
    
    % for cluster correction, apply uncorrected threshold and get maximum cluster sizes
    fakecorrsz = squeeze((permuted_vals(permi,:,:)-mean(permuted_vals)) ./ std(permuted_vals) );
    fakecorrsz(abs(fakecorrsz)<norminv(1-voxel_pval/2))=0;
    
    % get number of elements in largest supra-threshold cluster
    clustinfo = bwconncomp(fakecorrsz);
    max_clust_info(permi) = max([ 0 cellfun(@numel,clustinfo.PixelIdxList) ]); % the zero accounts for empty maps
    % using cellfun here eliminates the need for a slower loop over cells
end

% apply cluster-level corrected threshold
zmapthresh = zmap;
% uncorrected pixel-level threshold
zmapthresh(abs(zmapthresh)<norminv(1-voxel_pval/2))=0;
% find islands and remove those smaller than cluster size threshold
clustinfo = bwconncomp(zmapthresh);
clust_info = cellfun(@numel,clustinfo.PixelIdxList);
clust_threshold = prctile(max_clust_info,100-cluster_pval*100);

% identify clusters to remove
whichclusters2remove = find(clust_info<clust_threshold);

% remove clusters
for i_r=1:length(whichclusters2remove)
    zmapthresh(clustinfo.PixelIdxList{whichclusters2remove(i_r)})=0;
end

% plot by contourf
figure;
contourf(freq_blc.time,freq_blc.freq,realmean,40,'linecolor','none');
set(gca,'ytick',round(logspace(log10(freq_range(1)),log10(freq_range(end)),10)*100)/100,'yscale','log');
set(gca,'ylim',freq_range,'xlim',time_range,'clim',[-2 2]);
% colorbarlabel('Baseline-normalized power (dB)')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colormap jet
ylabel(colorbar,'Baseline-normalized power (dB)')
% plot respiration
cfg=[];
cfg.trials = find(resp.trialinfo==1);
cfg.trials = cfg.trials(i:2:end);
resavg=ft_timelockanalysis(cfg, resp);
hold on
% uncorrected
% contour(freq_blc.time,freq_blc.freq,un_zmapthresh,1,'linecolor','k','LineWidth',1)
% cluster based correction
contour(freq_blc.time,freq_blc.freq,abs(sign(zmapthresh)),1,'linecolor','k','LineWidth',1)
set(gca, 'yminortick', 'off');
plot(bs,1.5*ones(1,100),'k','LineWidth',5)
yyaxis right
plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
set(gca,'xlim',time_range,'ytick',[]);
title([cur_date '-' num2str(channel) '-trial' num2str(i)])
hold off
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-trial' num2str(i)], 'fig')
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-trial' num2str(i)], 'png')
close all
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

%% all trials
freq_range = [1.5 200];
time_range = [-1 4];
% select channel and trial
cfg=[];
cfg.trials=find(freq_sep_resp.trialinfo==1);
if channel~=0
cfg.channel=strcat('WB',num2str(channel));
end
% average across channels
cfg.avgoverchan =  'yes';
cfg.frequency=freq_range;
cfg.latency=time_range;
freq_sep = ft_selectdata(cfg,freq_sep_resp);
% average across trials
cfg=[];
cfg.keeptrials    = 'no';
freq=ft_freqdescriptives(cfg,freq_sep);
% baseline correction
cfg              = [];
cfg.baseline     = [-1 -0.5];
cfg.baselinetype = 'db';
freq_blc = ft_freqbaseline(cfg, freq);
bs=linspace(cfg.baseline(1),cfg.baseline(2),100);

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
un_zmapthresh=abs(sign(threshmean));

% this time, the cluster correction will be done on the permuted data, thus
% making no assumptions about parameters for p-values
for permi = 1:n_permutes
    
    % for cluster correction, apply uncorrected threshold and get maximum cluster sizes
    fakecorrsz = squeeze((permuted_vals(permi,:,:)-mean(permuted_vals)) ./ std(permuted_vals) );
    fakecorrsz(abs(fakecorrsz)<norminv(1-voxel_pval/2))=0;
    
    % get number of elements in largest supra-threshold cluster
    clustinfo = bwconncomp(fakecorrsz);
    max_clust_info(permi) = max([ 0 cellfun(@numel,clustinfo.PixelIdxList) ]); % the zero accounts for empty maps
    % using cellfun here eliminates the need for a slower loop over cells
end

% apply cluster-level corrected threshold
zmapthresh = zmap;
% uncorrected pixel-level threshold
zmapthresh(abs(zmapthresh)<norminv(1-voxel_pval/2))=0;
% find islands and remove those smaller than cluster size threshold
clustinfo = bwconncomp(zmapthresh);
clust_info = cellfun(@numel,clustinfo.PixelIdxList);
clust_threshold = prctile(max_clust_info,100-cluster_pval*100);

% identify clusters to remove
whichclusters2remove = find(clust_info<clust_threshold);

% remove clusters
for i_r=1:length(whichclusters2remove)
    zmapthresh(clustinfo.PixelIdxList{whichclusters2remove(i_r)})=0;
end

% plot by contourf
figure;
contourf(freq_blc.time,freq_blc.freq,realmean,40,'linecolor','none');
set(gca,'ytick',round(logspace(log10(freq_range(1)),log10(freq_range(end)),10)*100)/100,'yscale','log');
set(gca,'ylim',freq_range,'xlim',time_range,'clim',[-2 2]);
% colorbarlabel('Baseline-normalized power (dB)')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colormap jet
ylabel(colorbar,'Baseline-normalized power (dB)')
% plot respiration
cfg=[];
cfg.trials = find(resp.trialinfo==1);
cfg.trials = cfg.trials(i:2:end);
resavg=ft_timelockanalysis(cfg, resp);
hold on
% uncorrected
% contour(freq_blc.time,freq_blc.freq,un_zmapthresh,1,'linecolor','k','LineWidth',1)
% cluster based correction
contour(freq_blc.time,freq_blc.freq,abs(sign(zmapthresh)),1,'linecolor','k','LineWidth',1)
set(gca, 'yminortick', 'off');
plot(bs,1.5*ones(1,100),'k','LineWidth',5)
yyaxis right
plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
set(gca,'xlim',time_range,'ytick',[]);
title([cur_date '-' num2str(channel) 'all trial'])
hold off
saveas(gcf, [pic_dir cur_date '-' num2str(channel)],'fig')
saveas(gcf, [pic_dir cur_date '-' num2str(channel)],'png')
close all
end
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