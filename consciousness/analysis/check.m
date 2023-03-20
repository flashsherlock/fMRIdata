cfg=[];
cfg.dataset=['s14.edf'];
if exist(cfg.dataset,'file')
% rereference
%         cfg.reref = 'yes';
%         cfg.refmethod = 'bipolar';
    eeg=ft_preprocessing(cfg);
end
% plot signal
cfg = [];
cfg.channel = 1:5;
cfg.viewmode = 'vertical';
cfg.ylim = 'maxmin';
eegplot = ft_databrowser(cfg,eeg);