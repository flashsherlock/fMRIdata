%% set path
subjID = 's04';
anandaw=nc_findawake(subjID);
trial_an=1:anandaw(1);
trial_aw=anandaw(2):anandaw(3);
filepath='/Volumes/WD_D/gufei/consciousness';
sfix={'','_awake','_sleep'};
% use bipolar block data
indata=dir([filepath '/data/' subjID '*' '_block']);
indata_path=[indata(1).folder filesep indata(1).name];
%% load data
for i=1:3
    % file name
    dataset=[indata_path '/' subjID sfix{i} '.mat'];
    % load and plot if data exist
    if exist(dataset,'file')
        load(dataset);
      
        % split into anesthetic and awake
        cfg         = [];
        cfg.trials  = trial_an;
        eeg_an=ft_selectdata(cfg,eeg);
        cfg.trials  = trial_aw;
        eeg_aw=ft_selectdata(cfg,eeg);
        % reject trials
        cfg          = [];
        cfg.method   = 'summary';
        cfg.channel = ft_channelselection({'all','-dc*'}, eeg_an.label);
        cfg.keepchannel = 'yes';
        eeg_an        = ft_rejectvisual(cfg,eeg_an);
        eeg_aw        = ft_rejectvisual(cfg,eeg_aw);
        % frequency spectrum
        cfg         = [];
        cfg.output  = 'pow';
        cfg.method  = 'mtmfft';
        cfg.taper   = 'hanning';
        cfg.foi = logspace(log10(0.5),log10(50),31);
        cfg.channel = ft_channelselection({'A*'}, eeg.label);
        spectr_ana  = ft_freqanalysis(cfg, eeg_an);
        spectr_awake  = ft_freqanalysis(cfg, eeg_aw);
        figure;
        hold on;
        plot(spectr_ana.freq, mean(spectr_ana.powspctrm,1), 'linewidth', 2)
        plot(spectr_ana.freq, mean(spectr_awake.powspctrm,1), 'linewidth', 2)
        legend('anesthetic', 'awake')
        xlabel('Frequency (Hz)')
        ylabel('Power (\mu V^2)')
        
        % Baseline-correction options
        cfg = [];
        cfg.demean          = 'yes';
        cfg.baselinewindow  = [-2 0];
        eeg_an = ft_preprocessing(cfg, eeg_an);
        eeg_aw = ft_preprocessing(cfg, eeg_aw);
        % prepare layout for ploting
        % lay = nc_prepare_lay(eeg);
        
        % 2-lemon 4-chocolate 5-garlic
        for iodor=[2 4 5]
            
            % awake
            % define trials to be ploted
            cfg = [];
            cfg.trials = find(eeg_aw.trialinfo==iodor);
            % timelock analysis
%             odor = ft_timelockanalysis(cfg, eeg_aw);
            % time-frequency analysis
            cfgtf=[];
            cfgtf.method     = 'mtmconvol';
            cfgtf.toi        = -2:0.1:5.5;
            cfgtf.foi     = 1:0.5:40;
%             cfgtf.foi = logspace(log10(1),log10(40),31);
%             cfgtf.t_ftimwin  = ones(length(cfgtf.foi),1).*0.5;
            cfgtf.t_ftimwin  = 5./cfgtf.foi;
%             cfgtf.t_ftimwin  = ones(length(cfgtf.foi),1).*1;
            cfgtf.taper      = 'hanning';
            cfgtf.output     = 'pow';
%             cfgtf.keeptrials = 'yes';
            freq = ft_freqanalysis(cfgtf, eeg_aw);
            % baseline correction
            cfg              = [];
            cfg.baseline     = [-0.75 0.25];
            cfg.baselinetype = 'db';
            freq_blc = ft_freqbaseline(cfg, freq);
            % check if some of the trials drive the results
%             freq_blc.powspctrm=permute(freq_blc.powspctrm,[3 2 1 4]);
%             freq_blc.freq=freq_blc.freq(1):1:freq_blc.freq(1)+194;
            % plot
            cfg             = [];
            cfg.channel = ft_channelselection({'F*'}, eeg_aw.label);
%             cfg.channel = ft_channelselection({'all','-dc*'}, eeg.label);
%             cfg.channel = 'DC05';
            % plot TF
            ft_singleplotTFR(cfg, freq_blc);
            % plot ERP            
%             ft_singleplotER(cfg, odor);            
            
            % anesthetic
            cfg = [];
            cfg.trials = find(eeg_an.trialinfo==iodor);
            % timelock analysis
%             odor = ft_timelockanalysis(cfg, eeg_an);
            % time-frequency analysis
            cfgtf.trials = cfg.trials;
            freq = ft_freqanalysis(cfgtf, eeg_an);
            % baseline correction
            cfg              = [];
            cfg.baseline     = [-0.75 -0.25];
            cfg.baselinetype = 'db';
            freq_blc = ft_freqbaseline(cfg, freq);
            % plot
            cfg             = [];
            cfg.channel = ft_channelselection({'F*'}, eeg_an.label);
            % plot TF
            ft_singleplotTFR(cfg, freq_blc);
            % plot ERP            
%             ft_singleplotER(cfg, odor);
            
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