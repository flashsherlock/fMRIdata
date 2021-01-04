function data = s02_remove( eeg )
% remove C04-C05 J02-J03
remove=[17 44];
% remove gap electrodes
eeg.label(remove)=[];
eeg.trial{:}(remove,:)=[];
eeg.eposition(remove,:)=[];
data=eeg;

end