%% set path
subjID = 's04';
filepath='/Volumes/WD_D/gufei/consciousness';
sfix={'','_awake','_sleep'};
% use bipolar block data
indata=dir([filepath '/data/' subjID '*' '_block']);
indata_path=indata(1).folder;
%% load data
for i=1:3
    % file name
    dataset=[indata_path '/' subjID sfix{i} '.mat'];
    % load and plot if data exist
    if exist(dataset,'file')
        load(dataset);
        % prepare layout for ploting
        lay = nc_prepare_lay(eeg);
        % plot ERP for each odor
        for iodor=1:4
            % define trials to be ploted
            cfg = [];
            cfg.trials = find(data_clean.trialinfo==iodor);
            % timelock analysis
            odor = ft_timelockanalysis(cfg, eeg);
            % plot ERP
            cfg = [];
            cfg.layout = lay;
            cfg.interactive = 'yes';
            cfg.showoutline = 'yes';
            ft_multiplotER(cfg, odor);
        end
    end
end
%% old codes for ploting markers
% load('subject1_2.mat')
% m=eeg.trial{1,1}(39:42,:);
% range=5000:55000;
% figure
% subplot(4,1,1)
% plot(m(1,range))
% set(gca, 'yLim', [0 4e6]);
% title(eeg.label(39))
% 
% subplot(4,1,2)
% plot(m(2,range))
% set(gca, 'yLim', [0 4e6]);
% title(eeg.label(40))
% 
% subplot(4,1,3)
% plot(m(3,range))
% set(gca, 'yLim', [0 4e6]);
% title(eeg.label(41))
% 
% subplot(4,1,4)
% plot(m(4,range))
% title(eeg.label(42))