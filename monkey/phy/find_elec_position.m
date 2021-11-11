subjID = 'RM035';
filepath = '/Volumes/WD_D/gufei/monkey_data/IMG/';
load([filepath '/' subjID '_elec.mat']);
position = find_elec_label(subjID,elec_acpc_f);
%% save position
% add a new field and save
elec_acpc_f.position=position;
save([filepath '/' subjID '_elec_label.mat'], 'elec_acpc_f');