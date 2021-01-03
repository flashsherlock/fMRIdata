function timing = findtrs( shift,subnum )
% find TRs when odor evoked activity reaches peak
% shift is the time shift (seconds) after inhalation
run=6;
times=8;
prefix=dir(sprintf('/Volumes/WD_D/gufei/7T_odor/S%02d*',subnum));
sub=sprintf('s%02d_run',subnum);
datadir=[prefix.folder filesep prefix.name filesep 'behavior/'];
timing=zeros(2,4*times,run);

for i=1:run
    data=dir([datadir sub num2str(i) '*.mat']);
    dataname=data(1).name;
    load([datadir dataname]);

    % odor
    odor=result(:,1);
    time=result(:,5);
    timing(1,:,i)=odor;
    timing(2,:,i)=time+(i-1)*390;
    
end

% reshape to only 2 rows
timing=reshape(timing,[2 192]);
% code odors to 1:4
timing(1,:)=timing(1,:)-6;
% compute trs with shift
timing(2,:)=ceil((timing(2,:)+shift)/3);
% sort by odors
timing=sortrows(timing');
end

