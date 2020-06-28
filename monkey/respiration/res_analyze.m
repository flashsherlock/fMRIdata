clear;
clc;
path='C:\Users\GuFei\zhuom\monkey\respiration\20191231';
% path='C:\Users\GuFei\zhuom\monkey\analysis\testfindres';
file=dir([path '\' '*.acq']);
num=length(file);
% for i=1:num

% 6-bad example
% 7-good example
dname=file(6).name;
alldata=load_acq([path '\' dname]);
[data,error]=marker_trans(alldata.data);
% res=findres(data,1);
res=findres(data);
data(:,3)=res;

%plot
figure;
set(gcf,'position',[0 150 3500 300])
plot(data(:,1));
title(dname);
hold on
% plot(start,'Color','r');
%start
timepoint=nan(size(data,1),1);
start=find(res==1);
timepoint(start)=data(start,1);
plot(timepoint,'*','Color','g','MarkerSize',10);
%stop
timepoint=nan(size(data,1),1);
stop=find(res==3);
timepoint(stop)=data(stop,1);
plot(timepoint,'*','Color','r','MarkerSize',10);
%peak
timepoint=nan(size(data,1),1);
peak=find(res==2);
timepoint(peak)=data(peak,1);
plot(timepoint,'*','Color','b','MarkerSize',10);

% end
