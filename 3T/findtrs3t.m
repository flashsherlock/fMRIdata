function timing = findtrs3t( shift,sub,run )
% find TRs when odor evoked activity reaches peak
% shift is the time shift (seconds) after onset
if nargin<3
    run=1:5;
end

datadir=['/Volumes/WD_F/gufei/3t_cw/behavior/'];
sub=[lower(sub) '_'];

% get odor_num and times
odor_num=8;
times=3;
% number of run TRs
trs=392;
timing=zeros(3,odor_num*times,length(run));

% start from the 1st run
for i=1:length(run)
    data=dir([datadir sub num2str(run(i)) '*.mat']);
    dataname=data(1).name;
    load([datadir dataname]);

    % convert condtion coding
    results=results(1:5:end,:);
    condition=results(:,1:3);
    condition=(condition-1)*[4;2;1]+1;
    % get timings
    time=results(:,8);
    timing(1,:,i)=condition;
    timing(2,:,i)=time+(i-1)*trs;
    % run number
    timing(3,:,i)=i;
end

% reshape to only 2 rows
timing=reshape(timing,[3 length(run)*odor_num*times]);
% compute trs with shift
timing(2,:)=ceil((timing(2,:)+shift)/2);
% sort by odors
timing=sortrows(timing');
end

