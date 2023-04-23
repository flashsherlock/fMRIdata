function out=resp_convert(resp,test)
% trials
trials = zeros(4,15);
trials(1,:) = [1 4 2 5 3 4 1 5 2 4 3 5 2 1 3];
trials(2,:) = [5 1 4 3 5 3 1 4 2 1 2 5 3 4 2];
trials(3,:) = [3 4 1 2 5 3 4 2 1 5 1 2 4 3 5];
trials(4,:) = [4 3 1 5 2 1 5 3 4 2 5 3 1 2 4];
% parameters
srate = 1000;
channels = size(resp.dataend,1);
temper = 1;
aflow = 2;
marker = 3;
% convert data to matrix (channel by point)
data = [];
for i = 1:channels
    datarange = [];
    for j = 1:size(resp.datastart,2)
        datarange = [datarange,resp.datastart(i,j):resp.dataend(i,j)];
    end
    data(i,:) = resp.data(datarange);
end
% convert markers
data(marker,data(marker,:)<=3.3)=0;
data(marker,data(marker,:)>3.3)=1;
mar = [0 diff(data(marker,:))];
start = find(mar == 1);
stop = find(mar == -1);
if length(start) ~= length(stop)
    error('Numbers of start and stop markers are not equal!')
else
    mar = [start; stop];
    % remove fake markers by time interval
    mar(:,mar(2,:)-mar(1,:)<400)=[];
    % 0.5s hint is 1s before odor onset
    hint = srate+mar(:,mar(2,:)-mar(1,:)<srate);
    odor1 = mar(:,mar(2,:)-mar(1,:)>6*srate);
end
% check marker
for i = 1:size(odor1,2)
    if trials(test,abs(hint(1,:)-odor1(1,i))<100)~=1
        error('Markers may not consistent with hints!')
    end
end
mar = [trials(test,1:size(hint,2));hint(1,:);hint(1,:)+7*srate]';
% if interupted, remove the last one
if hint(1,end)+7*srate>size(data,2)
    mar = mar(1:end-1,:);
end
% 10Hz lowpass filter
data(aflow,:)=ft_preproc_lowpassfilter(data(aflow,:),srate,10);
% convert temperature
Diffdata = data(1:2,:);
% time window to calculate slope;
window  = 20;
for  i = 1:size(data,2)
    if i>window && i<=(size(data,2)-window)
        Diffdata(temper,i) = (data(temper,i+window) - data(temper,i-window))/window;
    else
        Diffdata(temper,i) = 0;
    end
end
% increase-exhale
Diffdata(temper,:) = -Diffdata(temper,:);
% find resp
dataType = 'humanAirflow';
for i = 1:size(Diffdata,1)
        bmObj = breathmetrics(Diffdata(i,:), srate, dataType);
        verbose=1; 
        baselineCorrectionMethod = 'sliding'; 
        zScore = 1;% if zScore is set to 1, the amplitude in the recording will be normalized. 
        bmObj.correctRespirationToBaseline(baselineCorrectionMethod, zScore, verbose);
        bmObj.estimateAllFeatures;
        out.bmObj{i}  = bmObj;
end
% output
out.marker = mar;
end