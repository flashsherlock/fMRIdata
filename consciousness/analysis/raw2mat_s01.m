%% set path
subjID = 's01';
filepath='/Volumes/WD_D/gufei/consciousness';
cfg=[];
cfg.dataset=[filepath '/edf/' subjID '_2.edf'];
eeg=ft_preprocessing(cfg);
%% delete unused channels
eeg.label(58:end)=[];
eeg.trial{1}(58:end,:)=[];
%% resample
cfg=[];
cfg.resamplefs=500;
eeg=ft_resampledata(cfg,eeg);
%% save
save('s01.mat','eeg');
%% plot
cfg = [];
cfg.channel = 54:57;
cfg.viewmode = 'vertical';
eegplot = ft_databrowser(cfg,eeg);

