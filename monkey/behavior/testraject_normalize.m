clc;clear;
id=fopen('嗅觉实验记录.txt');
conditions=textscan(id,'%q','whitespace','\b\t');
conditions=conditions{1};
fclose(id);
files=dir('data*.csv');
alldata=cell(1,length(files));
% middle point
m=zeros(1,length(files));
for f=1:length(files)
    % load data
    filename=files(f).name;
    % 从第二行第一列读取数据
    data=csvread(filename,1,0);
    m(f)=mean([min(data(:,2)) max(data(:,2))]);
    disp([min(data(:,2)) mean([min(data(:,2)) max(data(:,2))]) max(data(:,2)) min(data(:,3)) mean([min(data(:,3)) max(data(:,3))]) max(data(:,3))])
    data(:,3)=130-data(:,3);
    % 绘制轨迹
    % monkeyt(data(:,2),data(:,3),0.1,0.001);
    % 查看分布情况
    % length(data(data(:,2)>100,3));
    % length(data(data(:,2)<=100,3));
    % 
    % length(data(data(:,2)<=90,3));
    % length(data(data(:,2)>=110,3));
    % 
    % length(data(data(:,2)<=80,3));
    % length(data(data(:,2)>=120,3));
    % max(data(:,2));
    % min(data(:,2));
    % mean([max(data(:,2)),min(data(:,2))]);
    %保存到cell中
    alldata{f}=data;
end
%% Scale

for f=1:length(files)
    data=alldata{f};
    mid=m(f);
    minvalue=min(data(:,2));
    maxvalue=max(data(:,2));
    data(data(:,2)<=mid,2)=(data(data(:,2)<=mid,2)-minvalue)*100/(mid-minvalue);    
    data(data(:,2)>mid,2)=100+(data(data(:,2)>mid,2)-mid)*100/(maxvalue-mid);    
    alldata{f}=data;
end
%% 绘制轨迹

for f=1:length(files)
    data=alldata{f};
    figure;
    % 绘制轨迹
    % monkeyt(data(:,2),data(:,3),0.1,0.001);
    monkeyt(data(:,2),data(:,3),0,0);
    title(conditions{f});
end
%% 整体的直方图

interval=5;
for f=1:length(files)
    data=alldata{f};
    % chisq test
    disp(conditions{f})
    for i=0:10:20
        cutl=100-i;
        cutr=100+i;
        disp([cutl cutr])
        [pvalue,st]=chit(data,cutl,cutr)
    end
    figure;
    % x方向的分布
    subplot(1,2,1)
    hist(data(:,2),interval/2:interval:200-interval/2);
    line([100 100],get(gca,'Ylim'),'linestyle',':')
    title('x')
    % y方向的分布
    subplot(1,2,2)
    hist(data(:,3));
    title('y')
    suptitle(conditions{f});
end
%% 合并4个条件

tic;
interval=10;
data=[alldata{1};alldata{2};alldata{3};alldata{4}];
expect=zeros(3,2);
    % chisq test
    disp('4 days');
    for i=0:10:20
        cutl=100-i;
        cutr=100+i;
        disp([cutl cutr])
        [pvalue,st]=chit(data,cutl,cutr)
        expect(i/10+1,:)=st.O;
    end

figure;
subplot(1,2,1)
hist(data(:,2),interval/2:interval:200-interval/2);
line([100 100],get(gca,'Ylim'),'linestyle',':')
title('x')
% y方向的分布
subplot(1,2,2)
hist(data(:,3));
title('y')
%% 绘制热图

xx=data(:,2);
yy=data(:,3);

% sigma = 0.1;
gridSize = 100;

x=linspace(0,200,gridSize+1);
y=linspace(0,100,gridSize+1);
gridEval = zeros(length(x)-1,length(y)-1);

% 计算每个网格中点的频数
for cnt_x=1:length(x)-1
    for cnt_y=1:length(y)-1
        x_ind=xx>x(cnt_x) & xx<=x(cnt_x+1);                                                    
        xy_ind=yy(x_ind)>y(cnt_y) & yy(x_ind)<=y(cnt_y+1);     
        gridEval(cnt_y, cnt_x)=length(yy(xy_ind));
    end
