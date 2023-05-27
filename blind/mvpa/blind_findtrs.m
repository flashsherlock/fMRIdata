function timing = blind_findtrs( shift,sub,rating,run)
% find TRs when odor evoked activity reaches peak
% shift is the time shift (seconds) after inhalation
if nargin<3
    rating=0;
end
if nargin<4
    run=1:6;
end

datadir=['/Volumes/WD_F/gufei/blind/behavior/'];
sub=[lower(sub) '_run'];

% the first run (get parameters)
i=1;
data=dir([datadir sub num2str(run(i)) '*.mat']);
dataname=data(1).name;
load([datadir dataname]);
% odor
odor=result(:,1);
time=result(:,9);

% get odor_num and times
odor_num=length(unique(odor));
times=size(result,1)/odor_num;
% number of run TRs
trs=394;
timing=zeros(3,odor_num*times,length(run));

timing(1,:,i)=odor;
timing(2,:,i)=time+(i-1)*trs;
% run number
timing(3,:,i)=i;
% ratings
timing(4,:,i)=result(:,6);

% start from the 2nd run
for i=2:length(run)
    data=dir([datadir sub num2str(run(i)) '*.mat']);
    dataname=data(1).name;
    load([datadir dataname]);

    % odor
    odor=result(:,1);
    time=result(:,5);
    timing(1,:,i)=odor;
    timing(2,:,i)=time+(i-1)*trs;
    timing(3,:,i)=i;
    timing(4,:,i)=result(:,6);
end

% reshape to only 2 rows
timing=reshape(timing,[4 length(run)*odor_num*times]);
% compute trs with shift
timing(2,:)=ceil((timing(2,:)+shift)/2);
% sort by odors
timing=sortrows(timing');
% add a column for repeats
if rating ~= 1
    timing=[timing(:,1:3)  kron(ones(size(timing,1)/times,1),(1:times)')];
end
end

