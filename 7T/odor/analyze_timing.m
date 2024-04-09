function analyze_timing(sub,times)
run=6;
if nargin<2
    times=[8 4];
end
% sub='s01_run';
% datadir=['/Volumes/WD_E/gufei/7T_odor/' sub '/behavior/'];
datadir=['/Volumes/WD_F/gufei/7T_odor/' sub '/behavior/'];
% cd(datadir);
timing=zeros(run,times(1),times(2));
% change sub to match filename
sub=[lower(sub) '_run'];

for i=1:run
    if strcmp(sub,'s01_run')
        % S01 is named from s01_run7
        data=dir([datadir sub num2str(i+6) '*.mat']);
    elseif strcmp(sub,'s01_yyt_run')
        % S01_yyt is named from s01_run1
        data=dir([datadir 's01_run' num2str(i) '*.mat']);
    else
        data=dir([datadir sub num2str(i) '*.mat']);
    end
    dataname=data(1).name;
    load([datadir filesep dataname]);
    disp([sub num2str(i)]);
    % response number
    resnum=length(result(result(:,6)~=0,7));
    rt=mean(result(result(:,6)~=0,7));
    % rt-2.5(green cross and black cross) is real rt
    disp([resnum rt-2.5]);
    % odor numbers
    odors=unique(result(:,1));    
    % for each odor, find timing
    for oi=1:length(odors)
        odor=odors(oi);        
        inhale=result(result(:,1)==odor,5)';
        timing(i,:,oi)=inhale;
    end
    
end

names={'lim','tra','car','cit','ind'};
for i=1:times(2)
    % timing for each odor(all runs)
    dlmwrite([datadir filesep names{i} '.txt'],timing(:,:,i),'delimiter',' ');
    dlmwrite([datadir filesep names{i} '_ext.txt'],timing(:,:,i)-1.5,'delimiter',' ');
    % timing for each odor(each run)
    for runi=1:run
        dlmwrite([datadir filesep names{i} '_run_' num2str(runi) '.txt'],timing(runi,:,i),'delimiter',' ');
        dlmwrite([datadir filesep names{i} '_run_' num2str(runi) '_ext.txt'],timing(runi,:,i)-1.5,'delimiter',' ');
    end
end
end
