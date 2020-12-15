%% set path and load header from edf file
subjID = 's02';
filepath='/Volumes/WD_D/gufei/consciousness/data';
%% lookup areas in atlas
load([filepath '/' subjID '_elec_mni_fv.mat']);
[ftver, ftpath] = ft_version;
atlas = ft_read_atlas([ftpath filesep 'template/atlas/aal/ROI_MNI_V4.nii']);
% brainnetome atlas
% atlas = ft_read_atlas([ftpath filesep 'template/atlas/brainnetome/BNA_MPM_thr25_1.25mm.nii']);
cfg            = [];
% cfg.roi        = elec_mni_fv.chanpos(match_str(elec_mni_fv.label,'LHH1'),:);
cfg.roi        = elec_mni_fv.chanpos(:,:);
cfg.atlas      = atlas;
% cfg.inputcoord = 'mni';
cfg.output     = 'multiple';
labels = ft_volumelookup(cfg, atlas);

len=length(labels);
position=cell(len,1);
for i=1:len
    [~, indx] = max(labels(i).count);
    position{i}=labels(i).name(indx);
end

%% save position
% add a new field and save
elec_mni_fv.position=position;
save([filepath '/' subjID '_elec_mni_fv.mat'], 'elec_mni_fv');