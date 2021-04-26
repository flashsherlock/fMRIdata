function analyze_timing_valence(sub)
run=6;
times=8;
% sub='s01_run';
datadir=['/Volumes/WD_E/gufei/7T_odor/' sub '/behavior/'];
savedir=['/Volumes/WD_E/gufei/7T_odor/' sub '/behavior_5run/'];
if ~exist(savedir,'dir')
    mkdir(savedir)
end
% cd(datadir);
timing=zeros(run,times*4);
rating=timing;
va=cell(run,4*times);
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
    
    % for each odor, find timing and rating
    % timing
    timing(i,:)=result(:,5)';
    % rating    
    % compute new valence rating
    rating(i,:)=changeva(result)';
    
    % combine onset and duration by *
    va(i,:)=strcat(strsplit(num2str(timing(i,:))),{'*'},strsplit(num2str(rating(i,:))));
end

% remove the 5th run
va(5,:,:)=[];

% timing for odor valence(all runs)
fid=fopen([savedir filesep 'odor_va.txt'],'w');
for i=1:run
    temp=strjoin(va(i,:));
    fprintf(fid,'%s\r\n',temp);
end
fclose(fid);

end

% compute new valence
function va=changeva(result)
% change rating results intensity->0
result(result(:,2)==2,6)=0;
va=result(:,6);
% odor numbers
odors=unique(result(:,1));    
% for each odor, find timing
for oi=1:length(odors)
    odor=odors(oi);        
    valence=result(result(:,1)==odor,6);
    position=find(result(:,1)==odor);
    % interval
    d_before=[999;diff(position)];
    d_after=[diff(position);999];
    % zero positions
    zero=find(valence==0);
    for i=zero'
        if d_before(i)==d_after(i)
            valence(i)=mean(valence(i-1),valence(i+1));
        % close to the next one
        elseif d_before(i)>d_after(i)
            valence(i)=valence(i+1);
        else
            valence(i)=valence(i-1);
        end
    end
    va(position)=valence;
end

end