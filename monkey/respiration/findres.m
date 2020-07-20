function combine=findres(data)%,p)
% find three time points
%   start:the time point that start inhalation
%   start:the time point that finish inhalation and start exhalation
%   stop:the time point that finish exhalation
%   p whether plot the data or not(0)
SR=500;%sampling rate
MPD=SR*3;

[~,localmax_position]=findpeaks(data(:,1),'MINPEAKDISTANCE',MPD);%,'MINPEAKHEIGHT',3
%find peak
peak=localmax_position;
interval=ceil(mean(diff(peak,1))*0.55);
% 1st order diff
% change=diff(data(:,1),1);
% NP=length(peak);
value=min(data(:,1))+0.01;
%find start
start=findchange(data(:,1),interval,1,peak,value);
%find stop
stop=findchange(data(:,1),interval,2,peak,value);

combine=zeros(length(data(:,1)),1);
combine(start)=1;
combine(peak)=2;
combine(stop)=3;
%fminbnd findpeaks
%plot
% if p~=0
%     figure;
%     set(gcf,'position',[0 150 3500 300])
%     plot(data(:,1));
%     hold on
%     % plot(start,'Color','r');
%     %stop
%     timepoint=nan(size(data,1),1);
%     timepoint(stop)=data(stop,1);
%     plot(timepoint,'*','Color','r','MarkerSize',10);
%     %start
%     timepoint=nan(size(data,1),1);
%     timepoint(start)=data(start,1);
%     plot(timepoint,'*','Color','g','MarkerSize',10);
%     %peak
%     timepoint=nan(size(data,1),1);
%     timepoint(peak)=data(peak,1);
%     plot(timepoint,'*','Color','b','MarkerSize',10);
% end
end

function points=findchange(x,i,mark,peak,value)
%find first point reach value in i
%mark=1 start
%mark=2 stop
%peak location of peaks
NP=length(peak);
points=zeros(1,NP);
if mark==1
%increase until i for each row
range=bsxfun(@plus,peak,-i:0);
else
range=bsxfun(@plus,peak,0:i);
end
%ensure in range
range(range<1)=1;
range(range>length(x))=length(x);
%nearest point around peak that reach value
for row=1:NP 
    %nearest point around peak that reach value
    position=min(abs(range(row,(x(range(row,:))<=value))-peak(row)));
    if isempty(position)
        % if above value then use the min
        [~,points(row)]=min(x(range(row,:)));
        points(row)=range(row,points(row));
    else
        if mark==1
            points(row)=peak(row)-position;   
        else
            points(row)=peak(row)+position;   
        end
    end
end
end

% function points=findchange(x,i,mark,NP,MPD)
% find first point reach value in i
% %mark=1 start
% %mark=2 stop
% %NP number of peaks
% points=zeros(1,NP);
% if mark==1
% [~,localmax_position]=findpeaks(x,'NPEAKS',NP,'MINPEAKDISTANCE',MPD);
% increase until i for each row
% range=bsxfun(@plus,localmax_position,-i:0);
% else
% [~,localmin_position]=findpeaks(-x,'NPEAKS',NP,'MINPEAKDISTANCE',MPD);
% range=bsxfun(@plus,localmin_position,0:i);
% end
% range(range<1)=1;
% range(range>length(x))=length(x);
% for row=1:NP 
%     
%     points(row)=min(range(row,(x(range(1,:))==0)));
% end
% end