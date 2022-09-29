function analyze_timing_intensity_allavg(sub,times)
run=6;
if nargin<2
    times=[8 4];
end
% sub='s01_run';
% datadir=['/Volumes/WD_E/gufei/7T_odor/' sub '/behavior/'];
datadir=['/Volumes/WD_F/gufei/7T_odor/' sub '/behavior/'];
% get mean intensity rating
rating=mrirate(sub,times(1));
intensity=rating.intensity;
% variables for timing and rating
timing=zeros(run,times(1)*times(2));
rating=timing;
int=cell(run,times(1)*times(2));
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
    % compute new intensity rating
    rating(i,:)=changeint(result,intensity)';
    
    % combine onset and duration by *
    int(i,:)=strcat(strsplit(num2str(timing(i,:))),{'*'},strsplit(num2str(rating(i,:))));
end

% timing for odor intensity(all runs)
fid=fopen([datadir filesep 'odor_alliavg.txt'],'w');
for i=1:run
    temp=strjoin(int(i,:));
    fprintf(fid,'%s\r\n',temp);
end
fclose(fid);

end

% compute new intensity
function int=changeint(result,intensity)
int=result(:,6);
% odor numbers
odors=unique(result(:,1));    
% for each odor, find timing
for oi=1:length(odors)
    odor=odors(oi);
    int(result(:,1)==odor)=intensity(oi);
end
end