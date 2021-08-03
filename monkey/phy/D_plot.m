clear all;
clc;
%加载呼吸数据
front='200529_testo2_rm035_1';
raw_res_name=strcat(front,'.mat');
res_data = load(raw_res_name);
%找到气味释放起止时间及标记
ordor_num = 6;
points = findpoints(res_data.data);
markers(:,1) = find(res_data.data(:,2)>0);
markers(:,2) = res_data.data(markers(:,1),2);
marker_info=ones(30,3);
marker_info(:,1) = markers(:,2) ;
marker_info(:,2) = markers(:,1); 
for ii =1:29
   marker_info(ii,3)=markers(ii+1,1);
   ii=ii+1;
end 
marker_info(30,3)=markers(30,1)+3500;
%找到气味释放区间有效呼吸
p = 1; % mark the index of current loc 
valid_res = cell(6,1);
%test = cell(5,1);
for i = 1:length(marker_info)
    ordor = marker_info(i,1);
    ordor_start = marker_info(i,2);
    ordor_end = marker_info(i,3);
    for ii = p:length(points)
        res_start = points(ii,1);
        res_end = points(ii,3);
        if res_start+100>=ordor_start & res_end-500<=ordor_end
            valid_res{ordor,1} = [valid_res{ordor,1};[res_start,res_end]];
            %test{ordor}{end+1} = res_data.data(res_start:res_end)';
        elseif res_end-500 > ordor_end
            break
        else 
            continue
        end
        p = ii;
    end
end
%取每次气味释放前的一次呼吸作为空气的均线(目前随机取5行）
valid_res{6,1}=valid_res{6,1}(randperm(length(valid_res{6,1}), 5),:)



%导入plx数据,及信息
fl=strcat('G:\rm35olf\',front,'.plx');
front='200529_testo2_rm035_1';%前边有一次
date=front(3:6);
test=front(13);%换日期需要核对
condition='rm035ana_';
dig='c1_';
chanlist=[63];
ss=chanlist(1);
channel=num2str(ss);
SPK_chan=strcat('SPK',channel);


%plx_event_ts函数：读取打标时间点信息，n为总的打标点数目，ts是每次打标的时间点。"Strobed"为存储打标数据的channel名
[n, ts, sv] = plx_event_ts(fl, 'Strobed');

%read spike time
[nspk, tspk] = plx_ts(fl, SPK_chan,0);
 %按照每导读取数据，频率信息存在raw_freq中，数据信息存在raw_ad中(展示数据)
 [raw_freq, raw_n, raw_ts, raw_fn, raw_ad] = plx_ad(fl,ss);


if test==1
    cond=[1;4;2;5;3;4;1;5;2;4;3;5;2;1;3];
elseif test==2
    cond=[5;1;4;3;5;3;1;4;2;1;2;5;3;4;2];
elseif test==3
    cond=[3;4;1;2;5;3;4;2;1;5;1;2;4;3;5];
elseif test==4
    cond=[4;3;1;5;2;1;5;3;4;2;5;3;1;2;4];
end
post = 3;
ncond=n/7;
valid_spk = cell(ordor_num,1);
figure('position',[20,0,800,1000]);

%进行数据对齐，电生理与呼吸

first_start_plx=ts(3);
first_start_res=marker_info(1,2)/500;
bia=(first_start_plx-first_start_res)*500;
bia=round(bia);
valid_res_1=valid_res;
 for b =1:6
    valid_res_1{b,1}(:,:)=valid_res{b,1}(:,:)+bia;
end    

%两次调用降采样函数做降采样
 %ad=decimate(raw_ad, 10);%decimate降采样函数，建议参数<15
% ad=decimate(ad, 10);%降采样为400H，并做8阶chebyshevI型低通滤波器压缩频带(默认）
 %freq=raw_freq/80;%频率下降80倍


win = 0.05; % 50ms/win
max_y = 30;
for i = 1:ordor_num
    cat_spk = [];
    subplot(3,2,i);
    for ii = 1:length(valid_res_1{i,1})
       ref = valid_res_1{i,1}(ii,1)/raw_freq;
        valid_spk{i,1}{end+1,1} = tspk(tspk>=ref & tspk<=ref+post)-ref;
        cat_spk = cat(1,cat_spk,valid_spk{i}{ii});
        scatter(valid_spk{i}{ii},ones(length(valid_spk{i}{ii}),1)*0+ii*5,7,'k','filled'); hold on
%         axis off
        box off
    end
    trans_spk = floor(cat_spk/win)*win + win/2;
    freq = hist(trans_spk,unique(trans_spk))/(win*ii);
%    max_y = max([max_y;smoothcur]);
    smoothfreq=smooth(freq);
%     smoothfreq=freq;
    plot(unique(trans_spk), smoothfreq,'LineWidth',1.5,'color','[0.4940 0.1840 0.5560]');
    %set(gca,'Position',[0.05+(i-1)*0.2,0.1,0.15,0.35])
    set(gca,'ylim',[0,100]);    
    xlabel('Time(s)');
    ylabel('Firing Rate (spk/s)');
    title(['ordor ',int2str(i)])
end
picturename=strcat(condition,date,'test0',test,dig,SPK_chan)
saveas(gcf,picturename,'pdf')







