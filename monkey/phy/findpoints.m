function points=findpoints(data)
% generate a matrix of respiration points
allpeak=find(data(:,3)==2);
% 根据peak的数目选择
points=zeros(length(allpeak),4);
% 第四列表示这一组数是否有效
points(:,4)=1;
points(:,2)=allpeak;
% 记录当前的三个点,1-start,2-peak,3-stop
% 没有的点就是0
len=length(allpeak);
for i=1:len
    % 考虑第一个和最后一个是不同的
    % deal with the beginning and the end
    if i==1
        left=1;
        right=allpeak(2);
    elseif i==len
        left=allpeak(len-1);
        right=length(data(:,1));
    else
        left=allpeak(i-1);
        right=allpeak(i+1);
    end
    % find start between two peaks
    current=allpeak(i);
    start=find(data(left:current,3)==1)+left-1;
    % 0 means no start point
    if isempty(start)
        start=0;
    end
    % peak point
    peak=current;
    % find stop between two peaks
    stop=find(data(current:right,3)==3)+current-1;
    if isempty(stop)
    % 0 means no stop point
        stop=0;
    end
    points(i,1:3)=[start peak stop];
end