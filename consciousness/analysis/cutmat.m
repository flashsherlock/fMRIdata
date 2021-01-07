function eeg=cutmat(subjID)
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
for i=1:3
    % file name
    dataset=[indata_path '/' subjID sfix{i} '.mat'];
    if exist(dataset,'file')
        
        load(dataset);
        % delete some data affected by resistance check
        eeg = nc_trialdel( eeg );
        % get start time points of each block
        trl = nc_blockfun(eeg);
        % cut blocks (15s before onset )
        eeg = nc_trialcut(eeg,trl,fix(-15*eeg.fsample),0);
        % save data
%         save([block_path '/' subjID sfix{i} '.mat'],'eeg');
        
    end
end

end
% select channels
% cfg.channel    = ft_channelselection({'all','-DC*','-*ref'}, eeg.label);
% dataFIC=ft_selectdata(cfg,eeg);

% select data by trialinfo
% cfg.trials = test.trialinfo==2;
% dataFIC = ft_selectdata(cfg, eeg);