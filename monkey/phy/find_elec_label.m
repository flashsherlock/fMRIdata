function position=find_elec_label(subjID,elec,level)
% atlas
atpath = '/Volumes/WD_D/gufei/monkey_data/IMG/';
load([atpath subjID '_NMT/' 'SARM_in_' subjID '_anat.mat'])

% level=3;
len=size(elec.chanpos,1);
position=cell(len,length(level));

% lookup for each level
for i_level=1:length(level)
    % lookup positions
    i_atlas=atlas;
    i_atlas.dim=i_atlas.dim(1:3);
    i_atlas.parcellation=squeeze(i_atlas.parcellation(:,:,:,level(i_level)));
    cfg            = [];
    cfg.roi        = elec.chanpos(:,:);
    cfg.atlas      = i_atlas;
    cfg.output     = 'multiple';
    labels = ft_volumelookup(cfg, atlas);
    % find labels
    for i=1:len
        [~, indx] = max(labels(i).count);
        position{i,i_level}=labels(i).name(indx);
    end
end
% export coordinates in atlas system
atlas_coord=mat2cell(elec.elecpos,ones(length(elec.elecpos),1));
position=[atlas_coord position];
end

% [ftver, ftpath] = ft_version;
% % brainnetome atlas
% bnatlas = ft_read_atlas([ftpath filesep 'template/atlas/brainnetome/BNA_MPM_thr25_1.25mm.nii']);