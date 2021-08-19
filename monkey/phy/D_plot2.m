clear;
clc;
%加载呼吸数据
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/';
odor_num = 2;
sample_rate=500;
date={'200731','200807','200814'};
chanlist=33:64;
condition='rm035ana_';

for date_i=1:length(date)
    cur_date=date{date_i};
for chan_i=1:length(chanlist)
    cur_chan=chanlist(chan_i);
valid_spk = cell(odor_num,3);
cat_spk = cell(odor_num,3);
resp1=cat_spk;
resp2=cat_spk;
resp3=cat_spk;
    for test=1:4
        front=[data_dir cur_date '_testo' num2str(test) '_rm035_1'];
        nplx=dir([front '*.plx']);
        for rep=1:length(nplx)
        %数据文件名
        front=nplx(rep).name;
        front=[data_dir strrep(front,'.plx','')];
        raw_res_name=strcat(front,'.mat');
        fl=strcat(front,'.plx');
        % date=front(3:6);
        % test=front(13);%换日期需要核对
        % condition='rm035ana_';
        % 通道
%         for chan_i=1:length(chanlist)
%             cur_chan=chanlist(chan_i);
            channel=num2str(cur_chan);
            SPK_chan=strcat('SPK',channel);
            CON_chan=strcat('WB',channel);

            %read spike time
            [nspk, tspk] = plx_ts(fl, SPK_chan,0);
            %按照每导读取数据，频率信息存在raw_freq中，数据信息存在raw_ad中
            [raw_freq, raw_n, raw_ts, raw_fn, raw_ad] = plx_ad(fl,CON_chan);
            ad_time=0:(1/raw_freq):(raw_n-1)/raw_freq;

            %得到plx时间下的呼吸时间点
            [valid_res_plx6,resp_points,odor_time]=find_resp_time(front);
            
            % 只是取一部分的空气条件
            valid_res_plx=cell(2,1);
            valid_res_plx{1}=[valid_res_plx6{1};valid_res_plx6{2};valid_res_plx6{3};valid_res_plx6{4};valid_res_plx6{5}];
            valid_res_plx{2}=valid_res_plx6{6};
            pre = 2;
            post = 2;
            win = 0.05; % 50ms/win
            max_y = 30;
            for i = 1:odor_num
                for res_i = 1:length(valid_res_plx{i})
                    for resp_i=1:3
                   ref = valid_res_plx{i}(res_i,resp_i);
                    valid_spk{i,resp_i}{end+1} = tspk(tspk>=ref-pre & tspk<=ref+post)-ref;
                    resp1{i,resp_i}{end+1}=resp_points(resp_points(:,1)>=ref-pre & resp_points(:,1)<=ref+post,1)-ref;
                    resp2{i,resp_i}{end+1}=resp_points(resp_points(:,2)>=ref-pre & resp_points(:,2)<=ref+post,2)-ref;
                    resp3{i,resp_i}{end+1}=resp_points(resp_points(:,3)>=ref-pre & resp_points(:,3)<=ref+post,3)-ref;
            %         valid_reswave{i,1}{end+1,1}=res_data.data(valid_res_{i,1}(ii,1):1500+valid_res_{i,1}(ii,1));
                    cat_spk{i,resp_i} = cat(1,cat_spk{i,resp_i},valid_spk{i,resp_i}{end});
                    end
                end
            end
%         end
        end
    end

if test==1
    cond=[1;4;2;5;3;4;1;5;2;4;3;5;2;1;3];
elseif test==2
    cond=[5;1;4;3;5;3;1;4;2;1;2;5;3;4;2];
elseif test==3
    cond=[3;4;1;2;5;3;4;2;1;5;1;2;4;3;5];
elseif test==4
    cond=[4;3;1;5;2;1;5;3;4;2;5;3;1;2;4];
end

figure('position',[20,0,800,1000],'PaperType','a3');

%两次调用降采样函数做降采样
% ad=decimate(raw_ad, 10);%decimate降采样函数，建议参数<15
% ad=decimate(ad, 10);%降采样为400H，并做8阶chebyshevI型低通滤波器压缩频带(默认）
% freq=raw_freq/80;%频率下降80倍

try
for i = 1:odor_num
    for resp_i=1:3
    subplot(3,2,2*(resp_i-1)+i);
    for res_i = 1:length(valid_spk{i,resp_i})
        % 画出spike
        scatter(valid_spk{i,resp_i}{res_i},ones(length(valid_spk{i,resp_i}{res_i}),1)*0+res_i*5,7,'k','filled'); hold on
        % 画出呼吸的标记
        scatter(resp1{i,resp_i}{res_i},ones(length(resp1{i,resp_i}{res_i}),1)*0+res_i*5,7,'g','>','filled'); hold on
        scatter(resp2{i,resp_i}{res_i},ones(length(resp2{i,resp_i}{res_i}),1)*0+res_i*5,16,'b','^','filled'); hold on
        scatter(resp3{i,resp_i}{res_i},ones(length(resp3{i,resp_i}{res_i}),1)*0+res_i*5,16,'r','<','filled'); hold on
%         axis off
        box off
    end
    trans_spk = floor(cat_spk{i,resp_i}/win)*win + win/2;
    freq = hist(trans_spk,unique(trans_spk))/(win*res_i);
%    max_y = max([max_y;smoothcur]);
    smoothfreq=smooth(freq);
%     smoothfreq=freq;
    plot(unique(trans_spk), smoothfreq,'LineWidth',1.5,'color','[0.4940 0.1840 0.5560]');
    %set(gca,'Position',[0.05+(i-1)*0.2,0.1,0.15,0.35])
    set(gca,'ylim',[0,100]);    
    xlabel('Time(s)');
    ylabel('Firing Rate (spk/s)');
    title(['odor ',int2str(i)])
    end
end
picturename=strcat(condition,cur_date);
suptitle([picturename num2str(channel)])
% saveas(gcf,picturename{1},'fig')
saveas(gcf,[data_dir 'picture/' picturename '-' num2str(channel)],'pdf')
catch
    picturename=strcat(condition,cur_date);
    disp([picturename '-' num2str(channel)])
end
end
close all
end