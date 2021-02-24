%% set path
subjID = 's04';
filepath='/Volumes/WD_D/gufei/consciousness';
sfix={'','_awake','_sleep'};
% use bipolar block data
indata=dir([filepath '/data/' subjID '*' '_block']);
indata_path=indata(1).folder;
%% load data
for i=1:3
    % file name
    dataset=[indata_path '/' subjID sfix{i} '.mat'];
    % load and plot if data exist
    if exist(dataset,'file')
        load(dataset);
        % Baseline-correction options
        cfg = [];
        cfg.demean          = 'yes';
        cfg.baselinewindow  = [-2 0];
        eeg = ft_preprocessing(cfg, eeg);
        % prepare layout for ploting
        lay = nc_prepare_lay(eeg);
        % plot ERP for each odor
        % 2-lemon 4-chocolate 5-garlic
        for iodor=[2 4 5]
            % define trials to be ploted
            cfg = [];
            cfg.trials = find(eeg.trialinfo==iodor);
            % all of the trials
            cfg.trials = 1:length(eeg.trialinfo);
            % timelock analysis
            odor = ft_timelockanalysis(cfg, eeg);
            % plot ERP
            cfg = [];
            cfg.layout = lay;
            cfg.interactive = 'yes';
            cfg.showoutline = 'yes';
            ft_multiplotER(cfg, odor);
            
            % time-frequency analysis
            cfg            = [];
            cfg.method     = 'mtmconvol';
            cfg.toi        = -1:0.01:5;
            cfg.foi        = 1:5:96;
            cfg.t_ftimwin  = ones(length(cfg.foi),1).*0.2;
            cfg.taper      = 'hanning';
            cfg.output     = 'pow';
            cfg.keeptrials = 'no';
            freq = ft_freqanalysis(cfg, eeg);
            % baseline correction
            cfg              = [];
            cfg.baseline     = [-1 0];
            cfg.baselinetype = 'relchange';
            freq_blc = ft_freqbaseline(cfg, freq);
            % plot
            cfg             = [];
            cfg.layout      = lay;
            cfg.showoutline = 'yes';
            ft_multiplotTFR(cfg, freq_blc);
        end
    end
end
%% plot signal
cfg = [];
cfg.channel = 1:5;
cfg.viewmode = 'vertical';
cfg.channelclamped = {'DC05'};
cfg.ylim = 'maxmin';
cfg.mychan = {'DC05'};
cfg.mychanscale = 1e-5*2;
% eegplot = ft_databrowser(cfg,eeg);
%% old codes for ploting markers
% load('subject1_2.mat')
% m=eeg.trial{1,1}(39:42,:);
% range=5000:55000;
% figure
% subplot(4,1,1)
% plot(m(1,range))
% set(gca, 'yLim', [0 4e6]);
% title(eeg.label(39))
% 
% subplot(4,1,2)
% plot(m(2,range))
% set(gca, 'yLim', [0 4e6]);
% title(eeg.label(40))
% 
% subplot(4,1,3)
% plot(m(3,range))
% set(gca, 'yLim', [0 4e6]);
% title(eeg.label(41))
% 
% subplot(4,1,4)
% plot(m(4,range))
% title(eeg.label(42))