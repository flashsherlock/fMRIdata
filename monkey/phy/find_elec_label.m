function position=find_elec_label(subjID,elec)
% atlas
atpath = '/Volumes/WD_D/gufei/monkey_data/IMG/';
% atlas = ft_read_atlas([atpath subjID '_NMT/' 'SARM_in_' subjID '_anat.nii.gz']);
% [abb label]=textread([atpath subjID '_NMT/' 'SARM_key_all.txt']','%*d%s%s%*s%*s','headerlines',1);
% atlas.parcellationlabel=abb';
% save([atpath subjID '_NMT/' 'SARM_in_' subjID '_anat.mat'],'atlas');
load([atpath subjID '_NMT/' 'SARM_in_' subjID '_anat.mat'])

level=6;
len=length(elec.label);
position=cell(len,level-2);

for i_level=3:level
i_atlas=atlas;
i_atlas.dim=i_atlas.dim(1:3);
i_atlas.parcellation=squeeze(i_atlas.parcellation(:,:,:,i_level));
cfg            = [];
% cfg.roi        = elec.chanpos(match_str(elec.label,'LHH1'),:);
cfg.roi        = elec.chanpos(:,:);
cfg.atlas      = i_atlas;
% cfg.inputcoord = 'mni';
cfg.output     = 'multiple';
labels = ft_volumelookup(cfg, atlas);

for i=1:len
    [~, indx] = max(labels(i).count);
    position{i,i_level}=labels(i).name(indx);
end

end

end

% [ftver, ftpath] = ft_version;
% % brainnetome atlas
% bnatlas = ft_read_atlas([ftpath filesep 'template/atlas/brainnetome/BNA_MPM_thr25_1.25mm.nii']);