end

% % 计算每个点处的高斯函数
% for i = 1:length(x)-1
%     for j = 1:length(y)-1
%     %calculate a Gaussian function on the grid with each point in the center and add them up
%         gridEval(j,i) = gridEval(j,i) + sum(exp(-(((x(i)-xx).^2)./(2*sigma.^2) + ((y(j)-yy).^2)./(2*sigma.^2))));       
%     end
% end

% 绘制热图
figure;
surf((x(1:end-1)+ x(2:end))/2,(y(1:end-1)+y(2:end))/2,gridEval); view(2); shading interp;
% 增加z轴会变成三维的
% axis([0 200 0 100 0 100]);
axis([0 200 0 100])
h1 = gca; % 保存句柄，以便后面添加边框
set(gca, 'CLim', [0 400]);
% 添加标注
% title(['平滑散点图, \sigma = ' num2str(sigma) ', 网格数： ' num2str(gridSize) ' x' num2str(gridSize)],'Fontsize',14);
title(['网格数： ' num2str(gridSize) ' x' num2str(gridSize)]);
xlabel('x','Fontsize',14);
ylabel('y','Fontsize',14);

% 添加颜色条
colormap jet
colorbar;
ylabel('Intensity','Fontsize',14);

% 添加黑色的边框
axes(h1);
line(get(gca,'xlim'),repmat(min(get(gca,'ylim')),1,2),'color',[0 0 0],'linewidth',1);
line(get(gca,'xlim'),repmat(max(get(gca,'ylim')),1,2),'color',[0 0 0],'linewidth',2);
line(repmat(min(get(gca,'xlim')),1,2),get(gca,'ylim'),'color',[0 0 0],'linewidth',2);
line(repmat(max(get(gca,'xlim')),1,2),get(gca,'ylim'),'color',[0 0 0],'linewidth',1);

set(gcf,'color',[1 1 1],'paperpositionmode','auto');
toc;
%% 合并两个条件-1和3合并为1的方向

tic;
interval=10;
data=alldata{3};
data(:,2)=200-data(:,2);
data=[alldata{1};data];

    % chisq test
    disp(conditions{1}(10:end))
    for i=0:10:20
        cutl=100-i;
        cutr=100+i;
        disp([cutl cutr])
        [pvalue,st]=chit(data,cutl,cutr,expect(i/10+1,:))
    end

figure;
subplot(1,2,1)
hist(data(:,2),interval/2:interval:200-interval/2);
line([100 100],get(gca,'Ylim'),'linestyle',':')
title('x')
% y方向的分布
subplot(1,2,2)
hist(data(:,3));
title('y')
t=conditions{1};
suptitle(t(10:end));
%% 绘制热图

xx=data(:,2);
yy=data(:,3);

% sigma = 0.1;
gridSize = 100;

x=linspace(0,200,gridSize+1);
y=linspace(0,100,gridSize+1);
gridEval = zeros(length(x)-1,length(y)-1);

% 计算每个网格中点的频数
for cnt_x=1:length(x)-1
    for cnt_y=1:length(y)-1
        x_ind=xx>x(cnt_x) & xx<=x(cnt_x+1);                                                    
        xy_ind=yy(x_ind)>y(cnt_y) & yy(x_ind)<=y(cnt_y+1);     
        gridEval(cnt_y, cnt_x)=length(yy(xy_ind));
    end
end

% % 计算每个点处的高斯函数
% for i = 1:length(x)-1
%     for j = 1:length(y)-1
%     %calculate a Gaussian function on the grid with each point in the center and add them up
%         gridEval(j,i) = gridEval(j,i) + sum(exp(-(((x(i)-xx).^2)./(2*sigma.^2) + ((y(j)-yy).^2)./(2*sigma.^2))));       
%     end
% end

