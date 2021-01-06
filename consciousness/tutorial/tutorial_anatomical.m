%% load mri image
subjID = 'SubjectUCI29';
mri = ft_read_mri([subjID '_MR_acpc.nii']); % we used the dcm series
%% determine left and right
ft_determine_coordsys(mri);
%% realign to ac-pc system
cfg           = [];
cfg.method    = 'interactive';
cfg.coordsys  = 'acpc';
mri_acpc = ft_volumerealign(cfg, mri);
%% Write the preprocessed anatomical MRI out to file.
cfg           = [];
cfg.filename  = [subjID '_MR_acpc'];
cfg.filetype  = 'nifti';
cfg.parameter = 'anatomy';
ft_volumewrite(cfg, mri_acpc);
%% Cortical surface extraction with FreeSurfer (optional)
% 这一步的mri_convert会改变图像的坐标显示，但是发现可能和原来的输入的图像并不一样（存疑）
fshome     = '/Applications/freesurfer/7.1.1/';
subdir     = '/Volumes/WD_D/share/software/fieldtrip/ieeg';
mrfile     = '/Volumes/WD_D/share/software/fieldtrip/ieeg/SubjectUCI29_MR_acpc.nii';
system(['export FREESURFER_HOME=' fshome '; ' ...
'source $FREESURFER_HOME/SetUpFreeSurfer.sh; ' ...
'mri_convert -c -oc 0 0 0 ' mrfile ' ' [subdir '/tmp.nii'] '; ' ...
'recon-all -i ' [subdir '/tmp.nii'] ' -s ' 'freesurfer' ' -sd ' subdir ' -all'])
%% Import the extracted cortical surfaces
pial_lh = ft_read_headshape('freesurfer/surf/lh.pial');
pial_lh.coordsys = 'acpc';
ft_plot_mesh(pial_lh);
lighting gouraud;
camlight;
%% Import the FreeSurfer-processed MRI 
fsmri_acpc = ft_read_mri('freesurfer/mri/T1.mgz'); % on Windows, use 'SubjectUCI29_MR_acpc.nii'
fsmri_acpc.coordsys = 'acpc';
%% Preprocessing of the anatomical CT
ct = ft_read_mri([subjID '_CT_acpc_f.nii']); % we used the dcm series
%% 11 Align the anatomical CT to the CTF head surface coordinate system
cfg           = [];
cfg.method    = 'interactive';
cfg.coordsys  = 'ctf';
ct_ctf = ft_volumerealign(cfg, ct);
%% 12 Automatically convert the CT’s coordinate system into an approximation of the ACPC coordinate
ct_acpc = ft_convert_coordsys(ct_ctf, 'acpc');
%% 13 Fuse the CT with the MRI
cfg             = [];
cfg.method      = 'spm';
cfg.spmversion  = 'spm12';
cfg.coordsys    = 'acpc';
cfg.viewresult  = 'yes';
ct_acpc_f = ft_volumerealign(cfg, ct_acpc, fsmri_acpc);
%% Write the MRI-fused anatomical CT out to file.
cfg           = [];
cfg.filename  = [subjID '_CT_acpc_f'];
cfg.filetype  = 'nifti';
cfg.parameter = 'anatomy';
ft_volumewrite(cfg, ct_acpc_f);
%% Import the header information from the recording file
load([subjID '_hdr.mat']);
% hdr = ft_read_header('<path to recording file>');
%% Localize the electrodes in the post-implant CT with ft_electrodeplacement
cfg         = [];
cfg.channel = hdr.label;
elec_acpc_f = ft_electrodeplacement(cfg, ct_acpc_f, fsmri_acpc);
%% Examine whether the variables in resulting electrode structure elec_acpc_f match the recording parameters
% elec_acpc_f =
% 
% unit: 'mm'
% coordsys: 'acpc'
% label: {152x1 cell}
% elecpos: [152x3 double]
% chanpos: [152x3 double]
% tra: [152x152 double]
% cfg: [1x1 struct]
% The channel positions in the chanpos field are initially identical to the electrode positions 
% but may be updated to accommodate offline adjustments in channel combinations, i.e. during re-montaging. 
% For bipolar iEEG data, the best considered channel position is in between the two corresponding electrode positions. 
% The chanpos field is used for overlaying the neural data on (sub-)cortical models during data visualization. 
% The tra field is a matrix with the weight of each electrode into each channel, which at this stage 
% merely is an identity matrix reflecting one-to-one mappings between electrodes and channels.
%% Visualize the MRI along with the electrodes and their labels
ft_plot_ortho(fsmri_acpc.anatomy, 'transform', fsmri_acpc.transform, 'style', 'intersect');
ft_plot_sens(elec_acpc_f, 'label', 'on', 'fontcolor', 'w');
%% Save the resulting electrode information to file.
save([subjID '_elec_acpc_f.mat'], 'elec_acpc_f');
%% Brain shift compensation (optional for cortical grids and strips)
% cfg           = [];
% cfg.method    = 'cortexhull';
% cfg.headshape = 'freesurfer/surf/lh.pial';
% cfg.fshome    = '/Applications/freesurfer/7.1.1/'; % for instance, '/Applications/freesurfer'
% hull_lh = ft_prepare_mesh(cfg);
% save([subjID '_hull_lh.mat'], hull_lh);

