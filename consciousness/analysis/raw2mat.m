function raw2mat(subjID)
%% set path
% subjID = 's03';
filepath='/Volumes/WD_D/gufei/consciousness';
sfix={'','_awake','_sleep'};
%% make dir
switch subjID
    case 's01'
        subname='LinYuqing';        
    case 's02'
        subname='WangMingyuan';
    case 's03'
        subname='HuYifan';
    case 's04'
        subname='WanRuilong';
    case 's05'
        subname='ZhouYuxuan';
    case 's06'
        subname='WuYue';
    case 's07'
        subname='ChenJinhao';
    otherwise
        error('No data for this subject');
end
bipolar_path=[filepath '/data/' subjID '_' subname '_bipolar'];
if ~exist(bipolar_path,'dir')
    mkdir(bipolar_path)
end
raw_path=[filepath '/data/' subjID '_' subname '_raw'];
if ~exist(raw_path,'dir')
    mkdir(raw_path)
end
%% processing
% specific to s01
if strcmp(subjID,'s01')
    % load and append data
    eeg=raw2mat_s01();
    % delete unused channels
    eeg.label(elec.delete)=[];
    eeg.trial{:}(elec.delete,:)=[];
    elec.electrodes(elec.delete,:)=[];
    % change to newlabel
    eeg.label=newlabel;
    % sort electrodes        
    [eeg.label,order]=sort(eeg.label);
    eeg.trial{:}=eeg.trial{:}(order,:);
    elec.electrodes=elec.electrodes(order,:);
    % save electrodes
    eeg.eposition=elec.electrodes;
    % save raw data as .mat
    save([raw_path '/' subjID '.mat'],'eeg');
    eeg=biref(eeg);
    % save bipolar reference
    save([bipolar_path '/' subjID '.mat'],'eeg');
else
    for i=1:3
        cfg=[];
        cfg.dataset=[filepath '/edf/' subjID sfix{i} '.edf'];
        if exist(cfg.dataset,'file')
            % rereference
    %         cfg.reref = 'yes';
    %         cfg.refmethod = 'bipolar';
            eeg=ft_preprocessing(cfg);
            % load electrodes
            % electrodes will be modified, so reload it every loop
            elec=load([filepath '/data/' subjID '_electrodes.mat']);
            % find old and new labels
            % use=elec.electrodes(:,1);
            newlabel=elec.electrodes(:,2);
            newlabel(elec.delete)=[];
            % used electrodes old labels
            % exclude=[{'all'};strcat('-',use(elec.delete))];        
            % cfg.channels=exclude;
            % delete unused channels
            eeg.label(elec.delete)=[];
            eeg.trial{:}(elec.delete,:)=[];
            elec.electrodes(elec.delete,:)=[];
            % change to newlabel
            eeg.label=newlabel;
            eeg = rmfield(eeg,'hdr');
            % sort electrodes        
            [eeg.label,order]=sort(eeg.label);
            eeg.trial{:}=eeg.trial{:}(order,:);
            elec.electrodes=elec.electrodes(order,:);        

            % resample
            cfg=[];
            cfg.resamplefs=500;
            eeg=ft_resampledata(cfg,eeg);
            % save electrodes
            eeg.eposition=elec.electrodes;
            % dc index 
    %         dc=find(contains(elec.electrodes(:,1),'DC')==1);      
    %         cfg.marker=eeg.trial{1}(dc(1:3),:);
            % save raw data as .mat
            save([raw_path '/' subjID sfix{i} '.mat'],'eeg');
            eeg=biref(eeg);
            if strcmp(subjID,'s02')
                eeg=s02_remove(eeg);
            end
            % save bipolar reference
            save([bipolar_path '/' subjID sfix{i} '.mat'],'eeg');
            % ft_write_data([filepath '/data/' subjID sfix{i} '.mat'],eeg,'dataformat','matlab')
        end
    end
end
%% plot signal
% cfg = [];
% cfg.channel = 1:5;
% cfg.viewmode = 'vertical';
% cfg.ylim = 'maxmin'
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