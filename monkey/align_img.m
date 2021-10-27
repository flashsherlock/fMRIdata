%% load spm reoriented img
subjID = 'RM033';
filepath=['/Volumes/WD_D/gufei/monkey_data/IMG/'];
%% copy images
cd(filepath);
copy = ['cp ' subjID '_CT.nii ' subjID '_CT_acpc.nii'];
unix(copy)
copy = ['cp ' subjID '_MRI.nii ' subjID '_MRI_acpc.nii'];
unix(copy)
%% load images
ct_acpc = ft_read_mri([filepath '/' subjID '_CT_flip.nii']);
fsmri_acpc = ft_read_mri([filepath '/' subjID '_MRI_acpc.nii']);
fsmri_acpc.coordsys = 'acpc';
%% flip CT
cmd=['3dLRflip -prefix ' subjID '_CT_flip.nii ' subjID '_CT_acpc.nii'];
unix(cmd)
%% Fusion of the CT with the MRI
cfg             = [];
cfg.method      = 'spm';
cfg.spmversion  = 'spm12';
cfg.coordsys    = 'acpc';
cfg.viewresult  = 'yes';
cfg.spm.cost_fun = 'mi';
cfg.spm.tol=[0.01 0.01 0.01 0.01 0.01 0.01];
ct_acpc_f = ft_volumerealign(cfg, ct_acpc, fsmri_acpc);
%% Write the fused CT out to file.
cfg           = [];
cfg.filename  = [filepath '/' subjID '_CT_acpc_f'];
cfg.filetype  = 'nifti';
cfg.parameter = 'anatomy';
ft_volumewrite(cfg, ct_acpc_f);