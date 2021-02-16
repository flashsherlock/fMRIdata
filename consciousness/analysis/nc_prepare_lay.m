function lay = nc_prepare_lay(eeg)
% set path
fshome = '/Applications/freesurfer/7.1.1';
two_hemisphere = {[fshome '/subjects/fsaverage/surf/lh.pial'],...
                  [fshome '/subjects/fsaverage/surf/rh.pial']};
% fieldtrip mesh in MNI
% [ftver, ftpath] = ft_version;
% load([ftpath filesep 'template/anatomy/surface_pial_left.mat']);
% % rename the variable that we read from the file, as not to confuse it with the MATLAB mesh plotting function   
% fspial_lh = mesh; clear mesh;

% plot electrodes on fsaverage
fspial_2h = ft_read_headshape(two_hemisphere);
fspial_2h.coordsys = 'fsaverage';
% plot two hemispheres
figure;
ft_plot_mesh(fspial_2h,'facecolor',[0.9 0.9 0.9],'facealpha',0.2);
% transform from mni to fsaverage
eeg.elec.chanpos = mni2fsa(eeg.elec.chanpos);
eeg.elec.coordsys = 'fsaverage';
% plot electrode on fsaverage space
ft_plot_sens(eeg.elec,'style','b');
view([-90 20]);
material dull;
lighting gouraud;
camlight;

%% Prepare layout for interactive plotting
% ft_prepare_layout generate a stuct layout that contains information for
% plotting (ft_multiplotER, ft_multiplotTFR), e.g. layout.mask is a cell-array
% with line segments that determine the area for topographic interpolation
cfg            = [];
cfg.headshape  = fspial_2h;
cfg.projection = 'stereographic';
cfg.channel    = {'all', '-DC*', '-*ref'};
cfg.mask       = 'convex';
cfg.boxchannel = {'all', '-DC*', '-*ref'};
lay = ft_prepare_layout(cfg, eeg);
end