% 绘制热图
figure;
surf((x(1:end-1)+ x(2:end))/2,(y(1:end-1)+y(2:end))/2,gridEval); view(2); shading interp;
% 增加z轴会变成三维的
% axis([0 200 0 100 0 100]);
axis([0 200 0 100])
h1 = gca; % 保存句柄，以便后面添加边框
set(gca, 'CLim', [0 400]);
% 添加标注
% title(['平滑散点图, \sigma = ' num2str(sigma) ', 网格数： ' num2str(gridSize) ' x' num2str(gridSize)],'Fontsize',14);
title([t(10:end) '  网格数： ' num2str(gridSize) ' x' num2str(gridSize)]);
xlabel('x','Fontsize',14);
ylabel('y','Fontsize',14);

% 添加颜色条
colormap jet
colorbar;
ylabel('Intensity','Fontsize',14);

% 添加黑色的边框
axes(h1);
line(get(gca,'xlim'),repmat(min(get(gca,'ylim')),1,2),'color',[0 0 0],'linewidth',1);
line(get(gca,'xlim'),repmat(max(get(gca,'ylim')),1,2),'color',[0 0 0],'linewidth',2);
line(repmat(min(get(gca,'xlim')),1,2),get(gca,'ylim'),'color',[0 0 0],'linewidth',2);
line(repmat(max(get(gca,'xlim')),1,2),get(gca,'ylim'),'color',[0 0 0],'linewidth',1);

set(gcf,'color',[1 1 1],'paperpositionmode','auto');
toc;
%% 合并两个条件-2和3合并为2的方向

tic;
interval=10;
data=alldata{4};
data(:,2)=200-data(:,2);
data=[alldata{2};data];
    % chisq test
    disp(conditions{2}(10:end))
    for i=0:10:20
        cutl=100-i;
        cutr=100+i;
        disp([cutl cutr])
        [pvalue,st]=chit(data,cutl,cutr,expect(i/10+1,:))
    end
figure;
subplot(1,2,1)
hist(data(:,2),interval/2:interval:200-interval/2);
line([100 100],get(gca,'Ylim'),'linestyle',':')
title('x')
% y方向的分布
subplot(1,2,2)
hist(data(:,3));
title('y')
t=conditions{2};
suptitle(t(10:end));
%% 绘制热图

xx=data(:,2);
yy=data(:,3);

sigma = 0.1;
gridSize = 100;

x=linspace(0,200,gridSize);
y=linspace(0,100,gridSize);
gridEval = zeros(length(x)-1,length(y)-1);

% 计算每个网格中点的频数
for cnt_x=1:length(x)-1
    for cnt_y=1:length(y)-1
        x_ind=xx>x(cnt_x) & xx<=x(cnt_x+1);                                                    
        xy_ind=yy(x_ind)>y(cnt_y) & yy(x_ind)<=y(cnt_y+1);     
        gridEval(cnt_y, cnt_x)=length(yy(xy_ind));
    end
end

% % 计算每个点处的高斯函数
% for i = 1:length(x)-1
%     for j = 1:length(y)-1
%     %calculate a Gaussian function on the grid with each point in the center and add them up
%         gridEval(j,i) = gridEval(j,i) + sum(exp(-(((x(i)-xx).^2)./(2*sigma.^2) + ((y(j)-yy).^2)./(2*sigma.^2))));       
%     end
% end

% 绘制热图
figure;
surf((x(1:end-1)+ x(2:end))/2,(y(1:end-1)+y(2:end))/2,gridEval); view(2); shading interp;
axis([0 200 0 100]);
h1 = gca; % 保存句柄，以便后面添加边框
% 设置颜色范围
set(gca, 'CLim', [0 400]);

% 添加标注
% title(['平滑散点图, \sigma = ' num2str(sigma) ', 网格数： ' num2str(gridSize) ' x' num2str(gridSize)],'Fontsize',14);
title([t(10:end) '  网格数： ' num2str(gridSize) ' x' num2str(gridSize)]);
xlabel('x','Fontsize',14);
ylabel('y','Fontsize',14);

