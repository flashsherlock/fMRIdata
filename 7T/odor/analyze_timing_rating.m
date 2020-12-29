run=6;
times=8;
sub='s01_run';
datadir='/Volumes/WD_D/gufei/7T_odor/S01_yyt/behavior/';
cd(datadir);
% timing contains the time of rating onset and duration
timing=cell(run,4*times/2,2);

for i=1:run
    data=dir([sub num2str(i) '*.mat']);
    dataname=data(1).name;
    load(dataname);
    disp([sub num2str(i)]);
    % response number
    resnum=length(result(result(:,6)~=0,7));
    rt=mean(result(result(:,6)~=0,7));
    % rt-2.5(green cross and black cross) is real rt
    disp([resnum rt-2.5]);
    % find rating time and duration
    valenceon=2.5+result(result(:,2)==1,5)';
    intensityon=2.5+result(result(:,2)==2,5)';
    % duration = column7 - 2.5
    valencedu=-2.5+result(result(:,2)==1,7)';
    % durations > 4.5 or ==0 are 4.5
    valencedu(valencedu==-2.5)=4.5;
    valencedu(valencedu>4.5)=4.5;
    % intensity duration
    intensitydu=-2.5+result(result(:,2)==2,7)';
    intensitydu(valencedu==-2.5)=4.5;
    intensitydu(valencedu>4.5)=4.5;
    % combine onset and duration by :
    timing(i,:,1)=strcat(strsplit(num2str(valenceon)),{':'},strsplit(num2str(valencedu)));
    timing(i,:,2)=strcat(strsplit(num2str(intensityon)),{':'},strsplit(num2str(intensitydu)));
end

names={'valence','intensity'};
for i=1:2
    % timing for each kind of rating
    fid=fopen([names{i} '.txt'],'w');
    for j=1:run
        temp=strjoin(timing(j,:,i));
        fprintf(fid,'%s\r\n',temp);
    end
    fclose(fid);
end

