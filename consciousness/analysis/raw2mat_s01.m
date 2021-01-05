%% set path
function eeg=raw2mat_s01()
subjID = 's01';
filepath='/Volumes/WD_D/gufei/consciousness';

for i=1:2
    cfg=[];
    cfg.dataset=[filepath '/edf/' subjID '_' num2str(i) '.edf'];
    %% load data
    % load([filepath '/data/' subjID '_electrodes.mat']);
    datr=ft_preprocessing(cfg);
    %% resample
    cfg=[];
    cfg.resamplefs=500;
    dat{i}=ft_resampledata(cfg,datr);
end
% eeg = ft_appenddata(cfg, dat{:});
eeg.fsample=dat{1}.fsample;
eeg.cfg=dat{1}.cfg;
eeg.label=dat{1}.label;
eeg.time{1}=[dat{1}.time{1} dat{2}.time{1}+1/eeg.fsample+max(dat{1}.time{1})];
eeg.trial{1}=[dat{1}.trial{1} dat{2}.trial{1}];
%% save
% save('s01.mat','eeg');
end