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