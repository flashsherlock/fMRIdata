function data = nc_prepare_elec(eeg)
% this function generate eeg.elec from eeg.eposition

% get eposition
eposition=eeg.eposition;
% remove eposition
eeg = rmfield(eeg,'eposition');
% generate elec
elec.label=eposition(:,1);
elec.coordsys='mni';
elec.unit='mm';
% position for DC and ref electrodes are zeros
p=eposition(:,2);
p(cellfun(@isempty,p))={[0 0 0]};
elec.chanpos=cell2mat(p);
% data unit
elec.chanunit=cell(size(elec.label));
elec.chanunit(:,:)={'μV'};
% save elec to eeg
eeg.elec = elec;
data = eeg;

end