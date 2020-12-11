%% set path
subjID = 's04';
filepath='E:/NanChang/use';
%% load CT image
ct = ft_read_mri([filepath '/' subjID '_CT.nii']);
%% determine left and right
ft_determine_coordsys(ct);
%% Align the anatomical CT to the CTF head surface coordinate system
cfg           = [];
cfg.method    = 'interactive';
cfg.coordsys  = 'ctf';
ct_ctf = ft_volumerealign(cfg, ct);
%% Align again
cfg           = [];
cfg.method    = 'interactive';
cfg.coordsys  = 'ctf';
ct_ctf = ft_volumerealign(cfg, ct_ctf);
%% convert the CT¡¯s coordinate system into an approximation of the ACPC coordinate system
ct_acpc = ft_convert_coordsys(ct_ctf, 'acpc');
%% save acpc aligned image
cfg           = [];
cfg.filename  = [filepath '/' subjID '_CT_acpc'];
cfg.filetype  = 'nifti';
cfg.parameter = 'anatomy';
ft_volumewrite(cfg, ct_acpc);
%% load spm reoriented img
ct_acpc = ft_read_mri([filepath '/' subjID '_CT_acpc.nii']);
%% load aligned MRI image
% fsmri_acpc = ft_read_mri('freesurfer/mri/T1.mgz'); 
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
%% Write the preprocessed anatomical MRI out to file.
cfg           = [];
cfg.filename  = [filepath '/' subjID '_CT_acpc_f'];
cfg.filetype  = 'nifti';
cfg.parameter = 'anatomy';
ft_volumewrite(cfg, ct_acpc_f);
