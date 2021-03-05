%% set path
subjID = 's04';
filepath='/Volumes/WD_D/gufei/consciousness';
% sfix={'','_awake','_sleep'};
% use bipolar block data
indata=dir([filepath '/data/' subjID '*' '_bipolar']);
indata_path=[indata(1).folder filesep indata(1).name];
%% time-frequency analysis
dataset=[indata_path '/' subjID '.mat'];
if exist(dataset,'file')        
    load(dataset);
    % change eposition field to fieldtrip format eeg.elec
    eeg = nc_prepare_elec(eeg);
    
    % delete DCs and filt signals
    cfg = [];
    cfg.channel = ft_channelselection({'dc*'}, eeg.label);
    dcs = ft_selectdata(cfg, eeg);
    % define channels
    cfg = [];
    cfg.channel = ft_channelselection({'all','-dc*'}, eeg.label);
    % define filters
    cfg.bpfilter = 'yes';
    cfg.bpfreq = [1 100];
    cfg.bsfilter    = 'yes';
    cfg.bsfiltord   = 3;
    cfg.bsfreq      = [49 51; 99 101]; 
    % filt data
    eeg = ft_preprocessing(cfg,eeg);
    % add dcs back
%     cfg = [];
%     eeg = ft_appenddata(cfg,eeg,dcs);        
    
    % get start time points of each trial
    trl=[1 length(eeg.trial{1}) 0 1];
    % cut
    eeg = nc_trialcut(eeg,trl,0,0);
    
    %% select channels to perform tf analysis
    cfg = [];
    cfg.channel = ft_channelselection(1, eeg.label);
    tfs = ft_selectdata(cfg, eeg);
    
    % tf analysis
    cfg            = [];
    cfg.method     = 'mtmconvol';
    cfg.toi        = 'all';
    cfg.foi        = 1:2:27;
    % time window 2s
    cfg.t_ftimwin  = ones(length(cfg.foi),1).*2;
    cfg.tapsmofrq  = ones(length(cfg.foi),1).*1;
    cfg.taper      = 'hanning';
    cfg.output     = 'pow';
    cfg.keeptrials = 'no';
    freq = ft_freqanalysis(cfg, tfs);
    %% plot
    % prepare layout for ploting
%     lay = nc_prepare_lay(eeg);
    cfg = [];
%     cfg.baseline     = [-0.5 -0.1];
%     cfg.baselinetype = 'absolute';
    cfg.maskstyle    = 'saturation';
    cfg.zlim         = [0 300];
    cfg.channel      = 1;
    cfg.layout       = 'CTF151_helmet.mat';
    figure
    ft_singleplotTFR(cfg, freq);
end