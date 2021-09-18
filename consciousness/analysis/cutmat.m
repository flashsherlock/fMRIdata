function eeg=cutmat(subjID, condition)
% cut raw data to pieces
% condition is a number or array representing [anesthesia ,awake, sleep]
%% set path
filepath='/Volumes/WD_D/gufei/consciousness';
sfix={'','_awake','_sleep'};
%% make dir
switch subjID
    case 's01'
        subname='LinYuqing';        
    case 's02'
        subname='WangMingyuan';
    case 's03'
        subname='HuYifan';
    case 's04'
        subname='WanRuilong';
    case 's05'
        subname='ZhouYuxuan';
    case 's06'
        subname='WuYue';
    case 's07'
        subname='ChenJinhao';
    otherwise
        error('No data for this subject');
end
% use bipolar data
indata_path=[filepath '/data/' subjID '_' subname '_bipolar'];
% save to _block folder
block_path=[filepath '/data/' subjID '_' subname '_block'];
if ~exist(block_path,'dir')
    mkdir(block_path)
end
%% processing
for i=condition
    % file name
    dataset=[indata_path '/' subjID sfix{i} '.mat'];
    if exist(dataset,'file')
        
        load(dataset);
        % change eposition field to fieldtrip format eeg.elec
        eeg = nc_prepare_elec(eeg);
        % delete some data affected by resistance check
        eeg = nc_trialdel( eeg );
        % delete DCs and filt signals
        cfg = [];
        cfg.channel = ft_channelselection({'dc*'}, eeg.label);
        dcs = ft_selectdata(cfg, eeg);
        % define channels
        cfg = [];
        cfg.channel = ft_channelselection({'all','-dc*'}, eeg.label);
        % define filters
        cfg.bpfilter = 'yes';
        cfg.bpfilttype = 'fir';
        cfg.bpfreq = [0.1 80];
        cfg.bsfilter    = 'yes';
        cfg.bsfilttype = 'fir';
        cfg.bsfreq      = [49 51]; 
        % filt data
        eeg = ft_preprocessing(cfg,eeg);
        % add dcs back
        cfg = [];
        eeg = ft_appenddata(cfg,eeg,dcs);
        % cut to blocks
        % get start time points of each block
%         trl = nc_blockfun(eeg);
        % cut blocks (15s before onset )
%         eeg = nc_trialcut(eeg,trl,fix(-15*eeg.fsample),0);
        % cut to trials
        % get start time points of each trial
        trl = nc_trialfun(eeg);
        % cut blocks (2s before onset and 0.5s after offset)
        eeg = nc_trialcut(eeg,trl,fix(-7*eeg.fsample),fix(2*eeg.fsample));
        
%         save data
        save([block_path '/' subjID sfix{i} '.mat'],'eeg');
        
    end
end

end
% select channels
% cfg.channel    = ft_channelselection({'all','-DC*','-*ref'}, eeg.label);
% dataFIC=ft_selectdata(cfg,eeg);

% select data by trialinfo
% cfg.trials = test.trialinfo==2;
% dataFIC = ft_selectdata(cfg, eeg);