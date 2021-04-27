function timing = findtrs( shift,sub,run)
% find TRs when odor evoked activity reaches peak
% shift is the time shift (seconds) after inhalation
if nargin<3
    run=1:6;
end
times=8;
datadir=['/Volumes/WD_E/gufei/7T_odor/' sub '/behavior/'];
sub=[lower(sub) '_run'];
timing=zeros(2,4*times,length(run));

for i=1:length(run)
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
    timing(2,:,i)=time+(i-1)*390;
    
end

% reshape to only 2 rows
timing=reshape(timing,[2 length(run)*32]);
% code odors to 1:4
timing(1,:)=timing(1,:)-6;
% compute trs with shift
timing(2,:)=ceil((timing(2,:)+shift)/3);
% sort by odors
timing=sortrows(timing');
end

