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
%%