function data = nc_trialdel( eeg )
% delete trials for specific subjects
% get file name
[~,name,~]=fileparts(eeg.cfg.previous.dataset);
switch name
    case 's04'
        % block NO.7 was affected by resistence checking
        eeg.trial{1}(:,1.04e6:1.21e6)=[];
        eeg.time{1}(1.04e6:1.21e6)=[];
        data=eeg;
    case 's03_awake'
        % unexpected one point at the end
        % must delete the end first (index will shift after modification)
        eeg.trial{1}(:,8.6e5:end)=[];
        eeg.time{1}(:,8.6e5:end)=[];
        % also delete the blank before experiment
        eeg.trial{1}(:,1:6e4)=[];
        eeg.time{1}(:,1:6e4)=[];
        data=eeg;
    case 's02'
        % zero padding before experiment
        padtrial=zeros(size(eeg.trial{1},1),fix(15*eeg.fsample));
        eeg.trial{1}=[padtrial eeg.trial{1}];
        padtime=-15:1/eeg.fsample:-1/eeg.fsample;
        eeg.time{1}=[padtime eeg.time{1}];
        data=eeg;
    case 's01_1'
        % the last block was interrupted
        eeg.trial{1}(:,4.1e6:end)=[];
        eeg.time{1}(4.1e6:end)=[];
        % also delete the blank before experiment
        eeg.trial{1}(:,1:5.6e5)=[];
        eeg.time{1}(:,1:5.6e5)=[];
        data=eeg;
    otherwise
        data=eeg;
end
end

