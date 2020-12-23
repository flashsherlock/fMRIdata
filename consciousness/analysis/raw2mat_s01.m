%% set path
subjID = 's01';
filepath='/Volumes/WD_D/gufei/consciousness';

for i=1:2
    cfg=[];
    cfg.dataset=[filepath '/edf/' subjID '_' num2str(i) '.edf'];
    %% delete unused channels
    load([filepath '/data/' subjID '_electrodes.mat']);
    use=electrodes(:,1);
    use(delete)=[];
    cfg.channels=use;
    datr=ft_preprocessing(cfg);
    %% resample
    cfg=[];
    cfg.resamplefs=500;
    dat{i}=ft_resampledata(cfg,datr);
end
eeg = ft_appenddata(cfg, dat{:});
%% save
save('s01.mat','eeg');
