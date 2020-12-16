%% set path and load header from edf file
subjID = 's02';
filepath=['/Volumes/WD_D/gufei/consciousness/electrode/use/' subjID];
% filename='FA0576HS';
% hdr = ft_read_header([filepath filesep filename '.edf']);
%% load CT and MRI img
ct_acpc_f = ft_read_mri([filepath '/' subjID '_CT_acpc_f.nii']);
% fsmri_acpc = ft_read_mri([filepath '/' subjID '_MRI_acpc.nii']);
fsmri_acpc = ft_read_mri([filepath '/' subjID '_MRI_acpc.nii']);
fsmri_acpc.coordsys='acpc';
%% load electrodes
load([filepath '/../../../data/' subjID '_elec_acpc_f.mat']);
%% Volume-based registration of MRI image
cfg            = [];
cfg.nonlinear  = 'yes';
cfg.spmversion = 'spm12';
cfg.spmmethod  = 'new';
% cfg.template = '/Volumes/WD_D/gufei/consciousness/electrode/reconstruction/FIELD/standard/MNI152_T1_1mm.nii';
% cfg.template = '/Volumes/WD_D/gufei/consciousness/electrode/reconstruction/chbetter.nii';
cfg.template = '/Volumes/WD_D/gufei/consciousness/electrode/reconstruction/nihpd_sym_all_nifti/nihpd_sym_10.0-14.0_t1w.nii';
% cfg.templatecoordsys = 'mni';
% cfg.opts.bb=[-70 -100 -60;70 70 68];
fsmri_mni = ft_volumenormalise(cfg, fsmri_acpc);
%% save
cfg           = [];
cfg.filename  = [filepath '/' subjID '_MRI_mni'];
cfg.filetype  = 'nifti';
cfg.parameter = 'anatomy';
ft_volumewrite(cfg, fsmri_mni);
%% obtain the electrode positions in standard MNI space.
elec_mni_fv = elec_acpc_f;
elec_mni_fv.elecpos = ft_warp_apply(fsmri_mni.params, elec_acpc_f.elecpos, 'individual2sn');
elec_mni_fv.chanpos = ft_warp_apply(fsmri_mni.params, elec_acpc_f.chanpos, 'individual2sn');
elec_mni_fv.coordsys = 'mni';
%% visualize on a template
% [ftver, ftpath] = ft_version;
% load([ftpath filesep 'template/anatomy/surface_pial_right.mat']);
% 
% % rename the variable that we read from the file, as not to confuse it with the MATLAB mesh plotting function   
% template_lh = mesh; clear mesh;
% 
% ft_plot_mesh(template_lh);
% ft_plot_sens(elec_mni_fv);
% view([90 20]);
% material dull;
% lighting gouraud;
% camlight;
%% Save the normalized electrode information to file
% save([subjID '_elec_mni_fv.mat'], 'elec_mni_fv');
%% lookup atlas
[ftver, ftpath] = ft_version;
% atlas = ft_read_atlas([ftpath filesep 'template/atlas/aal/ROI_MNI_V4.nii']);
% brainnetome atlas
atlas = ft_read_atlas([ftpath filesep 'template/atlas/brainnetome/BNA_MPM_thr25_1.25mm.nii']);
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
elec_mni_fv.position=position;
save([filepath '/../../../data/' subjID '_elec_mni_fv_10-14.mat'], 'elec_mni_fv');
%% load xls 
[num,txt,raw]=xlsread([filepath '/../../' subjID '_elec_name.xlsx']);
% delete '
raw=strrep(raw,'''','');
%% load position
for i=1:length(elec_mni_fv.label)
    % find used electrode name in raw names
    index=match_str(raw(:,2),elec_mni_fv.label{i});
    raw{index,3}=elec_mni_fv.chanpos(i,:);
    raw{index,4}=elec_mni_fv.position{i};
end
%% find unused electrode index
delete=find(strcmp(raw(:,2),'unused')==1);
electrodes=raw;
save([filepath '/../../../data/' subjID '_electrodes_10-14.mat'],'electrodes','delete');