% 添加颜色条
colormap jet
colorbar;
ylabel('Intensity','Fontsize',14);

% 添加黑色的边框
axes(h1);
line(get(gca,'xlim'),repmat(min(get(gca,'ylim')),1,2),'color',[0 0 0],'linewidth',1);
line(get(gca,'xlim'),repmat(max(get(gca,'ylim')),1,2),'color',[0 0 0],'linewidth',2);
line(repmat(min(get(gca,'xlim')),1,2),get(gca,'ylim'),'color',[0 0 0],'linewidth',2);
line(repmat(max(get(gca,'xlim')),1,2),get(gca,'ylim'),'color',[0 0 0],'linewidth',1);

set(gcf,'color',[1 1 1],'paperpositionmode','auto');
toc;
%% 合并两个条件的（只取前面一段时间）

interval=10;
timeint=10;%minute
p1=1;
p2=timeint*60*1000/40;
% 1和3合并为1的方向
data=alldata{3};
data(:,2)=200-data(:,2);
data=[alldata{1}(p1:p2,:);data(p1:p2,:)];
data=data(data(:,2)<=50|data(:,2)>=150,:);
    % chisq test
    for i=0
        cutl=100-i;
        cutr=100+i;
        disp([cutl cutr])
        [pvalue,st]=chit(data,cutl,cutr)
    end
figure;
subplot(1,2,1)
hist(data(:,2),interval/2:interval:200-interval/2);
line([100 100],get(gca,'Ylim'),'linestyle',':')
title('x')
% y方向的分布
subplot(1,2,2)
hist(data(:,3));
title('y')
t=conditions{1};
suptitle(t(10:end));

% 2和4合并为2的方向
data=alldata{4};
data(:,2)=200-data(:,2);
data=[alldata{2}(p1:p2,:);data(p1:p2,:)];
data=data(data(:,2)<=50|data(:,2)>=150,:);
    % chisq test
    for i=0
        cutl=100-i;
        cutr=100+i;
        disp([cutl cutr])
        [pvalue,st]=chit(data,cutl,cutr)
    end
figure;
subplot(1,2,1)
hist(data(:,2),interval/2:interval:200-interval/2);
line([100 100],get(gca,'Ylim'),'linestyle',':')
title('x')
% y方向的分布
subplot(1,2,2)
hist(data(:,3));
title('y')
t=conditions{2};
suptitle(t(10:end));
%% 分时段的分布直方图

timeint=7.1;%minute
p=timeint*60*1000/40;
interval=5;
% plot each day
for f=1:length(files)
    data=alldata{f};
    l=length(data(:,2));
    plots=ceil(l/p);
    figure;
    set(gcf,'position',[1280,720,ceil(plots/2)*400,2*300]);
    disp('===========================')
    disp(conditions{f})
    disp('===========================')
    for j=0:10:50
        timelab=zeros(1,l);
        leftright=timelab;
        cutl=100-j;
        cutr=100+j;
        leftright(data(:,2)<cutl)=1;
        leftright(data(:,2)>cutl)=2;
        for i=1:plots
            timelab(p*(i-1)+1:min(p*i,l))=i;          
        end
        timelab(leftright==0)=[];
        leftright(leftright==0)=[];
        [tbl,chi2,pvalue] = crosstab(timelab,leftright);
        disp('-------------')
        disp([num2str(cutl) '-' num2str(cutr)])
        disp(tbl)
        disp(chi2)
        disp(pvalue)
        disp('-------------')

    end
    % subplot each bin
    for i=1:plots
        subplot(2,ceil(plots/2),i)
        hist(data(p*(i-1)+1:min(p*i,l),2),interval/2:interval:200-interval/2)
        line([100 100],get(gca,'Ylim'),'linestyle',':')
%         disp('-------------')
%         disp([num2str(p*(i-1)+1) '-' num2str(min(p*i,l))])
%         
            % chisq test
        for j=0%:10:20
            cutl=100-j;
            cutr=100+j;
