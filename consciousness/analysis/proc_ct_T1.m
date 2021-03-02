%% set path
subjID = 's05';
filepath=['/Volumes/WD_D/gufei/consciousness/electrode/use/' subjID];
%% convert mgz to nii
mri_convert=['mri_convert ' filepath '/' subjID '/mri/' 'T1.mgz ' filepath '/' subjID '/mri/' 'T1.nii'];
unix(mri_convert)
%% load spm reoriented img
ct_acpc = ft_read_mri([filepath '/' subjID '_CT_acpc.nii']);
%% load aligned MRI image
% on Windows, use 'SubjectUCI29_MR_acpc.nii'
fsmri_acpc = ft_read_mri([filepath '/' subjID '_MRI_acpc.nii']);
fsmri_acpc.coordsys = 'acpc';
%% Fusion of the CT with the MRI
cfg             = [];
cfg.method      = 'spm';
cfg.spmversion  = 'spm12';
cfg.coordsys    = 'acpc';
cfg.viewresult  = 'yes';
ct_acpc_f = ft_volumerealign(cfg, ct_acpc, fsmri_acpc);
%% Write the fused CT out to file.
cfg           = [];
cfg.filename  = [filepath '/' subjID '_CT_acpc_f'];
cfg.filetype  = 'nifti';
cfg.parameter = 'anatomy';
ft_volumewrite(cfg, ct_acpc_f);
%% load images and align to T1.nii
fsmri_acpc = ft_read_mri([filepath '/' subjID '/mri/T1.nii']); 
ct_acpc = ft_read_mri([filepath '/' subjID '_CT_acpc_f.nii']);
%% Fusion of the CT with the MRI
cfg             = [];
cfg.method      = 'spm';
cfg.spmversion  = 'spm12';
cfg.coordsys    = 'acpc';
cfg.viewresult  = 'yes';
ct_acpc_f = ft_volumerealign(cfg, ct_acpc, fsmri_acpc);
%% visualize image
% cfg=[];
% ft_sourceplot(cfg,ct_acpc_f);
%% reslice 
cfg = [];
cfg.dim = [256 256 256];
ct_acpc_f = ft_volumereslice(cfg,ct_acpc_f);
%% write resliced CT to brain3D folder
resultsdir = [filepath '/' subjID '/brain3D'];
if ~exist(resultsdir,'dir')
    mkdir(resultsdir)
end
cfg           = [];
cfg.filename  = [resultsdir '/' subjID '_CT'];
cfg.filetype  = 'nifti';
cfg.parameter = 'anatomy';
ft_volumewrite(cfg, ct_acpc_f);
%% use 3dresample in afni to fix problem in orientation
input = [resultsdir '/' subjID '_CT.nii'];
output = [resultsdir '/' subjID '_CTr.nii'];
master = [resultsdir '/../mri/T1.nii'];
afni_resample=['3dresample -input ' input ' -master ' master ' -prefix ' output];
unix(afni_resample)