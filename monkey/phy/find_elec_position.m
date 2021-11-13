subjID = 'RM035';
filepath = '/Volumes/WD_D/gufei/monkey_data/IMG/';
load([filepath '/' subjID '_elec.mat']);
level=3:4;
position = find_elec_label(subjID,elec_acpc_f,level);
%% save position
% add a new field and save
elec_acpc_f.position=position;
atlas_coord=cell2mat(position(:,1));
save([filepath '/' subjID '_elec_label.mat'], 'elec_acpc_f');
%% plot electrodes on nii
r2=1;
exp=cell(1,length(atlas_coord));
for i_elec=1:length(atlas_coord)
    x=['(x-' num2str(atlas_coord(i_elec,1)) ')'];
    y=['(y-' num2str(atlas_coord(i_elec,2)) ')'];
    z=['(z-' num2str(atlas_coord(i_elec,3)) ')'];
    exp{i_elec}=['step(' num2str(r2) '-' x '*' x '-' y '*' y '-' z '*' z ')'];
end
exp=['''or(' strjoin(exp,',') ')'''];
anat=[filepath '/' subjID '_MRI_acpc.nii'];
cmd=['3dcalc -a ' anat ' -LPI -expr ' exp ' -prefix ' [filepath '/' subjID '_MRI_elec.nii']];
unix(cmd);