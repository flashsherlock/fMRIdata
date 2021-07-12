%% Preprocessing
% load spike data
data=['/Volumes/Promise Disk/gf/spikefield/' 'p029_sort_final_01.nex'];
filename         = data;
spike            = ft_read_spike(filename);

cfg              = [];
cfg.spikechannel = {'sig002a_wf', 'sig003a_wf'};
spike            = ft_spike_select(cfg, spike);
% load LFP data
% get the cfg.trl
cfg          = [];
cfg.dataset  = filename;
cfg.trialfun = 'trialfun_stimon_samples';
cfg          = ft_definetrial(cfg);

% read in the data in trials
cfg.channel   = {'AD01', 'AD02', 'AD03', 'AD04'}; % these channels contain the LFP
cfg.padding   = 10; % length to which we pad for filtering
cfg.dftfreq   = [60-1*(1/10):(1/10):60+1*(1/10) ]; % filter out 60 hz line noise
cfg.dftfilter = 'yes';
data_lfp      = ft_preprocessing(cfg); % read in the LFP

% sample = double(ts-FirstTimeStamp) / double(TimeStampPerSample) + 1;

% two options to further process the raw spike data
% first, directly create trials for the spike structure
cfg           = [];
cfg.dataset   = filename;
cfg.trialfun  = 'trialfun_stimon_samples';
cfg           = ft_definetrial(cfg);
trl           = cfg.trl;

cfg           = [];
cfg.hdr       = data_lfp.hdr; % contains information for conversion of samples to timestamps
cfg.trlunit   = 'samples';
cfg.trl       = trl; % now in samples
spikeTrials   = ft_spike_maketrials(cfg,spike);
%  or use the ‘trialfun_stimon’ that we defined in the spike tutorial
% cfg = [];
% cfg.dataset = filename;
% cfg.trialfun = 'trialfun_stimon'; % this was defined in the spike tutorial
% cfg = ft_definetrial(cfg);
% cfg.timestampspersecond = 40000;
% spikeTrials2 = ft_spike_maketrials(cfg, spike);

% second, append the spikes to the LFP data in binary data format
data_all = ft_appendspike([], data_lfp, spike);

%% Analyzing spikes and LFPs recorded from the same electrode
cfg              = [];
cfg.method       = 'nan'; % replace the removed segment with nans
cfg.timwin       = [-0.002 0.002]; % remove 4 ms around every spike
cfg.spikechannel = spike.label{1};
cfg.channel      = data_lfp.label(2);
data_nan         = ft_spiketriggeredinterpolation(cfg, data_all);

cfg.method       = 'linear'; % remove the replaced segment with interpolation
data_i           = ft_spiketriggeredinterpolation(cfg, data_all);
% illustrate this method by plotting the data
figure,
plot(data_i.time{1}, data_i.trial{1}(2, :), 'g-'), hold on, plot(data_i.time{1}, data_i.trial{1}(5, :), 'r')
hold on
plot(data_nan.time{1}, data_nan.trial{1}(2, :), 'go')
hold on
plot(data_all.time{1}, data_all.trial{1}(2, :), 'k-')
xlim([0.9 1])
xlabel('time (s)')

%% Computing the spike triggered average LFP
% The first step in the analysis of spike-LFP phase-coupling should be
% the computation of the spike-triggered average (STA) of the LFP.
% ERROR: cfg.latency is not used in ft_spiketriggeredaverage function
% cfgSelect.latency = cfg.latency;
% if length(cfg.trials)~=length(data.trial)
%     cfgSelect.trials  = cfg.trials;
% end
% SOLUTION: add above lines after line 139 (cfgSelect = [])
cfg              = [];
cfg.timwin       = [-0.25 0.25]; % take 400 ms
cfg.spikechannel = spike.label{1}; % first unit
cfg.channel      = data_lfp.label(1:4); % first four chans
cfg.latency      = [0.3 10];
staPost          = ft_spiketriggeredaverage(cfg, data_all);

