function trl = nc_trialfun( eeg , offset)
% tial function for iEEG
% default off set is 0
% offset is use for consideration of rise time
if nargin==1
    offset=0;
end
% marker=eeg.trial{1}(ismember(eeg.label,{'DC02','DC03','DC04'}),:);
% to make sure the order of DCs
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
% set air to zero
% marker(marker==6)=0;

% shift=2;
% marker(1:end-shift)=marker(1:end-shift)-marker(1+shift:end);
% find onset marker for each odor
lemon=1+find(diff(marker==2)==1);
chocolate=1+find(diff(marker==4)==1);
garlic=1+find(diff(marker==5)==1);
% remove some unexpected value(still remain the same value when+check)
check=500;
lemon=lemon(marker(lemon+check)==2);
chocolate=chocolate(marker(chocolate+check)==4);
garlic=garlic(marker(garlic+check)==5);
try
    start=[lemon;chocolate;garlic]';
    % reshape to one column
    label=reshape(ones(size(start)).*[2,4,5],[],1);
    start=reshape(start,[],1);
    % compute stop
    stop=start+5*eeg.fsample;
    % add offset
    offset=offset*ones(size(start));
    trl=[start stop offset label];
catch
    error('The trial numbers of each odor are not equal')
end
% check position
% plot(marker)
% hold on
% z=nan(size(marker));
% z(lemon)=2;
% z(chocolate)=4;
% z(garlic)=5;
% plot(z,'.','MarkerSize',15);
end

