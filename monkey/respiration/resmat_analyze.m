clear;
clc;
path='/Volumes/WD_D/gufei/monkey_data/monkey_odor';
file=dir([path '/' '*.mat']);
num=length(file);
for i=1:num
    load([path '/' file(i).name]);
    value=size(data);
    if value(2)~=3
        disp(file(i).name);
        disp(parameters);
    end
end
% load('example_bad.mat');
% % res=findres(data,1);
% res=findres(data,2,0.15,1,50);
% data(:,3)=res;
% 
% %plot
% figure;
% set(gcf,'position',[0 150 3500 300])
% plot(data(:,1));
% 
% hold on
% % plot(start,'Color','r');
% %start
% timepoint=nan(size(data,1),1);
% start=find(res==1);
% timepoint(start)=data(start,1);
% plot(timepoint,'>','Color','g','MarkerSize',10);
% %stop
% timepoint=nan(size(data,1),1);
% stop=find(res==3);
% timepoint(stop)=data(stop,1);
% plot(timepoint,'<','Color','r','MarkerSize',10);
% %peak
% timepoint=nan(size(data,1),1);
% peak=find(res==2);
% timepoint(peak)=data(peak,1);
% plot(timepoint,'^','Color','b','MarkerSize',10);
% 
% % end