function timing_3t( sub )
times=[3 8];
if nargin<2
    run=5;
end

datadir=['/Volumes/WD_D/allsub/behavior/'];
outdatadir = ['/Volumes/WD_F/gufei/3T_cw/' sub '/behavior/'];
if ~exist(outdatadir,'dir')
    mkdir(outdatadir);
end
timing=zeros(run,times(1),times(2));
% change sub to match filename
sub=[lower(sub) '_'];

for i=1:run
    data=dir([datadir sub num2str(i) '*.mat']);
    dataname=data(1).name;
    load([datadir filesep dataname]);
    % convert condtion coding
    results=results(1:5:end,:);
    condition=results(:,1:3);
    condition=(condition-1)*[4;2;1]+1;
    % odor numbers   
    odors=unique(condition);    
    % for each odor, find timing
    for oi=1:length(odors)
        odor=odors(oi);        
        inhale=results(condition==odor,8)';
        timing(i,:,oi)=inhale;
    end
    
end

names={'FearPleaVis';'FearPleaInv';'FearUnpleaVis';'FearUnpleaInv';...
    'HappPleaVis';'HappPleaInv';'HappUnpleaVis';'HappUnpleaInv'};
for i=1:times(2)
    % timing for each odor(all runs)
    dlmwrite([outdatadir filesep names{i} '.txt'],timing(:,:,i),'delimiter',' ');
    % timing for each odor(each run)
    for runi=1:run
        dlmwrite([outdatadir filesep names{i} '_run_' num2str(runi) '.txt'],timing(runi,:,i),'delimiter',' ');
    end
end
% fixation
fix = sort(reshape(timing,run,times(1)*times(2))-1,2);
dlmwrite([outdatadir filesep 'fix' '.txt'],fix,'delimiter',' ');
end

