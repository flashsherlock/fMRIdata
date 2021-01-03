function eeg=raw2mat(ID)
%% set path
% subjID = 's03';
subjID = ID;
filepath='/Volumes/WD_D/gufei/consciousness';
sfix={'','_awake','_sleep'};
%%
for i=3
    cfg=[];
    cfg.dataset=[filepath '/edf/' subjID sfix{i} '.edf'];
    if exist(cfg.dataset,'file')
        % delete useless data
        elec=load([filepath '/data/' subjID '_electrodes.mat']);
        use=elec.electrodes(:,1);
        use(elec.delete)=[];
        cfg.channels=use;
        % rereference
%         cfg.reref = 'yes';
%         cfg.refmethod = 'bipolar';
        eeg=ft_preprocessing(cfg);
        % dc index 
        dc=find(contains(elec.electrodes(:,1),'DC')==1);      
        
        % resample
        cfg=[];
        cfg.resamplefs=500;
        eeg=ft_resampledata(cfg,eeg);
        
        cfg.marker=eeg.trial{1}(dc(1:3),:);
        % save as .mat
        % save([filepath '/data/' subjID sfix{i} '.mat'],'eeg');
        % ft_write_data([filepath '/data/' subjID sfix{i} '.mat'],eeg,'dataformat','matlab')
    end
end
%% plot signal
% cfg = [];
% cfg.channel = 64:67;
% cfg.viewmode = 'vertical';
% eegplot = ft_databrowser(cfg,eeg);
%%
% marker={'POL DC02';'POL DC03';'POL DC04';};
% channel=[];
% for i=1:length(eeg.label)
%     if ismember(eeg.label{i},marker)
%         channel=[channel i];
%     end
% end
% eeg.marker=eeg.trial{1}(channel,:);
end