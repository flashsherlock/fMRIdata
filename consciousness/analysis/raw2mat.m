%%
cfg=[];
cfg.dataset=['subject1_2.edf'];
eeg=ft_preprocessing(cfg);
%%
eeg.label(58:end)=[];
eeg.trial{1}(58:end,:)=[];
%%
cfg=[];
cfg.resamplefs=500;
eeg=ft_resampledata(cfg,eeg);
%%
save('subject1_2.mat','eeg');
%%
marker={'POL DC02';'POL DC03';'POL DC04';};
channel=[];
for i=1:length(eeg.label)
    if ismember(eeg.label{i},marker)
        channel=[channel i];
    end
end
eeg.marker=eeg.trial{1}(channel,:);

