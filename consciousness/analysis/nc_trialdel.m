function data = nc_trialdel( eeg )
% delete trials for specific subjects
% get file name
[~,name,~]=fileparts(eeg.cfg.previous.dataset);
switch name
    case 's04'
        eeg.trial{1}(:,1.04e6:1.21e6)=[];
        eeg.time{1}(1.04e6:1.21e6)=[];
        data=eeg;
    otherwise
        data=eeg;
end
end

