function [rate_avg,rate_run]=saverate(sub,times)
if nargin<2
    times=[8 4];
end

if times(2)==4
% rate_avg stores intensity, valence, and similarity ratings
% bottle: 4 valence | 4 intensity | 6 similarity - mri
rate_avg=zeros(length(sub),(4+4+6)*2);
% rate_run stores ratings of each run
% 4 valence | 4 intensity
rate_run=zeros(6,8,length(sub));
% note that nanmean(rate_run) does not equal to rate_avg because of nans
for sub_i=sub
    % s is subject string
    s=sprintf('S%02d',sub_i);
    b = bottlerate(sub_i);
%     data(sub_i,1:4)=bottle.valence;
%     data(sub_i,5:8)=bottle.intensity;
%     data(sub_i,9:14)=bottle.similarity;
    m = mrirate(sub_i);
    rate_avg(sub_i,:)=[b.valence b.intensity b.similarity m.valence m.intensity m.similarity];
    % get ratings for each run
    data=analyze_rating(s,times);
    rate_run(:,:,sub_i)=data.run;
end

% 5 odors
else
% only mri: 5 valence | 5 intensity | 10 similarity
rate_avg=zeros(length(sub),5+5+10);
% rate_run stores ratings of each run
% 5 valence | 5 intensity
rate_run=zeros(6,2*times(2),length(sub));
% note that nanmean(rate_run) does not equal to rate_avg because of nans
for sub_i=sub
    % s is subject string
    s=sprintf('S%02d',sub_i);
    m = mrirate(sub_i,times(1));
    rate_avg(sub_i,:)=[m.valence m.intensity m.similarity];
    % get ratings for each run
    data=analyze_rating(s,times);
    rate_run(:,:,sub_i)=data.run;
end
end

end