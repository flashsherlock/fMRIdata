clear;
clc;
path='/Users/mac/Documents/resdata/814-20';
% path='C:\Users\GuFei\zhuom\monkey\respiration\20191231';
% path='C:\Users\GuFei\zhuom\monkey\analysis\testfindres';
% cd(path);
file=dir([path '/' '*.acq']);
num=length(file);
% num=1;
for i=1:num
    filename=file(i).name;
    alldata=load_acq([path '/' filename]);
    % translate event markers
    [data,error]=marker_trans(alldata.data);
    % find respiration points automatically
    res=findres(data);
    data(:,3)=res;
    % display marker status, 0 means all right
    disp(error);
    % if no error, cut the data by event markers
    if error==0
        % 去掉首尾的部分减少工作量,先找到marker的首位和末位然后延伸
        % cut the data by first and last event marker
        first=find(data(:,2)~=0,1,'first');
        last=find(data(:,2)~=0,1,'last');
        % 前面取到上一个结束位置的后一个点
        % find the next point of nearest stop point at the beginning
        first2=find(data(1:first,3)==3,1,'last')+1;
        % 后面取到下一个开始位置的前一个点
        % find the point just before the start point at the end
        last2=last+find(data(last+1:end,3)==1,1,'first')-1;
        % use the data cut by event marker if could not find more respiration
        if ~isempty(first2)
            first=first2;
        end
        if ~isempty(last2)
            last=last2;
        end
        % cut the data
        data=data(first:last,:);
        guisave=1;
        parameters=[3 0.15 1 50];
        save([path '/' filename(1:end-4) '.mat'],'data','guisave','parameters');
    else
        movefile([path '/' filename],[path '/unuse']);
    end    
end
% % for i=1:num
% % 6-bad example
% % 7-good example
% dname=file(6).name;
% alldata=load_acq([path '\' dname]);
% [data,error]=marker_trans(alldata.data);
% % res=findres(data,1);
% res=findres(data);
% data(:,3)=res;
% 
% %plot
% figure;
% set(gcf,'position',[0 150 3500 300])
% plot(data(:,1));
% title(dname);
% hold on
% % plot(start,'Color','r');
% %start
% timepoint=nan(size(data,1),1);
% start=find(res==1);
% timepoint(start)=data(start,1);
% plot(timepoint,'*','Color','g','MarkerSize',10);
% %stop
% timepoint=nan(size(data,1),1);
% stop=find(res==3);
% timepoint(stop)=data(stop,1);
% plot(timepoint,'*','Color','r','MarkerSize',10);
% %peak
% timepoint=nan(size(data,1),1);
% peak=find(res==2);
% timepoint(peak)=data(peak,1);
% plot(timepoint,'*','Color','b','MarkerSize',10);
% 
% % end
