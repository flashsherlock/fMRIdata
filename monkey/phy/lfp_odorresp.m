%% load data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
pic_dir=[data_dir 'pic/odorresp/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
dates={'200731','200807','200814','200820','200828'};
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
% select channel and trial
channel=0;
if channel~=0
cfg.channel=strcat('WB',num2str(channel));
end
lfp=ft_selectdata(cfg,lfp);
%% time frequency analysis
freq_range = [1.5 200];
time_range = [-1 7.5];
% inhale
cfgtf=[];
cfgtf.method     = 'mtmconvol';
cfgtf.toi        = -3.5:0.01:9.5;
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
cfg=[];
cfg.avgoverchan =  'yes';
cfg.frequency=freq_range;
cfg.latency=time_range;
freq_sep = ft_selectdata(cfg,freq_sep);
%% odor and air 2 cycles
freq=cell(1,7);
freq_blc=freq;
freq_sepi=freq;
for i=6:7
% average across trials
cfg.keeptrials    = 'no';
if i==7
    cfg.trials = find(freq_sep.trialinfo~=6);
else
    cfg.trials = find(freq_sep.trialinfo==i);
end
% odd trials
cfg.trials = cfg.trials(1:2:end);
freq{i}=ft_freqdescriptives(cfg,freq_sep);
% select data
cfg=[];
if i==7
    cfg.trials = find(freq_sep.trialinfo~=6);
else
    cfg.trials = find(freq_sep.trialinfo==i);
end
freq_sepi{i}=ft_selectdata(cfg,freq_sep);
% baseline correction
cfg              = [];
cfg.baseline     = [-1 -0.5];
cfg.baselinetype = 'db';
freq_blc{i} = ft_freqbaseline(cfg, freq{i});
bs=linspace(cfg.baseline(1),cfg.baseline(2),100);

% threshold by permutation test
voxel_pval   = 0.05;
cluster_pval = 0.05;
n_permutes = 1000;
num_frex = length(freq_blc{i}.freq);
nTimepoints = length(freq_blc{i}.time);
baseidx(1) = dsearchn(freq_sepi{i}.time',cfg.baseline(1));
baseidx(2) = dsearchn(freq_sepi{i}.time',cfg.baseline(2));
% initialize null hypothesis matrices
permuted_maxvals = zeros(n_permutes,2,num_frex);
permuted_vals    = zeros(n_permutes,num_frex,nTimepoints);
max_clust_info   = zeros(n_permutes,1);
% rpt_chan_freq_time
realbaselines = squeeze(mean(freq_sepi{i}.powspctrm(:,:,:,baseidx(1):baseidx(2)),4));
for permi=1:n_permutes
    cutpoint = randsample(2:nTimepoints-diff(baseidx)-2,1);
    permuted_vals(permi,:,:) = 10*log10(bsxfun(@rdivide,squeeze(mean(freq_sepi{i}.powspctrm(:,:,:,[cutpoint:end 1:cutpoint-1]),1)),mean(realbaselines,1)'));
end
realmean=squeeze(freq_blc{i}.powspctrm);
zmap = (realmean-squeeze(mean(permuted_vals))) ./ squeeze(std(permuted_vals));
threshmean = realmean;
threshmean(abs(zmap)<=norminv(1-voxel_pval/2))=0;
un_zmapthresh=abs(sign(threshmean));

%cluster correction
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
contourf(freq_blc{i}.time,freq_blc{i}.freq,realmean,40,'linecolor','none');
set(gca,'ytick',round(logspace(log10(freq_range(1)),log10(freq_range(end)),10)*100)/100,'yscale','log');
set(gca,'ylim',freq_range,'xlim',time_range,'clim',[-2 2]);
% colorbarlabel('Baseline-normalized power (dB)')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colormap jet
ylabel(colorbar,'Baseline-normalized power (dB)')
% plot respiration
cfg=[];
if i==7
    cfg.trials = find(resp.trialinfo~=6);
else
    cfg.trials = find(resp.trialinfo==i);
end
resavg=ft_timelockanalysis(cfg, resp);
hold on
% uncorrected
% contour(freq_blc{i}.time,freq_blc{i}.freq,un_zmapthresh,1,'linecolor','k','LineWidth',1)
% cluster based correction
contour(freq_blc{i}.time,freq_blc{i}.freq,abs(sign(zmapthresh)),1,'linecolor','k','LineWidth',1)
set(gca, 'yminortick', 'off');
plot(bs,1.5*ones(1,100),'k','LineWidth',5)
yyaxis right
plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
set(gca,'xlim',time_range,'ytick',[]);
title([cur_date '-' num2str(channel) '-odorresp' num2str(i) '-oddtrial'])
hold off
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp' num2str(i) '-oddtrial'], 'fig')
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp' num2str(i) '-oddtrial'], 'png')
close all
end
%% select -1-4s
freq_range = [1.5 200];
time_range = [-1 4];
cfg=[];
cfg.frequency=freq_range;
cfg.latency=time_range;
freq_sep = ft_selectdata(cfg,freq_sep);
%% each odor condition compared with baseline
freq=cell(1,7);
freq_blc=freq;
freq_sepi=freq;
for i=1:7
% average across trials
cfg.keeptrials    = 'no';
if i==7
    cfg.trials = find(freq_sep.trialinfo~=6);
else
    cfg.trials = find(freq_sep.trialinfo==i);
end
freq{i}=ft_freqdescriptives(cfg,freq_sep);
% select data
cfg=[];
if i==7
    cfg.trials = find(freq_sep.trialinfo~=6);
else
    cfg.trials = find(freq_sep.trialinfo==i);
end
freq_sepi{i}=ft_selectdata(cfg,freq_sep);
% baseline correction
cfg              = [];
cfg.baseline     = [-1 -0.5];
cfg.baselinetype = 'db';
freq_blc{i} = ft_freqbaseline(cfg, freq{i});
bs=linspace(cfg.baseline(1),cfg.baseline(2),100);

% threshold by permutation test
voxel_pval   = 0.05;
cluster_pval = 0.05;
n_permutes = 1000;
num_frex = length(freq_blc{i}.freq);
nTimepoints = length(freq_blc{i}.time);
baseidx(1) = dsearchn(freq_sepi{i}.time',cfg.baseline(1));
baseidx(2) = dsearchn(freq_sepi{i}.time',cfg.baseline(2));
% initialize null hypothesis matrices
permuted_maxvals = zeros(n_permutes,2,num_frex);
permuted_vals    = zeros(n_permutes,num_frex,nTimepoints);
max_clust_info   = zeros(n_permutes,1);
% rpt_chan_freq_time
realbaselines = squeeze(mean(freq_sepi{i}.powspctrm(:,:,:,baseidx(1):baseidx(2)),4));
for permi=1:n_permutes
    cutpoint = randsample(2:nTimepoints-diff(baseidx)-2,1);
    permuted_vals(permi,:,:) = 10*log10(bsxfun(@rdivide,squeeze(mean(freq_sepi{i}.powspctrm(:,:,:,[cutpoint:end 1:cutpoint-1]),1)),mean(realbaselines,1)'));
end
realmean=squeeze(freq_blc{i}.powspctrm);
zmap = (realmean-squeeze(mean(permuted_vals))) ./ squeeze(std(permuted_vals));
threshmean = realmean;
threshmean(abs(zmap)<=norminv(1-voxel_pval/2))=0;
un_zmapthresh=abs(sign(threshmean));

%cluster correction
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
contourf(freq_blc{i}.time,freq_blc{i}.freq,realmean,40,'linecolor','none');
set(gca,'ytick',round(logspace(log10(freq_range(1)),log10(freq_range(end)),10)*100)/100,'yscale','log');
set(gca,'ylim',freq_range,'xlim',time_range,'clim',[-2 2]);
% colorbarlabel('Baseline-normalized power (dB)')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colormap jet
ylabel(colorbar,'Baseline-normalized power (dB)')
% plot respiration
cfg=[];
if i==7
    cfg.trials = find(resp.trialinfo~=6);
else
    cfg.trials = find(resp.trialinfo==i);
end
resavg=ft_timelockanalysis(cfg, resp);
hold on
% uncorrected
% contour(freq_blc{i}.time,freq_blc{i}.freq,un_zmapthresh,1,'linecolor','k','LineWidth',1)
% cluster based correction
contour(freq_blc{i}.time,freq_blc{i}.freq,abs(sign(zmapthresh)),1,'linecolor','k','LineWidth',1)
set(gca, 'yminortick', 'off');
plot(bs,1.5*ones(1,100),'k','LineWidth',5)
yyaxis right
plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
set(gca,'xlim',time_range,'ytick',[]);
title([cur_date '-' num2str(channel) '-odorresp' num2str(i)])
hold off
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp' num2str(i)], 'fig')
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp' num2str(i)], 'png')
close all
end

%% compared with air
voxel_pval = 0.05; 
cluster_pval = 0.05;
n_permutes = 1000;

for i=[1:5 7]
cfg=[];
if i==7 %6 means odor vs. air
    cfg.trials = find(freq_sep.trialinfo~=6 | freq_sep.trialinfo==6);
else
    cfg.trials = find(freq_sep.trialinfo==i | freq_sep.trialinfo==6);
end
freq_cp=ft_selectdata(cfg,freq_sep);
% baseline correction
cfg              = [];
cfg.baseline     = [-1 -0.5];
cfg.baselinetype = 'absolute';
freq_cp = ft_freqbaseline(cfg, freq_cp);

eegpower=permute(squeeze(freq_cp.powspctrm),[2 3 1]);
real_condition_mapping=freq_cp.trialinfo;
if i==7
    real_condition_mapping(real_condition_mapping~=6)=7;
end
% compute actual t-test of difference (using unequal N and std)
tnum   = squeeze(mean(eegpower(:,:,real_condition_mapping==i),3) - mean(eegpower(:,:,real_condition_mapping==6),3));
tdenom = sqrt( (std(eegpower(:,:,real_condition_mapping==i),0,3).^2)./sum(real_condition_mapping==i) + (std(eegpower(:,:,real_condition_mapping==6),0,3).^2)./sum(real_condition_mapping==6) );
real_t = tnum./tdenom;

% initialize null hypothesis matrices
num_frex = length(freq_cp.freq);
nTimepoints = length(freq_cp.time);
permuted_tvals  = zeros(n_permutes,num_frex,nTimepoints);
max_pixel_pvals = zeros(n_permutes,2);
max_clust_info  = zeros(n_permutes,1);

% generate pixel-specific null hypothesis parameter distributions
for permi = 1:n_permutes
    fake_condition_mapping = real_condition_mapping(randperm(length(real_condition_mapping)));
    
    % compute t-map of null hypothesis
    tnum   = squeeze(mean(eegpower(:,:,fake_condition_mapping==i),3)-mean(eegpower(:,:,fake_condition_mapping==6),3));
    tdenom = sqrt( (std(eegpower(:,:,fake_condition_mapping==i),0,3).^2)./sum(fake_condition_mapping==i) + (std(eegpower(:,:,fake_condition_mapping==6),0,3).^2)./sum(fake_condition_mapping==6) );
    tmap   = tnum./tdenom;
    
    % save all permuted values
    permuted_tvals(permi,:,:) = tmap;
    
    % save maximum pixel values
    max_pixel_pvals(permi,:) = [ min(tmap(:)) max(tmap(:)) ];
    
    % for cluster correction, apply uncorrected threshold and get maximum cluster sizes
    % note that here, clusters were obtained by parametrically thresholding
    % the t-maps
    tmap(abs(tmap)<tinv(1-voxel_pval/2,length(real_condition_mapping)-2))=0;
    
    % get number of elements in largest supra-threshold cluster
    clustinfo = bwconncomp(tmap);
    max_clust_info(permi) = max([ 0 cellfun(@numel,clustinfo.PixelIdxList) ]); % notes: cellfun is superfast, and the zero accounts for empty maps
end

% now compute Z-map
zmap = (real_t-squeeze(mean(permuted_tvals,1)))./squeeze(std(permuted_tvals));
diff=squeeze(freq_blc{i}.powspctrm-freq_blc{6}.powspctrm);

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
contourf(freq_blc{i}.time,freq_blc{i}.freq,diff,40,'linecolor','none');
set(gca,'ytick',round(logspace(log10(freq_range(1)),log10(freq_range(end)),10)*100)/100,'yscale','log');
set(gca,'ylim',freq_range,'xlim',time_range,'clim',[-2 2]);
% colorbarlabel('Baseline-normalized power (dB)')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colormap jet
ylabel(colorbar,'Baseline-normalized power (dB)')
% plot respiration
cfg=[];
if i==7
    cfg.trials = find(resp.trialinfo~=6);
else
    cfg.trials = find(resp.trialinfo==i);
end
resavg=ft_timelockanalysis(cfg, resp);
hold on
% uncorrected
% contour(freq_blc{i}.time,freq_blc{i}.freq,un_zmapthresh,1,'linecolor','k','LineWidth',1)
% cluster based correction
contour(freq_blc{i}.time,freq_blc{i}.freq,abs(sign(zmapthresh)),1,'linecolor','k','LineWidth',1)
set(gca, 'yminortick', 'off');
plot(bs,1.5*ones(1,100),'k','LineWidth',5)
yyaxis right
plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
set(gca,'xlim',time_range,'ytick',[]);
title([cur_date '-' num2str(channel) '-odorresp' num2str(i) '-vs-air'])
hold off
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp' num2str(i) '_vs_air'], 'fig')
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp' num2str(i) '_vs_air'], 'png')
close all

figure;
contourf(freq_blc{i}.time,freq_blc{i}.freq,real_t,40,'linecolor','none');
set(gca,'ytick',round(logspace(log10(freq_range(1)),log10(freq_range(end)),10)*100)/100,'yscale','log');
set(gca,'ylim',freq_range,'xlim',time_range,'clim',[-3 3]);
% colorbarlabel('Baseline-normalized power (dB)')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colormap jet
ylabel(colorbar,'t-value')
hold on
% cluster based correction
contour(freq_blc{i}.time,freq_blc{i}.freq,abs(sign(zmapthresh)),1,'linecolor','k','LineWidth',1)
set(gca, 'yminortick', 'off');
plot(bs,1.5*ones(1,100),'k','LineWidth',5)
yyaxis right
plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
set(gca,'xlim',time_range,'ytick',[]);
title([cur_date '-' num2str(channel) '-odorresp' num2str(i) '-vs-air-t'])
hold off
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp' num2str(i) '_vs_air_t'], 'fig')
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp' num2str(i) '_vs_air_t'], 'png')
close all

% apply uncorrected threshold
zmapthresh = zmap;
zmapthresh(abs(zmapthresh)<norminv(1-voxel_pval/2))=false;
zmapthresh=logical(zmapthresh);
figure;
contourf(freq_blc{i}.time,freq_blc{i}.freq,real_t,40,'linecolor','none');
set(gca,'ytick',round(logspace(log10(freq_range(1)),log10(freq_range(end)),10)*100)/100,'yscale','log');
set(gca,'ylim',freq_range,'xlim',time_range,'clim',[-3 3]);
% colorbarlabel('Baseline-normalized power (dB)')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colormap jet
ylabel(colorbar,'t-value')
hold on
% cluster based correction
contour(freq_blc{i}.time,freq_blc{i}.freq,zmapthresh,1,'linecolor','k','LineWidth',1)
set(gca, 'yminortick', 'off');
plot(bs,1.5*ones(1,100),'k','LineWidth',5)
yyaxis right
plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
set(gca,'xlim',time_range,'ytick',[]);
title([cur_date '-' num2str(channel) '-odorresp' num2str(i) '-vs-air-tun'])
hold off
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp' num2str(i) '_vs_air_tun'], 'fig')
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp' num2str(i) '_vs_air_tun'], 'png')
close all

% 
% % apply pixel-level corrected threshold
% lower_threshold = prctile(max_pixel_pvals(:,1),    voxel_pval*100/2);
% upper_threshold = prctile(max_pixel_pvals(:,2),100-voxel_pval*100/2);
% zmapthresh = zmap;
% zmapthresh(zmapthresh>lower_threshold & zmapthresh<upper_threshold)=0;
end

%% compare valence
voxel_pval = 0.05; 
cluster_pval = 0.05;
n_permutes = 1000;

cfg=[];
cfg.trials = find(freq_sep.trialinfo~=6);
freq_cp=ft_selectdata(cfg,freq_sep);
% baseline correction
cfg              = [];
cfg.baseline     = [-1 -0.5];
cfg.baselinetype = 'absolute';
freq_cp = ft_freqbaseline(cfg, freq_cp);

eegpower=permute(squeeze(freq_cp.powspctrm),[2 3 1]);
real_condition_mapping=freq_cp.trialinfo;
real_condition_mapping(real_condition_mapping<=3)=2;
real_condition_mapping(real_condition_mapping==4 | real_condition_mapping==5)=1;
% compute actual t-test of difference (using unequal N and std)
tnum   = squeeze(mean(eegpower(:,:,real_condition_mapping==1),3) - mean(eegpower(:,:,real_condition_mapping==2),3));
tdenom = sqrt( (std(eegpower(:,:,real_condition_mapping==1),0,3).^2)./sum(real_condition_mapping==1) + (std(eegpower(:,:,real_condition_mapping==2),0,3).^2)./sum(real_condition_mapping==2) );
real_t = tnum./tdenom;

% initialize null hypothesis matrices
num_frex = length(freq_cp.freq);
nTimepoints = length(freq_cp.time);
permuted_tvals  = zeros(n_permutes,num_frex,nTimepoints);
max_pixel_pvals = zeros(n_permutes,2);
max_clust_info  = zeros(n_permutes,1);

% generate pixel-specific null hypothesis parameter distributions
for permi = 1:n_permutes
    fake_condition_mapping = real_condition_mapping(randperm(length(real_condition_mapping)));
    
    % compute t-map of null hypothesis
    tnum   = squeeze(mean(eegpower(:,:,fake_condition_mapping==1),3)-mean(eegpower(:,:,fake_condition_mapping==2),3));
    tdenom = sqrt( (std(eegpower(:,:,fake_condition_mapping==1),0,3).^2)./sum(fake_condition_mapping==1) + (std(eegpower(:,:,fake_condition_mapping==2),0,3).^2)./sum(fake_condition_mapping==2) );
    tmap   = tnum./tdenom;
    
    % save all permuted values
    permuted_tvals(permi,:,:) = tmap;
    
    % save maximum pixel values
    max_pixel_pvals(permi,:) = [ min(tmap(:)) max(tmap(:)) ];
    
    % for cluster correction, apply uncorrected threshold and get maximum cluster sizes
    % note that here, clusters were obtained by parametrically thresholding
    % the t-maps
    tmap(abs(tmap)<tinv(1-voxel_pval/2,length(real_condition_mapping)-2))=0;
    
    % get number of elements in largest supra-threshold cluster
    clustinfo = bwconncomp(tmap);
    max_clust_info(permi) = max([ 0 cellfun(@numel,clustinfo.PixelIdxList) ]); % notes: cellfun is superfast, and the zero accounts for empty maps
end

% now compute Z-map
zmap = (real_t-squeeze(mean(permuted_tvals,1)))./squeeze(std(permuted_tvals));

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

figure;
contourf(freq_cp.time,freq_cp.freq,real_t,40,'linecolor','none');
set(gca,'ytick',round(logspace(log10(freq_range(1)),log10(freq_range(end)),10)*100)/100,'yscale','log');
set(gca,'ylim',freq_range,'xlim',time_range,'clim',[-3 3]);
% colorbarlabel('Baseline-normalized power (dB)')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colormap jet
ylabel(colorbar,'t-value')
hold on
% cluster based correction
contour(freq_cp.time,freq_cp.freq,abs(sign(zmapthresh)),1,'linecolor','k','LineWidth',1)
set(gca, 'yminortick', 'off');
plot(bs,1.5*ones(1,100),'k','LineWidth',5)
yyaxis right
plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
set(gca,'xlim',time_range,'ytick',[]);
title([cur_date '-' num2str(channel) '-odorresp-valence-t'])
hold off
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp-valence-t'], 'fig')
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp-valence-t'], 'png')
close all

% apply uncorrected threshold
zmapthresh = zmap;
zmapthresh(abs(zmapthresh)<norminv(1-voxel_pval/2))=false;
zmapthresh=logical(zmapthresh);
figure;
contourf(freq_cp.time,freq_cp.freq,real_t,40,'linecolor','none');
set(gca,'ytick',round(logspace(log10(freq_range(1)),log10(freq_range(end)),10)*100)/100,'yscale','log');
set(gca,'ylim',freq_range,'xlim',time_range,'clim',[-3 3]);
% colorbarlabel('Baseline-normalized power (dB)')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colormap jet
ylabel(colorbar,'t-value')
hold on
% cluster based correction
contour(freq_cp.time,freq_cp.freq,zmapthresh,1,'linecolor','k','LineWidth',1)
set(gca, 'yminortick', 'off');
plot(bs,1.5*ones(1,100),'k','LineWidth',5)
yyaxis right
plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
set(gca,'xlim',time_range,'ytick',[]);
title([cur_date '-' num2str(channel) '-odorresp-valence-tun'])
hold off
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp-valence-tun'], 'fig')
saveas(gcf, [pic_dir cur_date '-' num2str(channel) '-odorresp-valence-tun'], 'png')
close all

% % 
% % % apply pixel-level corrected threshold
% % lower_threshold = prctile(max_pixel_pvals(:,1),    voxel_pval*100/2);
% % upper_threshold = prctile(max_pixel_pvals(:,2),100-voxel_pval*100/2);
% % zmapthresh = zmap;
% % zmapthresh(zmapthresh>lower_threshold & zmapthresh<upper_threshold)=0;
end