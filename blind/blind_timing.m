function blind_timing(sub,run)
times=[4 8];
if nargin<2
    run=6;
end

datadir=['/Volumes/WD_F/gufei/blind/behavior/'];
outdatadir = ['/Volumes/WD_F/gufei/blind/' sub '/behavior/'];
if ~exist(outdatadir,'dir')
    mkdir(outdatadir);
end
timing=zeros(run,times(1),times(2));
% change sub to match filename
sub=[lower(sub) '_run'];

for i=1:run
    data=dir([datadir sub num2str(i) '*.mat']);
    dataname=data(1).name;
    load([datadir filesep dataname]);
    disp([sub num2str(i)]);
    % response number
    resnum=length(result(result(:,6)~=0,7));
    rt=mean(result(result(:,6)~=0,7));
    % rt-2(beep duration) is real rt
    disp([resnum rt-2]);
    % odor numbers
    odors=unique(result(:,1));    
    % for each odor, find timing
    for oi=1:length(odors)
        odor=odors(oi);        
        inhale=result(result(:,1)==odor,9)';
        timing(i,:,oi)=inhale;
    end
    
end

names={'gas','ind','ros','pin','app','min','fru','flo'};
for i=1:times(2)
    % timing for each odor(all runs)
    dlmwrite([outdatadir filesep names{i} '.txt'],timing(:,:,i),'delimiter',' ');
    % timing for each odor(each run)
    for runi=1:run
        dlmwrite([outdatadir filesep names{i} '_run_' num2str(runi) '.txt'],timing(runi,:,i),'delimiter',' ');
    end
end
end
