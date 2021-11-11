%% load spm reoriented img
subjID = 'RM035';
filepath=['/Volumes/WD_D/gufei/monkey_data/IMG/'];
% copy images
cd(filepath);
copy = ['cp ' subjID '_CT.nii ' subjID '_CT_acpc.nii'];
unix(copy)
copy = ['cp ' subjID '_MRI.nii ' subjID '_MRI_acpc.nii'];
unix(copy)
% flip CT
cmd=['3dLRflip -prefix ' subjID '_CT_flip.nii ' subjID '_CT_acpc.nii'];
% 3drefit -xdel 0.3 -ydel 0.3 -zdel 0.3 RM033_CT_flip.nii
unix(cmd)
% load images
ct_acpc = ft_read_mri([filepath '/' subjID '_CT_flip.nii']);
fsmri_acpc = ft_read_mri([filepath '/' subjID '_MRI_acpc_bk.nii']);
fsmri_acpc.coordsys = 'acpc';
% Fusion of the CT with the MRI
cfg             = [];
cfg.method      = 'spm';
cfg.spmversion  = 'spm12';
cfg.coordsys    = 'acpc';
cfg.viewresult  = 'yes';
% cfg.spm.cost_fun = 'mi';
% cfg.spm.tol=[0.01 0.01 0.01 0.01 0.01 0.01];
ct_acpc_f = ft_volumerealign(cfg, ct_acpc, fsmri_acpc);
% 3drotate -quintic -rotate 20.96I 24.56R -2.32A -ashift 0.23S -42.44L 24.40P
% Write the fused CT out to file.
cfg           = [];
cfg.filename  = [filepath '/' subjID '_CT_acpc_f'];
cfg.filetype  = 'nifti';
cfg.parameter = 'anatomy';
ft_volumewrite(cfg, ct_acpc_f);

%% Place electrodes
% load CT and MRI img
ct_acpc_f = ft_read_mri([filepath '/' subjID '_CT_final.nii']);
fsmri_acpc = ft_read_mri([filepath '/' subjID '_MRI_acpc_bk.nii']);
fsmri_acpc.coordsys='acpc';
% generate labels manually
channel=33:64;
bad_channel=[35 37 38 46 50 53 55 56 57];
channel(ismember(channel,bad_channel))=[];
names=cell(2*length(channel),1);
for i_channel=1:length(channel)
names{i_channel}=strcat('WB',num2str(channel(i_channel)));
names{length(channel)+i_channel}=strcat('O_WB',num2str(channel(i_channel)));
end
hdr.label=names;
% place electrodes
cfg         = [];
cfg.channel = hdr.label;
elec_acpc_f = ft_electrodeplacement(cfg, ct_acpc_f, fsmri_acpc);
% place again if find any error
load([filepath '/' subjID '_elec.mat']);
cfg=[];
cfg.elec=elec_acpc_f;
elec_acpc_f = ft_electrodeplacement(cfg, ct_acpc_f, fsmri_acpc);
% save
elec_acpc_f.coordsys='acpc';
save([filepath '/' subjID '_elec.mat'], 'elec_acpc_f');

%% align atlas to MRI
% mri_atlas = ft_read_mri([filepath subjID '_NMT/' subjID '_anat.nii.gz']);
% fsmri_acpc = ft_read_mri([filepath '/' subjID '_MRI_acpc.nii']);
% fsmri_acpc.coordsys='acpc';
% cfg             = [];
% cfg.method      = 'spm';
% cfg.spmversion  = 'spm12';
% cfg.coordsys    = 'acpc';
% cfg.viewresult  = 'yes';
% mri_atlas = ft_volumerealign(cfg, fsmri_acpc, mri_atlas);
x = spm_coreg([filepath subjID '_NMT/' subjID '_anat.nii.gz'], [filepath '/' subjID '_MRI_acpc.nii']);
% cfg           = [];
% cfg.filename  = [filepath '/' subjID '_MRI_atlas'];
% cfg.filetype  = 'nifti';
% cfg.parameter = 'anatomy';
% ft_volumewrite(cfg, atlas);
load([filepath '/' subjID '_elec.mat']);
% visualize electrodes
fsmri_acpc = ft_read_mri([filepath '/' subjID '_MRI_acpc.nii']);
ft_plot_ortho(fsmri_acpc.anatomy, 'transform', fsmri_acpc.transform, 'style', 'intersect');
ft_plot_sens(elec_acpc_f, 'label', 'on', 'fontcolor', 'w');
% transform electrodes
elec_acpc_f.chanpos=ft_warp_apply(inv(spm_matrix(x(:)')), elec_acpc_f.chanpos, 'homogenous');
elec_acpc_f.elecpos=elec_acpc_f.chanpos;
save([filepath '/' subjID '_elec_atlas.mat'], 'elec_acpc_f');