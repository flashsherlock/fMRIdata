%% load mri image
subjID = 's16';
filepath=['/Volumes/WD_D/gufei/consciousness/electrode/use/' subjID];
mri = ft_read_mri([filepath '/' subjID '_MRI.nii']);
%% determine left and right
ft_determine_coordsys(mri);
%% realign to ac-pc system
cfg           = [];
cfg.method    = 'interactive';
cfg.coordsys  = 'acpc';
% do not put external toolbox in matlab path
% addpath 'C:\Program Files\MATLAB\R2012b\toolbox\fieldtrip-20201021\compat\matlablt2017b'
mri_acpc = ft_volumerealign(cfg, mri);
%% Write the preprocessed anatomical MRI out to file.
cfg           = [];
cfg.filename  = [filepath '/' subjID '_MRI_acpc'];
cfg.filetype  = 'nifti';
cfg.parameter = 'anatomy';
ft_volumewrite(cfg, mri_acpc);
