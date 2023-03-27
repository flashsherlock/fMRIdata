function blind_timing_rating(sub,run)
times = [4 8];
if nargin < 2
    run = 6;
end

datadir = ['/Volumes/WD_F/gufei/blind/behavior/'];
outdatadir = ['/Volumes/WD_F/gufei/blind/' sub '/behavior/'];
if ~exist(outdatadir, 'dir')
    mkdir(outdatadir);
end
% change sub to match filename
sub=[lower(sub) '_run'];
% timing contains the time of rating onset and duration
timing=cell(run,times(1)*times(2));

for i=1:run
    data=dir([datadir sub num2str(i) '*.mat']);
    dataname=data(1).name;
    load([datadir filesep dataname]);
    % find rating time and duration
    valenceon=result(:,10)';
    % duration = column7 - 2
    valencedu=-2+result(:,7)';
    % durations > maxrt or ==0 are maxrt
    valencedu(valencedu == -2) = result(valencedu == -2, 3);
    valencedu(valencedu > result(:, 3)') = result(valencedu > result(:, 3)', 3);
    % combine onset and duration by :
    timing(i,:)=strcat(strsplit(num2str(valenceon)),{':'},strsplit(num2str(valencedu)));
end

% timing for each kind of rating
fid=fopen([outdatadir filesep 'rating' '.txt'],'w');
for j=1:run
    temp=strjoin(timing(j,:));
    fprintf(fid,'%s\r\n',temp);
end
fclose(fid);

end