% plot the sta
figure
plot(staPost.time, staPost.avg(:,:)')
legend(data_lfp.label)
xlabel('time (s)')
xlim(cfg.timwin)

% also show the STA for spikes in the pre-stimulus perio
cfg              = [];
cfg.timwin       = [-0.25 0.25]; % take 400 ms
cfg.spikechannel = spike.label{1}; % first unit
cfg.channel      = data_lfp.label(1:4); % first four chans
cfg.latency      = [-2.75 0];
staPre           = ft_spiketriggeredaverage(cfg, data_all);

figure
plot(staPre.time, staPre.avg(:,:)')
legend(data_lfp.label)
xlabel('time (s)')
xlim(cfg.timwin)
%% Computing the phases of spikes relative to the ongoing LFP
% The first algorithm ft_spiketriggeredspectrum_fft computes the FFT locally
% around every spike and uses the same window length for all frequencies.
cfg              = [];
cfg.method       = 'mtmfft';
cfg.foilim       = [20 100]; % cfg.timwin determines spacing
cfg.timwin       = [-0.05 0.05]; % time window of 100 msec
cfg.taper        = 'hanning';
cfg.spikechannel = spike.label{1};
cfg.channel      = data_lfp.label;
stsFFT           = ft_spiketriggeredspectrum(cfg, data_all);
ang = angle(stsFFT.fourierspctrm{1});
mag = abs(stsFFT.fourierspctrm{1});
% The other algorithm in ft_spiketriggeredspectrum_convol computes the phase
% for every frequency separately by computing the DFT for a given frequency through convolution.
cfg           = [];
cfg.method    = 'mtmconvol';
cfg.foi       = 20:10:100;
cfg.t_ftimwin = 5./cfg.foi; % 5 cycles per frequency
cfg.taper     = 'hanning';
% The latter way of calling ft_spiketriggeredspectrum is advantageous
stsConvol     = ft_spiketriggeredspectrum(cfg, data_all);
stsConvol2    = ft_spiketriggeredspectrum(cfg, data_lfp, spikeTrials);
%% Computing statistics on the output from ft_spiketriggeredspectrum.m
for k = 1:length(stsConvol.label)

  % compute the statistics on the phases
  cfg               = [];
  cfg.method        = 'ppc0'; % compute the Pairwise Phase Consistency
  excludeChan       = str2num(stsConvol.label{k}(6)); % exclude the same channel
  chan              = true(1,4);
  chan(excludeChan) = false;
  cfg.spikechannel  = stsConvol.label{k};
  cfg.channel       = stsConvol.lfplabel(chan); % selected LFP channels
  cfg.avgoverchan   = 'unweighted'; % weight spike-LFP phases irrespective of LFP power
  cfg.timwin        = 'all'; % compute over all available spikes in the window
  cfg.latency       = [0.3 nanmax(stsConvol.trialtime(:))]; % sustained visual stimulation period
  statSts           = ft_spiketriggeredspectrum_stat(cfg,stsConvol);

  % plot the results
  figure
  plot(statSts.freq,statSts.ppc0')
  xlabel('frequency')
  ylabel('PPC')
end

param = 'ppc0'; % set the desired parameter
% param = 'plv';
for k = 1:length(stsConvol.label)
  cfg                = [];
  cfg.method         = param;
  excludeChan        = str2num(stsConvol.label{k}(6)); % this gives us the electrode number of the unit
  chan = true(1,4);
  chan(excludeChan)  = false;
  cfg.spikechannel   = stsConvol.label{k};
  cfg.channel        = stsConvol.lfplabel(chan);
  cfg.avgoverchan    = 'unweighted';
  cfg.winstepsize    = 0.01; % step size of the window that we slide over time
  cfg.timwin         = 0.5; % duration of sliding window
  statSts            = ft_spiketriggeredspectrum_stat(cfg,stsConvol);

  statSts.(param) = permute(conv2(squeeze(statSts.(param)), ones(1,20)./20, 'same'),[3 1 2]); % apply some smoothing over 0.2 sec

  figure
  cfg            = [];
  cfg.parameter  = param;
  cfg.refchannel = statSts.labelcmb{1,1};
  cfg.channel    = statSts.labelcmb{1,2};
  cfg.xlim       = [-1 2];
  ft_singleplotTFR(cfg, statSts)
end