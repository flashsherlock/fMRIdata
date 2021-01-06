function trl = nc_blockfun( eeg , offset)
% tial function for iEEG
% default off set is 0
% offset is use for consideration of rise time
if nargin==1
    offset=0;
end
% get trial indexs
trial=nc_trialfun(eeg,offset);
% check if trials can be devided by 5
if mod(length(trial),5)==0
    % find start time of each block by every 5 lemons
    index=1:5:length(trial)/3;
    trl=trial(index,:);
else
    error('Some of the blocks do not contain 5 trials');
end
    checkblock(eeg,trl);
end

function checkblock(eeg,trl)
mindex=zeros(3,1);
for dc=2:4
    mindex(dc-1)=find(strcmp(eeg.label,['DC0' num2str(dc)])==1);
end
% convert to integer values
marker=round(eeg.trial{1}(mindex,:)/1e5);
% set to 1 if >31
marker=marker>31;
% convert to digits
marker=[1 2 4]*marker;
% set air to zero for checking position
marker(marker==6)=0;
% plot marker
plot(marker)
hold on
z=nan(size(marker));
z(trl(trl(:,4)==2,1))=2;
plot(z,'.','MarkerSize',15);
% get file name
[~,name,~]=fileparts(eeg.cfg.previous.dataset);
% add filename as title
title(name);
end