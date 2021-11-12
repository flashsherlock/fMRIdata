subjID = 'RM035';
filepath = '/Volumes/WD_D/gufei/monkey_data/IMG/';
load([filepath '/' subjID '_elec.mat']);
level=3:4;
position = find_elec_label(subjID,elec_acpc_f,level);
%% save position
% add a new field and save
elec_acpc_f.position=position;
save([filepath '/' subjID '_elec_label.mat'], 'elec_acpc_f');
%% plot electrodes on nii

cmd=['3dcalc -a ' ]
            -expr 'step(9-(x-20)*(x-20)-(y-30)*(y-30)-(z-70)*(z-70))' \
            -prefix ball