function data = biref( eeg )
% convert to bipolar reference
not_electrode=find(cellfun(@isempty,eeg.eposition(:,4)));
% store dc and ref to temp
temp.label=eeg.label(not_electrode);
temp.trial{:}=eeg.trial{:}(not_electrode,:);
temp.eposition=eeg.eposition(not_electrode,:);
% remove dc and ref
eeg.label(not_electrode)=[];
eeg.trial{:}(not_electrode,:)=[];
eeg.eposition(not_electrode,:)=[];
% get index as ref
index=2:length(eeg.label);
% reref
eeg.label(index-1)=strcat(eeg.label(index-1),'-',eeg.label(index));
eeg.trial{:}(index-1,:)=eeg.trial{:}(index-1,:)-eeg.trial{:}(index,:);

% change eposition to middle point
% add two positions
for i=1:length(index)
    eeg.eposition{i,3}=[eeg.eposition{i,3};eeg.eposition{i+1,3}];
end
% compute mean
eeg.eposition(index-1,3)=cellfun(@(x) mean(x,1),eeg.eposition(index-1,3),'UniformOutput',false);

% remove last position on each eletrode
% find according to the number of unique charactors
gap=find(cellfun(@(x) length(find(isstrprop(unique(x),'alpha'))==1),eeg.label)==2);
remove=[gap; length(eeg.label)];
eeg.label(remove)=[];
eeg.trial{:}(remove,:)=[];
eeg.eposition(remove,:)=[];

% find labels in atlas
[~, ftpath] = ft_version;
% atlas = ft_read_atlas([ftpath filesep 'template/atlas/aal/ROI_MNI_V4.nii']);
% brainnetome atlas
atlas = ft_read_atlas([ftpath filesep 'template/atlas/brainnetome/BNA_MPM_thr25_1.25mm.nii']);
cfg            = [];
cfg.roi        = cell2mat(eeg.eposition(:,3));
cfg.atlas      = atlas;
cfg.output     = 'multiple';
labels = ft_volumelookup(cfg, atlas);
len=length(labels);
position=cell(len,1);
for i=1:len
    [~, indx] = max(labels(i).count);
    position{i}=labels(i).name(indx);
end
eeg.eposition(:,4)=position;

% add dc and ref
eeg.label=[eeg.label;temp.label];
eeg.trial{:}=[eeg.trial{:};temp.trial{:}];
eeg.eposition=[eeg.eposition;temp.eposition];
% change labels in eposition
eeg.eposition(:,2)=[];
eeg.eposition(:,1)=eeg.label;
data=eeg;

end

