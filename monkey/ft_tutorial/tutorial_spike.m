%% load spike data
data=['/Volumes/Promise Disk/gf/spike/' 'p029_sort_final_01.nex'];
spike = ft_read_spike(data);

cfg              = [];
cfg.spikechannel = {'sig002a_wf', 'sig003a_wf'}; % select only the two single units
spike = ft_spike_select(cfg, spike);
% The first dimension of spike.waveform{i} is ‘leads’. 
% For tetrode recordings, multiple leads per electrode are available, 
% in which case the first dimension of spike.waveform{i} would have been of size 4. 
%% Computing average waveforms
cfg             = [];
cfg.fsample     = 40000;
cfg.interpolate = 1; % keep the density of samples as is
[wave, spikeCleaned] = ft_spike_waveform(cfg,spike);

for k = [1 2]
  figure
  sl = squeeze(wave.dof(k,:,:))>1000; % only keep samples with enough spikes
  plot(wave.time(sl), squeeze(wave.avg(k,:,sl)),'k') % factor 10^6 to get microseconds
  hold on

  % plot the standard deviation
  plot(wave.time(sl), squeeze(wave.avg(k,:,sl))+sqrt(squeeze(wave.var(k,:,sl))),'k--')
  plot(wave.time(sl), squeeze(wave.avg(k,:,sl))-sqrt(squeeze(wave.var(k,:,sl))),'k--')

  axis tight
  set(gca,'Box', 'off')
  xlabel('time')
  ylabel('normalized voltage')
end
%% Adding trigger event information to spike structure
event = ft_read_event(data);
% define trials
cfg          = [];
cfg.dataset  = data;
cfg.trialfun = 'trialfun_stimon';
cfg = ft_definetrial(cfg);
% make trials
cfg.timestampspersecond =  spike.hdr.FileHeader.Frequency; % 40000
spikeTrials = ft_spike_maketrials(cfg,spike);
% It is also possible to create only one trial.
% cfg                     = [];
% hdr                     = ft_read_header(data);
% cfg.trl                 = [0 hdr.nSamples*hdr.TimeStampPerSample 0];
% cfg.timestampspersecond =  spike.hdr.FileHeader.Frequency; % 40000
% spike_notrials   = ft_spike_maketrials(cfg,spike);
%% Converting spike structure to continuous raw format and back
% convert to binary format
dat = ft_checkdata(spikeTrials,'datatype', 'raw', 'fsample', 1000);
% convert back
spike_converted = ft_checkdata(dat,'datatype', 'spike');
%% Characterizing inter-spike-interval (ISI) distributions
% To investigate whether the recorded spike trains reveal such 
% non-Poissonian history effects, we study the ISI distribution.
cfg       = [];
cfg.bins  = 0:0.0005:0.1; % use bins of 0.5 milliseconds
cfg.param = 'coeffvar'; % compute the coefficient of variation (sd/mn of isis)
isih = ft_spike_isi(cfg,spikeTrials);
% plot the isi histogram
for k = [1 2] % only do for the single units
  cfg              = [];
  cfg.spikechannel = isih.label{k};
  cfg.interpolate  = 5; % interpolate at 5 times the original density
  cfg.window       = 'gausswin'; % use a gaussian window to smooth
  cfg.winlen       = 0.004; % the window by which we smooth has size 4 by 4 ms
  cfg.colormap     = jet(300); % colormap
  cfg.scatter      = 'no'; % do not plot the individual isis per spike as scatters
  figure, ft_spike_plot_isireturn(cfg,isih)
end
% read in an additional dataset consisting of an M-clust .t file
% read in the .t file
filename    = ['/Volumes/Promise Disk/gf/spike/' 'tt6_7.t'];
cfg         = [];
cfg.dataset = filename;
spike2 = ft_read_spike(cfg.dataset);

% convert timestamps to seconds
cfg                     = [];
cfg.trl                 = [0 max(spike2.timestamp{1})+1 0];
cfg.timestampspersecond = 10^6;
spike2Trial = ft_spike_maketrials(cfg,spike2);

% run the isi histogram
cfg      = [];
cfg.bins = 0:0.001:0.2;
isih = ft_spike_isi(cfg,spike2Trial);

% plot the isi histogram with the Poincare return map
cfg             = [];
cfg.interpolate = 5;
cfg.window      = 'gausswin';
cfg.winlen      = 0.005;
cfg.scatter     = 'no';
cfg.colormap    = jet(300);
figure, ft_spike_plot_isireturn(cfg,isih)
%% Computing spike densities and peri-stimulus time histograms (PSTHs)
cfg             = [];
cfg.binsize     =  0.1; % if cfgPsth.binsize = 'scott' or 'sqrt', we estimate the optimal bin size from the data itself
cfg.outputunit  = 'rate'; % give as an output the firing rate
cfg.latency     = [-1 3]; % between -1 and 3 sec.
cfg.vartriallen = 'yes'; % variable trial lengths are accepted
cfg.keeptrials  = 'yes'; % keep the psth per trial in the output
psth = ft_spike_psth(cfg,spikeTrials);
% raster plot
cfg         = [];
cfg.binsize =  [0.05];
cfg.latency = [-1 3];
psth = ft_spike_psth(cfg,spikeTrials);

cfg              = [];
cfg.topplotfunc  = 'line'; % plot as a line
cfg.spikechannel = spikeTrials.label([1 2]);
cfg.latency      = [-1 3];
cfg.errorbars    = 'std'; % plot with the standard deviation
cfg.interactive  = 'no'; % toggle off interactive mode
figure, ft_spike_plot_raster(cfg,spikeTrials, psth)
% spike density
cfg         = [];
cfg.latency = [-1 3];
cfg.timwin  = [-0.025 0.025];
cfg.fsample = 1000; % sample at 1000 hz
sdf = ft_spikedensity(cfg,spikeTrials);
cfg              = [];
cfg.topplotfunc  = 'line'; % plot as a line plot
cfg.spikechannel = spikeTrials.label([1 2]); % can also select one unit here
cfg.latency      = [-1 3];
cfg.errorbars    = 'std'; % plot with standard deviation
cfg.interactive  = 'no'; % toggle off interactive mode
figure, ft_spike_plot_raster(cfg,spikeTrials, sdf)