%             disp([cutl cutr])
            [pvalue,st]=chit(data(p*(i-1)+1:min(p*i,l),:),cutl,cutr);
        end
%         disp('-------------')
        
        title({[num2str(p*(i-1)+1) '-' num2str(min(p*i,l))];[num2str(cutl) '-' num2str(cutr) ' : ' num2str(st.O)]})
    end
    suptitle({conditions{f};''});
end
%% 绘制热图的例子 生成数据

% z = [repmat([1 2],1000,1) + randn(1000,2)*[1 .5; 0 1.32];...
%      repmat([9 1],1000,1) + randn(1000,2)*[1.4 .2; 0 0.98];...
%      repmat([4 8],1000,1) + randn(1000,2)*[1 .7; 0  0.71];];
%  
% figure('units','normalized','position',[ 0.4458    0.6296    0.1995    0.2759]);
% plot(z(:,1),z(:,2),'.');
% title({'原始数据','散点视图有显著的重叠'});
% set(gcf,'color',[1 1 1],'paperpositionmode','auto');
%% 绘制热图

% xx = z(:,1);
% yy = z(:,2);
% sigma = 0.1;
% gridSize = 100;
% 
% % 选择colormap
% colormap(summer);
% 
% x=linspace(min(xx),max(xx),gridSize);
% y=linspace(min(yy),max(yy),gridSize);
% gridEval = zeros(length(x)-1,length(y)-1);
% 
% % 计算每个点处的高斯函数
% for i = 1:length(x)-1
%     for j = 1:length(y)-1
%     %calculate a Gaussian function on the grid with each point in the center and add them up
%         gridEval(j,i) = gridEval(j,i) + sum(exp(-(((x(i)-xx).^2)./(2*sigma.^2) + ((y(j)-yy).^2)./(2*sigma.^2))));       
%     end
% end
% 
% % 绘制热图
% figure;
% surf((x(1:end-1)+ x(2:end))/2,(y(1:end-1)+y(2:end))/2,gridEval); view(2); shading interp;
% axis([min(xx),max(xx) min(yy),max(yy)]);
% h1 = gca; % 保存句柄，以便后面添加边框
% 
% % 添加标注
% title(['平滑散点图, \sigma = ' num2str(sigma) ', 网格数： ' num2str(gridSize) ' x' num2str(gridSize)],'Fontsize',14);
% xlabel('x','Fontsize',14);
% ylabel('y','Fontsize',14);
% 
% % 添加颜色条
% colorbar;
% ylabel('Intensity','Fontsize',14);
% 
% % 添加黑色的边框
% axes(h1);
% line(get(gca,'xlim'),repmat(min(get(gca,'ylim')),1,2),'color',[0 0 0],'linewidth',1);
% line(get(gca,'xlim'),repmat(max(get(gca,'ylim')),1,2),'color',[0 0 0],'linewidth',2);
% line(repmat(min(get(gca,'xlim')),1,2),get(gca,'ylim'),'color',[0 0 0],'linewidth',2);
% line(repmat(max(get(gca,'xlim')),1,2),get(gca,'ylim'),'color',[0 0 0],'linewidth',1);
% 
% set(gcf,'color',[1 1 1],'paperpositionmode','auto');

