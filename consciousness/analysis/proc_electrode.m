%% set path and load header from edf file
subjID = 's02';
filepath=['/Volumes/WD_D/gufei/consciousness/electrode/use/' subjID];
% filename='FA0576HS';
% hdr = ft_read_header([filepath filesep filename '.edf']);
%% load CT and MRI img
ct_acpc_f = ft_read_mri([filepath '/' subjID '_CT_acpc_f.nii']);
fsmri_acpc = ft_read_mri([filepath '/' subjID '_MRI_acpc.nii']);
fsmri_acpc.coordsys='acpc';
%% generate labels manually
% prefix='POL ';
% s01
% ename=['A' 'H' 'J'];
% enum=[14 12 14];
% s02
% ename=['A' 'H' 'J' 'C' 'I' 'a' 'h'];
% enum=[14 12 12 14 6 12 2];
% s03
% ename=['F' 'G' 'Q' 'R'];
% enum=[14 12 12 14];
% s04
ename=['A' 'H' 'J' 'C' 'I' 'a' 'h'];
enum=[14 12 12 14 6 12 2];
names=cell(sum(enum),1);
for i=1:length(ename)
% A=[repmat('A',14,1) [1:14]'];
name_tmp=reshape(sprintf([ename(i) '%02d'],1:enum(i)),3,[])';
names(sum(enum(1:i))-enum(i)+1:sum(enum(1:i)),1)=cellstr(name_tmp);
end
hdr.label=names;
%% place electrodes
cfg         = [];
cfg.channel = hdr.label;
elec_acpc_f = ft_electrodeplacement(cfg, ct_acpc_f, fsmri_acpc);
%% visualize electrodes
ft_plot_ortho(fsmri_acpc.anatomy, 'transform', fsmri_acpc.transform, 'style', 'intersect');
ft_plot_sens(elec_acpc_f, 'label', 'on', 'fontcolor', 'w');
%% place again if find any error
load([subjID '_elec_acpc_f.mat']);
cfg=[];
cfg.elec=elec_acpc_f;
elec_acpc_f = ft_electrodeplacement(cfg, ct_acpc_f, fsmri_acpc);
%% save
% elec_acpc_f should have coordsys acpc after previous steps
elec_acpc_f.coordsys='acpc';
save([subjID '_elec_acpc_f.mat'], 'elec_acpc_f');
%% Volume-based registration of MRI image
cfg            = [];
cfg.nonlinear  = 'yes';
cfg.spmversion = 'spm12';
cfg.spmmethod  = 'new';
% cfg.template = '/Volumes/WD_D/gufei/consciousness/electrode/reconstruction/ch2bet.nii';
% cfg.templatecoordsys = 'acpc';
fsmri_mni = ft_volumenormalise(cfg, fsmri_acpc);
%% save
cfg           = [];
cfg.filename  = [filepath '/' subjID '_MRI_mni'];
cfg.filetype  = 'nifti';
cfg.parameter = 'anatomy';
ft_volumewrite(cfg, fsmri_mni);
%% btain the electrode positions in standard MNI space.
elec_mni_fv = elec_acpc_f;
elec_mni_fv.elecpos = ft_warp_apply(fsmri_mni.params, elec_acpc_f.elecpos, 'individual2sn');
elec_mni_fv.chanpos = ft_warp_apply(fsmri_mni.params, elec_acpc_f.chanpos, 'individual2sn');
elec_mni_fv.coordsys = 'mni';
%% visualize on a template
[ftver, ftpath] = ft_version;
load([ftpath filesep 'template/anatomy/surface_pial_right.mat']);

% rename the variable that we read from the file, as not to confuse it with the MATLAB mesh plotting function   
template_lh = mesh; clear mesh;

ft_plot_mesh(template_lh);
ft_plot_sens(elec_mni_fv);
view([90 20]);
material dull;
lighting gouraud;
camlight;
%% Save the normalized electrode information to file
save([subjID '_elec_mni_fv.mat'], 'elec_mni_fv');