function proc_elecname(ID)
%% set path and load header from edf file
% subjID = 's02';
subjID = ID;
filepath='/Volumes/WD_D/gufei/consciousness/edf';
% hdr = ft_read_header([filepath '/' subjID '.edf']);
% hdr = ft_read_header([filepath '/' 's02' '.edf']);
%% load xls 
[num,txt,raw]=xlsread([filepath '/../electrode/' subjID '_elec_name.xlsx']);
% delete '
raw=strrep(raw,'''','');
if strcmp(subjID,'s05')
    % replace with labels in header to avoid changes of " ' "
    hdr = ft_read_header([filepath filesep subjID '.edf']);
    raw(:,1)=hdr.label;
end
%% load position
load([filepath '/../data/' subjID '_elec_mni_fv.mat']);
for i=1:length(elec_mni_fv.label)
    % find used electrode name in raw names
    index=match_str(raw(:,2),elec_mni_fv.label{i});
    raw{index,3}=elec_mni_fv.chanpos(i,:);
    raw{index,4}=elec_mni_fv.position{i};
end
%% find unused electrode index
delete=find(strcmp(raw(:,2),'unused')==1);
electrodes=raw;
save([filepath '/../data/' subjID '_electrodes.mat'],'electrodes','delete');
end