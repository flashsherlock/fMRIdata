%% Preprocessing of the neural recordings
cfg                     = [];
cfg.dataset             = <path to recording file>;
cfg.trialdef.eventtype  = 'TRIGGER';
cfg.trialdef.eventvalue = 4;
cfg.trialdef.prestim    = 0.4;
cfg.trialdef.poststim   = 0.9;
cfg = ft_definetrial(cfg);
%% Import the data segments of interest into the MATLAB workspace and filter the data for high-frequency and power line noise (see the documentation of ft_preprocessing for filtering options).
cfg.demean         = 'yes';
cfg.baselinewindow = 'all';
cfg.lpfilter       = 'yes';
cfg.lpfreq         = 200;
cfg.padding        = 2;
cfg.padtype        = 'data';
cfg.bsfilter       = 'yes';
cfg.bsfiltord      = 3;
cfg.bsfreq         = [59 61; 119 121; 179 181];
data = ft_preprocessing(cfg);
%% Add the elec structure originating from the anatomical workflow
data.elec = elec_acpc_fr;
save([subjID '_data.mat'], 'data');
%% use preprocessed data
subjID = 'SubjectUCI29';
load([subjID '_data.mat'], 'data');
%% Inspect the neural recordings using ft_databrowser and identify channels or segments of non-interest
cfg          = [];
cfg.viewmode = 'vertical';
cfg = ft_databrowser(cfg, data);
%% Remove any bad segments marked in the above step.
data = ft_rejectartifact(cfg, data);
%% re-montage the cortical grids to a common average reference
% Bad channels identified in Step 39 can be excluded from this step by 
% adding those channels to cfg.channel with a minus prefix. 
% That is, cfg.channel = {‘LPG’, ‘LTG’, ‘-LPG1’} if one were to exclude 
% the LPG1 channel from the list of LPG and LTG channels.
cfg             = [];
cfg.channel     = {'LPG*', 'LTG*'};
cfg.reref       = 'yes';
cfg.refchannel  = 'all';
cfg.refmethod   = 'avg';
reref_grids = ft_preprocessing(cfg, data);
%% Apply a bipolar montage to the depth electrodes. 
% it can also be done using cfg.refmethod = ‘bipolar’, which automatically 
% takes bipolar derivations of consecutive channels. New channel labels in 
% the output indicate the bipolar origin of the data, 
% e.g., “RAM1-RAM2”, “RAM2-RAM3”, and so on. By specifying 
% cfg.updatesens = ‘yes’, the same bipolar montage is automatically 
% applied to the channel positions, with the resulting chanpos field 
% containing the mean locations of all electrode pairs that comprise a bipolar channel.
depths = {'RAM*', 'RHH*', 'RTH*', 'ROC*', 'LAM*', 'LHH*', 'LTH*'};
for d = 1:numel(depths)
cfg            = [];
cfg.channel    = ft_channelselection(depths{d}, data.label);
cfg.reref      = 'yes';
cfg.refchannel = 'all';
cfg.refmethod  = 'bipolar';
cfg.updatesens = 'yes';
reref_depths{d} = ft_preprocessing(cfg, data);
end
%% Combine the data from both electrode types into one data structure for the ease of further processing.
cfg            = [];
cfg.appendsens = 'yes';
reref = ft_appenddata(cfg, reref_grids, reref_depths{:});
save([subjID '_reref.mat'], 'reref');
%% Time-frequency analysis (optional)
cfg            = [];
cfg.method     = 'mtmconvol';
cfg.toi        = -.3:0.01:.8;
cfg.foi        = 5:5:200;
cfg.t_ftimwin  = ones(length(cfg.foi),1).*0.2;
cfg.taper      = 'hanning';
cfg.output     = 'pow';
cfg.keeptrials = 'no';
freq = ft_freqanalysis(cfg, reref);
save([subjID '_freq.mat'], 'freq');
%% Interactive plotting
cfg            = [];
pial_lh = ft_read_headshape('freesurfer/surf/lh.pial');
pial_lh.coordsys = 'acpc';
cfg.headshape  = pial_lh;
cfg.projection = 'orthographic';
cfg.channel    = {'LPG*', 'LTG*'};
cfg.viewpoint  = 'left';
cfg.mask       = 'convex';
cfg.boxchannel = {'LTG30', 'LTG31'};
lay = ft_prepare_layout(cfg, freq);
%% Extract baseline
cfg              = [];
cfg.baseline     = [-.3 -.1];
cfg.baselinetype = 'relchange';
freq_blc = ft_freqbaseline(cfg, freq);
%% visualize
cfg             = [];
cfg.layout      = lay;
cfg.showoutline = 'yes';
ft_multiplotTFR(cfg, freq_blc);
%% ECoG data representation
cfg             = [];
cfg.frequency   = [70 150];
cfg.avgoverfreq = 'yes';
cfg.latency     = [0 0.8];
cfg.avgovertime = 'yes';
freq_sel = ft_selectdata(cfg, freq_blc);
%% Visualize the spatial distribution of high-frequency-band activity
cfg              = [];
cfg.funparameter = 'powspctrm';
cfg.funcolorlim  = [-.5 .5];
cfg.method       = 'surface';
cfg.interpmethod = 'sphere_weighteddistance';
cfg.sphereradius = 8;
cfg.camlight     = 'no';
ft_sourceplot(cfg, freq_sel, pial_lh);
view([-90 20]);
material dull;
lighting gouraud;
camlight;
%% Add the electrodes to the figure
ft_plot_sens(elec_acpc_fr);
%% SEEG data representation
atlas = ft_read_atlas('freesurfer/mri/aparc+aseg.mgz');
atlas.coordsys = 'acpc';
cfg            = [];
cfg.inputcoord = 'acpc';
cfg.atlas      = atlas;
cfg.roi        = {'Right-Hippocampus', 'Right-Amygdala'};
mask_rha = ft_volumelookup(cfg, atlas);
%% Create a triangulated and smoothed surface mesh
seg = keepfields(atlas, {'dim', 'unit','coordsys','transform'});
seg.brain = mask_rha;
cfg             = [];
cfg.method      = 'iso2mesh';
cfg.radbound    = 2;
cfg.maxsurf     = 0;
cfg.tissue      = 'brain';
cfg.numvertices = 1000;
cfg.smooth      = 3;
cfg.spmversion  = 'spm12';
mesh_rha = ft_prepare_mesh(cfg, seg);
%% Identify the subcortical electrodes of interest.
cfg         = [];
cfg.channel = {'RAM*', 'RTH*', 'RHH*'};
freq_sel2 = ft_selectdata(cfg, freq_sel);
%% Interpolate the high-frequency-band activity in the bipolar channels on a spherical cloud around the channel positions
cfg              = [];
cfg.funparameter = 'powspctrm';
cfg.funcolorlim  = [-.5 .5];
cfg.method       = 'cloud';
cfg.slice        = '3d';
cfg.nslices      = 2;
cfg.facealpha    = .25;
ft_sourceplot(cfg, freq_sel2, mesh_rha);
view([120 40]);
lighting gouraud;
camlight;
%% generate two-dimensional slices through the three-dimensional representations
cfg.slice        = '2d';
ft_sourceplot(cfg, freq_sel2, mesh_rha);