load([subjID '_hull_lh.mat']); 
hull_lh = mesh;

%% Project the electrode grids to the surface hull of the implanted hemisphere. 
load([subjID '_elec_acpc_f.mat'])
elec_acpc_fr = elec_acpc_f;
grids = {'LPG*', 'LTG*'};
for g = 1:numel(grids)
cfg             = [];
cfg.channel     = grids{g};
cfg.keepchannel = 'yes';
cfg.elec        = elec_acpc_fr;
cfg.method      = 'headshape';
cfg.headshape   = hull_lh;
cfg.warp        = 'dykstra2012';
cfg.feedback    = 'yes';
elec_acpc_fr = ft_electroderealign(cfg);
end
%% Visualize the cortex and electrodes
ft_plot_mesh(pial_lh);
ft_plot_sens(elec_acpc_fr);
view([-55 10]);
material dull;
lighting gouraud;
camlight;
%% Save the updated electrode information to file.
save([subjID '_elec_acpc_fr.mat'], 'elec_acpc_fr');
%% Volume-based registration (optional)
load([subjID '_elec_acpc_fr.mat'])
cfg            = [];
cfg.nonlinear  = 'yes';
cfg.spmversion = 'spm12';
cfg.spmmethod  = 'new';
fsmri_mni = ft_volumenormalise(cfg, fsmri_acpc);

%% Use the resulting deformation parameters to obtain the electrode positions in standard MNI space.
elec_mni_frv = elec_acpc_fr;
elec_mni_frv.elecpos = ft_warp_apply(fsmri_mni.params, elec_acpc_fr.elecpos, 'individual2sn');
elec_mni_frv.chanpos = ft_warp_apply(fsmri_mni.params, elec_acpc_fr.chanpos, 'individual2sn');
elec_mni_frv.coordsys = 'mni';
%% Visualize the cortical mesh extracted from the standard MNI brain
load([subjID '_elec_mni_frv.mat'])
[ftver, ftpath] = ft_version;
load([ftpath filesep 'template/anatomy/surface_pial_left.mat']);
ft_plot_mesh(mesh);
ft_plot_sens(elec_mni_frv);
view([-90 20]);
material dull;
lighting gouraud;
camlight;
%% Save the normalized electrode information to file.
save([subjID '_elec_mni_frv.mat'], 'elec_mni_frv');
%% Surface-based registration (optional for surface electrodes)
cfg           = [];
cfg.channel   = {'LPG*', 'LTG*'};
cfg.elec      = elec_acpc_fr;
cfg.method    = 'headshape';
cfg.headshape = 'freesurfer/surf/lh.pial';
cfg.warp      = 'fsaverage';
cfg.fshome    = '/Applications/freesurfer/7.1.1/'; % for instance, '/Applications/freesurfer'
elec_fsavg_frs = ft_electroderealign(cfg);

%% Visualize FreeSurfer’s fsaverage brain along with the spatially normalized electrodes
fspial_lh = ft_read_headshape([cfg.fshome '/subjects/fsaverage/surf/lh.pial']);
fspial_lh.coordsys = 'fsaverage';
ft_plot_mesh(fspial_lh);
ft_plot_sens(elec_fsavg_frs);
view([-90 20]);
material dull;
lighting gouraud;
camlight;

%% Save the normalized electrode information to file.
save([subjID '_elec_fsavg_frs.mat'], 'elec_fsavg_frs');
%% Anatomical labeling (optional)
atlas = ft_read_atlas([ftpath filesep 'template/atlas/aal/ROI_MNI_V4.nii']);
%%  Look up the corresponding anatomical label of an electrode of interest
cfg            = [];
cfg.roi        = elec_mni_frv.chanpos(match_str(elec_mni_frv.label,'LHH1'),:);
cfg.atlas      = atlas;
% cfg.inputcoord = 'mni'; %forbidden
cfg.output     = 'single';
labels = ft_volumelookup(cfg, atlas);

[~, indx] = max(labels.count);
labels.name(indx)