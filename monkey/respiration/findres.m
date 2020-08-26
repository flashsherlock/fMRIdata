function combine=findres(data,seconds,rate,chmin,rangestart,rangestop)%,p)
% find three time points

%   start:the time point that start inhalation
%   start:the time point that finish inhalation and start exhalation
%   stop:the time point that finish exhalation
%   chmin:whether to find local min value as the points
%   rangestart:range for searching min start value
%   rangestop:range for searching min stop value
%   p whether plot the data or not(0)


% default values
if nargin < 6
    % whether to find local min
    if ~exist('chmin','var')
        chmin=1;
    end
    % range for searching min value
    if chmin~=0
        if ~exist('rangestart','var')
        rangestart=50;
        end
        rangestop=rangestart;
    end    
    % seconds to calculate MPD
    if ~exist('seconds','var')
        seconds=3;
    end
    % height that define stop and start
    if ~exist('rate','var')
        rate=0.15;
    end   
end

% deal with unexpected value
if chmin~=0
    rangestart=ceil(rangestart);
    rangestart=max(0,rangestart);
    rangestop=ceil(rangestop);
    rangestop=max(0,rangestop);
end
rate=max(0+realmin,rate);
rate=min(1-realmin,rate);
seconds=max(0+realmin,seconds);

% sampling rate
SR=500;
% MINPEAKHEIGHT
MPD=seconds*SR;
%find peak and transform to a row
[~,localmax_position]=findpeaks(data(:,1),'MINPEAKDISTANCE',MPD);
peak=localmax_position';

% interval=ceil(mean(diff(peak,1))*0.55);
% 1st order diff
% change=diff(data(:,1),1);
% NP=length(peak);
% value=min(data(:,1))+0.01;
%find start
% start=findchange(data(:,1),interval,1,peak,value);
%find stop
% stop=findchange(data(:,1),interval,2,peak,value);

% add first and last position to peak
expeak=[1 peak length(data(:,1))];
% find start and stop points
[start,stop]=findpt(data(:,1),expeak,rate);
% change points to local min in the range
if chmin
    if rangestart
    start=chlocalmin(data(:,1),start,'start',rangestart,expeak);
    end
    if rangestop
    stop=chlocalmin(data(:,1),stop,'stop',rangestop,expeak);
    end
end
% combine three points
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


% find start and stop according to the height of the wave
function [start,stop]=findpt(x,peak,rate)
% mark=1 start
% mark=2 stop
% 1-minvalue 2-minlocation
minvalue=zeros(2,length(peak)-1);
start=zeros(1,length(peak)-1);
stop=start;
% find mean values and locations
for i=1:length(peak)-1
    [minvalue(1,i),minvalue(2,i)]=min(x(peak(i):peak(i+1)));
    minvalue(2,i)=minvalue(2,i)+peak(i)-1;
end
% calculate height
startheight=x(peak(2:end))'-minvalue(1,:);
stopheight=x(peak(1:end-1))'-minvalue(1,:);
% threshold=height*rate
startts=startheight*rate+minvalue(1,:);
stopts=stopheight*rate+minvalue(1,:);
% find start and stop points
for i=1:length(peak)-1
    stop(i)=find(x(peak(i):minvalue(2,i))<=stopts(i),1,'first');
    stop(i)=stop(i)+peak(i)-1;
    start(i)=find(x(minvalue(2,i):peak(i+1))>=startts(i),1,'first');
    start(i)=start(i)+minvalue(2,i)-1;
end
% delete extra point at the begining and the end
start=start(1:end-1);
stop=stop(2:end);
end

function points=chlocalmin(x,p,startorstop,range,peak)
points=zeros(1,length(p));
    switch startorstop
        case 'start'
            % get the range, min and max
            left=max(1,p-range);
            right=p;
            position='last';            
        case 'stop'
            % get the range, min and max
            left=p;
            right=min(length(x),p+range);
            position='first';
    end
    % change peaks positon for stop
    if strcmp(startorstop,'stop')
        % which peaks is the start in
        peak(1)=[];
    end
    % find local min value
    for i=1:length(p)
            % find local min in the range
            mindata=min(x(left(i):right(i),1));
            points(i)=find(x(left(i):right(i),1)==mindata,1,position);
            % calculate position in the whole data
            points(i)=points(i)+left(i)-1;
            % ensure the position is between two peaks
            if points(i)<=peak(i)|| points(i)>=peak(i+1)
                points(i)=p(i);
            end
    end
end
% function points=findchange(x,i,mark,peak,value)
% %find first point reach value in i
% %mark=1 start
% %mark=2 stop
% %peak location of peaks
% NP=length(peak);
% points=zeros(1,NP);
% if mark==1
% %increase until i for each row
% range=bsxfun(@plus,peak,-i:0);
% else
% range=bsxfun(@plus,peak,0:i);
% end
% %ensure in range
% range(range<1)=1;
% range(range>length(x))=length(x);
% %nearest point around peak that reach value
% for row=1:NP 
%     %nearest point around peak that reach value
%     position=min(abs(range(row,(x(range(row,:))<=value))-peak(row)));
%     if isempty(position)
%         % if above value then use the min
%         [~,points(row)]=min(x(range(row,:)));
%         points(row)=range(row,points(row));
%     else
%         if mark==1
%             points(row)=peak(row)-position;   
%         else
%             points(row)=peak(row)+position;   
%         end
%     end
% end
% end

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