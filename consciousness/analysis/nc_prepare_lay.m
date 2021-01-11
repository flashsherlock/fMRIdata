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