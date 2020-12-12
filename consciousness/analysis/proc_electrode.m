%% set path and load header from edf file
subjID = 's03';
filepath='/Volumes/WD_D/gufei/consciousness/electrode/use/s03';
% filename='FA0576HS';
% hdr = ft_read_header([filepath filesep filename '.edf']);
%% load CT and MRI img
ct_acpc_f = ft_read_mri([filepath '/' subjID '_CT_acpc_f.nii']);
fsmri_acpc = ft_read_mri([filepath '/' subjID '_MRI_acpc.nii']);
%% generate labels manually
prefix='POL ';
ename=['A' 'H' 'J' 'X'];
enum=[14 14 12 16];
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
save([subjID '_elec_acpc_f.mat'], 'elec_acpc_f');