%% set path
subjID = 's03';
filepath='/Volumes/WD_D/gufei/consciousness';
sfix={'','_awake','_sleep'};
%%
for i=2:3
cfg=[];
cfg.dataset=[filepath '/edf/' subjID sfix{i} '.edf'];
eeg=ft_preprocessing(cfg);
% delete useless data
eeg.label(66:71)=[];
eeg.trial{1}(66:71,:)=[];
% resample
cfg=[];
cfg.resamplefs=500;
eeg=ft_resampledata(cfg,eeg);
% save as .mat
save([filepath '/data/' subjID sfix{i} '.mat'],'eeg');
end
%% plot signal
cfg = [];
cfg.channel = 64:67;
cfg.viewmode = 'vertical';
eegplot = ft_databrowser(cfg,eeg);

%%
% marker={'POL DC02';'POL DC03';'POL DC04';};
% channel=[];
% for i=1:length(eeg.label)
%     if ismember(eeg.label{i},marker)
%         channel=[channel i];
%     end
% end
% eeg.marker=eeg.trial{1}(channel,:);

