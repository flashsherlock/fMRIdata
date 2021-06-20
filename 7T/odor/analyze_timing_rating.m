function analyze_timing_rating(sub,times)
run=6;
if nargin<2
    times=[8 4];
    maxrt=4.5;
end
if times(1)==6
    maxrt=7;
end
% sub='s01_run';
datadir=['/Volumes/WD_E/gufei/7T_odor/' sub '/behavior/'];
% cd(datadir);
% change sub to match filename
sub=[lower(sub) '_run'];
% timing contains the time of rating onset and duration
timing=cell(run,times(1)*times(2)/2,2);

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
    
    % check if affected by the wrong maxrt (S06-S08 should be fixed)
    % if ismember(1,result(:,7)>7) || ismember(1,result(:,7)==0)
    %     disp('Caution');
    % end
    
    % find rating time and duration
    valenceon=2.5+result(result(:,2)==1,5)';
    intensityon=2.5+result(result(:,2)==2,5)';
    % duration = column7 - 2.5
    valencedu=-2.5+result(result(:,2)==1,7)';
    % durations > maxrt or ==0 are maxrt
    valencedu(valencedu==-2.5)=maxrt;
    valencedu(valencedu>maxrt)=maxrt;
    % intensity duration
    intensitydu=-2.5+result(result(:,2)==2,7)';
    intensitydu(intensitydu==-2.5)=maxrt;
    intensitydu(intensitydu>maxrt)=maxrt;
    % combine onset and duration by :
    timing(i,:,1)=strcat(strsplit(num2str(valenceon)),{':'},strsplit(num2str(valencedu)));
    timing(i,:,2)=strcat(strsplit(num2str(intensityon)),{':'},strsplit(num2str(intensitydu)));
end

names={'valence','intensity'};
for i=1:2
    % timing for each kind of rating
    fid=fopen([datadir filesep names{i} '.txt'],'w');
    for j=1:run
        temp=strjoin(timing(j,:,i));
        fprintf(fid,'%s\r\n',temp);
    end
    fclose(fid);
end
end

