clear;
clc;
% 加载基本信息,以及后续各图片名称
data_dir='/Volumes/WD_D/gufei/monkey_data/0907/';
front='200807_rm035_c1';
%fl=strcat('G:\rm35olf\',front,'.plx');
fl=strcat(data_dir,front,'-spk_mrg-s','.plx');% 针对sorted 数据
date=front(3:6);
condition='rm035ana_';
dig=strcat('c',front(end));
%chanlist=[33 34 36 58 60 ];%双单元2
chanlist=[34];
unit=2;%需要手动选择
ss1=chanlist(1);
channel=num2str(ss1);
SPK_chan=strcat('SPK',channel);
unitname=strcat('unit',num2str(unit));
picturename=strcat(condition,date,dig,SPK_chan,unitname);
%设置展示y轴最大值
ymax=10;

%% 导入plx数据,进行计算

%plx_event_ts函数：读取打标时间点信息，n为总的打标点数目，ts是每次打标的时间点。"Strobed"为存储打标数据的channel名
[n, ts, sv] = plx_event_ts(fl, 'Strobed');

%read spike time,0表示unsorted unit ,1 unit a 
[nspk, tspk] = plx_ts(fl, SPK_chan,unit);
 %按照每导读取数据，频率信息存在raw_freq中，数据信息存在raw_ad中
%[raw_freq, raw_n, raw_ts, raw_fn, raw_ad] = plx_ad(fl,ss);

raw_freq=40000;

cond=[1;4;2;5;3;4;1;5;2;4;3;5;2;1;3;...
        5;1;4;3;5;3;1;4;2;1;2;5;3;4;2;...
        3;4;1;2;5;3;4;2;1;5;1;2;4;3;5;...
        4;3;1;5;2;1;5;3;4;2;5;3;1;2;4];

pre=2;
post = 7;
ncond=n/7;
odor_num=5;
valid_spk = cell(odor_num,1);
X=-pre:1/raw_freq:post;
Xpoint=X*raw_freq;
npin=100;%pin number for psth
win = 0.05 ;% 50ms/win
tpin=-pre:(pre+post)/npin:post;

%提取spk信号  
for i=1:ncond
    
    mark=ts((i-1)*7+3);
    align=round(mark*raw_freq);
    startpoint=Xpoint(1)+align;
    endpoint=Xpoint(end)+align;
    starttime=mark-pre;
    endtime=mark+post;
    valid_spk{cond(i),1}{end+1,1} =tspk(tspk>starttime&tspk<=endtime)-mark;

end


spk_com=cell(5,1);
%test 内3次重复合并
for oi=1:odor_num
    
    for oo=1:4
        spk_com{oi,1}{oo}=cat(1,valid_spk{oi,1}{oo*3-2},...
            valid_spk{oi,1}{oo*3-1},valid_spk{oi,1}{oo*3});
        spk_com{oi,1}{oo}=sort(spk_com{oi,1}{oo});
    end
end

%进行窗口为0.1s的计算
            
clear i;
MEAN=[];
STANDARD=[];
SK=[];
K=[];
kongqi=[];
spk_air=[];
%win=0.1s
wi=-1.9:0.1:7;
comput_Result=cell(5,1);
for ii=1:4
    for i=1:5
    for is=1:90
        ssi=isempty(find(spk_com{i,1}{1,ii}<wi(is)));
        if ssi==1
            comput_Result{i,1}{1,ii}(is)=0;
        elseif ssi==0
            comput_Result{i,1}{1,ii}(is)=max(find(spk_com{i,1}{1,ii}<wi(is)));
        end
    end
    comput_Result{i,2}{1,ii}(1)= comput_Result{i,1}{1,ii}(1);
    for iss=2:90
    comput_Result{i,2}{1,ii}(1)= comput_Result{i,1}{1,ii}(1);
    comput_Result{i,2}{1,ii}(iss)=comput_Result{i,1}{1,ii}(iss)-comput_Result{i,1}{1,ii}(iss-1);
    end
    for si=1:90  %计算发放率，4个test的  
    comput_Result{i,3}{1,ii}(si)=comput_Result{i,2}{1,ii}(si)./0.3;

    end
       
    end
end
%计算释放气味后4个test平均发放率曲线均值、方差，
for os=1:5
       for fi=1:90% comput_Result 4
            comput_Result{os,4}(fi)=(comput_Result{os,3}{1,1}(fi)+...
            comput_Result{os,3}{1,2}(fi)+comput_Result{os,3}{1,3}(fi)+...
            comput_Result{os,3}{1,4}(fi))/4; 
       end 
    MEAN(os)=mean(comput_Result{os,4}(21:90));
    STANDARD(os)=std(comput_Result{os,4}(21:90),0);
    %进行平滑
    comput_Result{os,5}=smooth(comput_Result{os,4});
    for kq =1:20
    kongqi = cat(1,kongqi,comput_Result{os,4}(kq));    
    end
end
%处于空气阶段发放率均值和方差；
MEAN(6)=mean(kongqi);
STANDARD(6)=std(kongqi);



%计算0.1ms下带宽为0.05的信息熵
clear i;clear is;clear iss;
wwi=-1.95:0.05:7;
Com_R2=cell(5,1);
ENTROPY=[];
for ss=1:4
for i=1:5
    for is=1:length(wwi)
        ssi=isempty(find(spk_com{i,1}{1,ss}<wwi(is)));
        if ssi==1
            Com_R2{i,1}{1,ss}(is)=0;
        elseif ssi==0 
            Com_R2{i,1}{1,ss}(is)=max(find(spk_com{i,1}{1,ss}<wwi(is)));
        end
    end    
    for R=2:180
    Com_R2{i,2}{1,ss}(R)=Com_R2{i,1}{1,ss}(R)-Com_R2{i,1}{1,ss}(R-1);
    end
end
end
clear i;
for op=1:4
for i=1:5
    for RS=1:180
    %0.1ms发放概率计算,分别除以test内的
    Com_R2{i,3}{1,op}(RS)= Com_R2{i,2}{1,op}(RS)./(comput_Result{i,2}{1,op}(round(RS/2))); 
    Com_R2{i,3}{1,op}(isnan(Com_R2{i,3}{1,op}))=0;
    %求熵
    Com_R2{i,4}{1,op}(RS)=Com_R2{i,3}{1,op}(RS)*(log2(Com_R2{i,3}{1,op}(RS)))*-1;
    Com_R2{i,4}{1,op}(isnan(Com_R2{i,4}{1,op}))=0; 
    end    
end
end

%对熵求均值，进行归一化处理，计算处于空气期间的值
for ff=1:5
       for fi=1:180% comput_Result 4
            Com_R2{ff,5}(fi)=(Com_R2{ff,4}{1,1}(fi)+...
            Com_R2{ff,4}{1,2}(fi)+Com_R2{ff,4}{1,3}(fi)+...
            Com_R2{ff,4}{1,4}(fi))/4; 
        %归一化处理，映射到8-10
        Com_R2{ff,6}(fi)=Com_R2{ff,5}(fi)./0.4+8;
       end
             
end

for ip=1:5
    ENTROPY(ip)=sum(Com_R2{ip,5}(21:90))./7;
    ENT_air(ip)=sum(Com_R2{ip,5}(1:20))./10;
end
ENTROPY(6)=sum(ENT_air);

%计算表格信息：

mean_compare=[];
square_compare=[];
entr_compare=[];
for com=1:6
   mean_compare(com)=MEAN(com)-MEAN(6);
   square_compare(com)=STANDARD(com)-STANDARD(6);
   entr_compare(com)=ENTROPY(com)-ENTROPY(6);
   if com==6
      mean_compare(com)=MEAN(6);
      square_compare(com)=STANDARD(6);
      entr_compare(com)=ENTROPY(6);
   end
end

data_row1=mean_compare;
data_row2=square_compare;
data_row3=entr_compare;
data=[data_row1;data_row2;data_row3];

%生成表格行列名称，m行w列
str1='气味';
m=6;w=3;
%column_name=strcat(str1,num2str((1:m)'));
column_name={'吲哚','异戊酸L','异戊酸H','白桃','香蕉','空气'};
row_name={'均值-比较','方差-比较','熵均-比较'};

%进行聚类比较
fire_rate=[comput_Result{1,4}(1,21:90);comput_Result{2,4}(1,21:90);...
   comput_Result{3,4}(1,21:90);comput_Result{4,4}(1,21:90);...
   comput_Result{5,4}(1,21:90);kongqi(21:90)'];
OR=mapminmax(fire_rate',0,1)'; % 按列最小最大规范化到[0,1]
Y=pdist(OR); % 计算矩阵OR中样本两两之间的距离，但得到的Y是个行向量
D=squareform(Y); % 将行向量的Y转换成方阵，方便观察两点距离(方阵的对角线元素都是0)
Z=linkage(Y); % 产生层次聚类树，默认采用最近距离作为类间距离的计算公式

%原始画图位置




%% 画图并且保存
figure('position',[20,10,800,1000]);
for oi=1:odor_num
    subplot(3,2,oi);
    for iis = 1:12
    scatter(valid_spk{oi,1}{iis},ones(length(valid_spk{oi,1}{iis}),1)*0+iis*0.3,7,'k','filled'); hold on  
    %defult =0.3;
    end
    plot(wi, comput_Result{oi,5},'LineWidth',1.5,'color','[0.4940 0.1840 0.5560]');hold on
    plot(wwi,Com_R2{oi,6},'LineWidth',1.5,'color','[0.00 0.45 0.74]');hold on
    %plot(x,cumsum(y)/sum(y));hold on 
    %气味释放标记
    plot([0,0],[0,ymax],'Color','r','LineStyle','--');
    plot([7,7],[0,ymax],'Color','r','LineStyle','--');
    xlim([-pre,post]);
    ylim([0,ymax]);
    xlabel('Time(s)');
    ylabel('Firing Rate (spk/s)');
    title(['odor ',int2str(oi)]);
end
subplot(3,2,6);
hh=dendrogram(Z); % 图示层次聚类树
h=uitable(gcf,'Data',data,'Position',[360 23 375 75],...
    'Columnname',column_name,'Rowname',row_name);hold on

% saveas(gcf,picturename,'pdf')