% %% 绘制运动的点
% % 最简单的动画形式，使用comet、comet3函数
% % 产生一个顺着曲线轨迹运动的质点
% % step1：求解出质点完整的运动轨迹坐标x，y和z
% % step2：使用comet或者comet3直接绘制动点
%  % 使用函数comet建立质点绕圆运动的动画
% clc;clear;
% %{
%  linspace是Matlab中的一个指令，用于产生指定范围内的指定数量点数，相邻数据跨度相同，并返回一个行向量。
%  调用方法：linspace(x1,x2,N)
%  功 能：用于产生x1，x2之间的N点行矢量，相邻数据跨度相同。其中x1、x2、N分别为起始值、终止值、元素个数。若缺省N，默认点数为100。
%  举例如下：X = linspace(5, 100, 20) % 产生从5到100范围内的20个数据，相邻数据跨度相同
%  X = 5 10 15 20 25 30 35 40 45 5055 60 65 70 75 80 85 90 95 100 ps：这和X = [5 : 5 : 100]的效果是一样的。
% %}
% % 圆周运动
% t = linspace(0, 2*pi, 10000);
% x = cos(t);
% y = sin(t);
% % 以便比较comet是否跟着轨迹走
% % plot(x, y);
% axis([-1, 1 -1, 1]); axis square;
% hold on; grid on;
% % comet(x, y, p); p：定义轨迹尾巴的长度，范围在0-1之间，默认时为0.1
% comet(x, y, 0.03);
%  
%  
% % 平抛运动
% clf;
% clear;
% grid on;
% vx = 40;
% dt = linspace(0,10,1000);
% dx = vx*dt;
% dy = -9.8*dt.^2/2;
% comet(dx, dy);
% 
% 
% % 导弹发射
% clf;
% clear;
% grid on;
% vx = 100*cos(1/4*pi);
% vy = 100*sin(1/4*pi);
% t = 0:0.01:15;
% dx = vx*t;
% dy = vy*t-9.8*t.^2/2;
% comet(dx, dy);
% % 使用函数comet3建立质点绕圆运动的动画
% figure();
% grid on;
% tt = 0:pi/500:10*pi;
% plot3(sin(t),cos(t),t);
% comet3(sin(tt), cos(tt), tt, 0.5); 
% 
% %% 制作动画
% clc; clear;
% % peaks是一个函数，其中有2个变量。由平移和放缩高斯分布函数获得。
% % 参数为30，得到的X、Y、Z为30*30的矩阵。
% [X, Y, Z] = peaks(30);
% % surf绘制三维曲面图
% surf(X,Y,Z);
% axis([-3,3,-3,3,-10,10]);
% % 关闭所用坐标轴上的标记、格栅和单位标记。但保留由text和gtext设置的对象
% axis off;
% %{
%  shading：是用来处理色彩效果的，分以下三种：
%  1、no shading 一般的默认模式 即shading faceted
%  2、shading flat 在faceted的基础上去掉图上的网格线
%  3、shading interp 在flat的基础上进行色彩的插值处理，使色彩平滑过渡
% %}
% shading interp;
% %{
%  colormap：设定和获取当前的色图。
%  1、colormap(map)：设置颜色图为矩阵map。如果map中的任何值在区间[0,1]之外，MATLAB返回错误。
%  2、colormap('default')：将当前的颜色图设置为默认的颜色图。
%  3、cmap=colormap：返回当前的颜色图。返回的值都在区间[0,1]内。
%  map是一个3列矩阵，其元素数值定义在区间[0,1]。矩阵的每行元素表示1一个真色彩向量，即红、绿、蓝3基色的系数。
%  jet为matlab中预定义的色图样式中的一种，表示：黑、红、黄、白色浓淡交错。
% %}
% colormap(jet);
% % 建立一个20列的大矩阵
% M = moviein(20);
% for i = 1:20
%  % 改变视点
%   view(-37.5+24*(i-1),30);
%  % 将图形保存到M矩阵
%  M(i) = getframe;
% end
% % 播放画面2次
% movie(M,2);
% %% 动态绘制椭圆
% clc;
% axis([-2,2,-2,2]);
% % axis square 当前坐标系图形设置为方形，刻度范围不一定一样，但是一定是方形的。
% % axis equal 将横轴纵轴的定标系数设成相同值，即单位长度相同，刻度是等长的，但不一定是方形的。
% axis equal;
% grid on;
% h = animatedline('Marker', 'o', 'color', 'b', 'LineStyle', 'none');
% t = 6*pi*(0:0.02:1);
% for n = 1:length(t)
%  addpoints(h, 2*cos(t(1:n)),sin(t(1:n)));
%  % 一般是为了动态观察变化过程 pause（a）暂停a秒后执行下一条指令
%  pause(0.05);
%  % 可以用drawnow update加快动画速度
%  drawnow update;
% end