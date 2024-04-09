function timing = findtrs( shift,sub,rating,run)
% find TRs when odor evoked activity reaches peak
% shift is the time shift (seconds) after inhalation
if nargin<3
    rating=0;
end
if nargin<4
    run=1:6;
end

% datadir=['/Volumes/WD_E/gufei/7T_odor/' sub '/behavior/'];
datadir=['/Volumes/WD_F/gufei/7T_odor/' sub '/behavior/'];
sub=[lower(sub) '_run'];

% the first run (get parameters)
i=1;
if strcmp(sub,'s01_run')
    % S01 is named from s01_run7
    data=dir([datadir sub num2str(run(i)+6) '*.mat']);
elseif strcmp(sub,'s01_yyt_run')
    % S01_yyt is named from s01_run1
    data=dir([datadir 's01_run' num2str(run(i)) '*.mat']);
else
    data=dir([datadir sub num2str(run(i)) '*.mat']);
end
dataname=data(1).name;
load([datadir dataname]);
% odor
odor=result(:,1);
time=result(:,5);

% get odor_num and times
odor_num=length(unique(odor));
times=size(result,1)/odor_num;
% number of run TRs
if times==8
    trs=390;
elseif times==6
    trs=392;
end
timing=zeros(3,odor_num*times,length(run));

timing(1,:,i)=odor;
timing(2,:,i)=time+(i-1)*trs;
% run number
timing(3,:,i)=i;
% ratings
timing(4,:,i)=result(:,2);
timing(5,:,i)=result(:,6);

% start from the 2nd run
for i=2:length(run)
    if strcmp(sub,'s01_run')
        % S01 is named from s01_run7
        data=dir([datadir sub num2str(run(i)+6) '*.mat']);
    elseif strcmp(sub,'s01_yyt_run')
        % S01_yyt is named from s01_run1
        data=dir([datadir 's01_run' num2str(run(i)) '*.mat']);
    else
        data=dir([datadir sub num2str(run(i)) '*.mat']);
    end
    dataname=data(1).name;
    load([datadir dataname]);

    % odor
    odor=result(:,1);
    time=result(:,5);
    timing(1,:,i)=odor;
    timing(2,:,i)=time+(i-1)*trs;
    timing(3,:,i)=i;
    timing(4,:,i)=result(:,2);
    timing(5,:,i)=result(:,6);
    
end

% reshape to only 2 rows
timing=reshape(timing,[5 length(run)*odor_num*times]);
% code odors to 1:4 if above 6
if timing(1,1)>=7
    timing(1,:)=timing(1,:)-6;
end
% compute trs with shift
timing(2,:)=ceil((timing(2,:)+shift)/3);
% sort by odors
timing=sortrows(timing');
% add a column for repeats
if rating ~= 1
    timing=[timing(:,1:3)  kron(ones(size(timing,1)/times,1),(1:times)')];
end
end

