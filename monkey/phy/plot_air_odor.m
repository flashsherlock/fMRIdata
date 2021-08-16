% 不选择呼吸，只是根据气味呈现时间画图
clear;
clc;
%加载呼吸数据
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/';
odor_num = 2;
sample_rate=500;
date={'200529'};
chanlist=[43];
condition='rm035ana_';

valid_spk = cell(odor_num,1);
valid_lfp = cell(odor_num,1);
cat_spk = cell(odor_num,1);
lfp=struct('label',{{}},'trial',{{[]}},'time',{{[]}});
resp1=cat_spk;
resp2=cat_spk;
resp3=cat_spk;

for date_i=1:length(date)
    cur_date=date{date_i};
    for test=1:4
        %数据文件名
        front=[data_dir cur_date '_testo' num2str(test) '_rm035_1'];
        raw_res_name=strcat(front,'.mat');
        fl=strcat(front,'.plx');
        % date=front(3:6);
        % test=front(13);%换日期需要核对
        % condition='rm035ana_';
        % 通道
        for chan_i=1:length(chanlist)
            cur_chan=chanlist(chan_i);
            channel=num2str(cur_chan);
            SPK_chan=strcat('SPK',channel);
            CON_chan=strcat('WB',channel);

            %read spike time
            [nspk, tspk] = plx_ts(fl, SPK_chan,0);
            %按照每导读取数据，频率信息存在raw_freq中，数据信息存在raw_ad中
            [raw_freq, raw_n, raw_ts, raw_fn, raw_ad] = plx_ad(fl,CON_chan);
            ad_time=0:(1/raw_freq):(raw_n-1)/raw_freq;
%             lfp.label{end+1}=CON_chan;
%             lfp.trial{1}=[lfp.trial{1};raw_ad'];
%             lfp.time{1}(end+1,:)=ad_time';
%             lfp.fsample=raw_freq;
            %得到plx时间下的呼吸时间点
            [~,resp_points,odor_time]=find_resp_time(front);
            %分割trial 每个test和date是不一样的，但是不同的通道是一样的
%             trl=[];
%             for label_i=1:length(odor_time)
%                 trl=[trl;[odor_time{label_i} zeros(size(odor_time{label_i},1),1) repmat(label_i,size(odor_time{label_i},1),1)]];
%             end
%             trl(:,1:2)=round(trl(:,1:2)*lfp.fsample);
%             trl(:,2)=trl(:,1)+lfp.fsample*7;
%             cfg=[];
%             cfg.trl=trl;
%             d = ft_redefinetrial(cfg, lfp);
            %
            
            % 只是取一部分的空气条件
            valid_res_plx{1}=[odor_time{1};odor_time{2};odor_time{3};odor_time{4};odor_time{5}];
            valid_res_plx{2}=odor_time{6};
            pre = 2;
            post = 7;
            win = 0.05; % 50ms/win
            max_y = 30;
            for i = 1:odor_num
                for res_i = 1:length(valid_res_plx{i})
                   ref = valid_res_plx{i}(res_i,1);
                    valid_spk{i}{end+1} = tspk(tspk>=ref-pre & tspk<=ref+post)-ref;
                    valid_lfp{i}{end+1} = raw_ad(ad_time>=ref-pre & ad_time<=ref+post);
                    resp1{i}{end+1}=resp_points(resp_points(:,1)>=ref-pre & resp_points(:,1)<=ref+post,1)-ref;
                    resp2{i}{end+1}=resp_points(resp_points(:,2)>=ref-pre & resp_points(:,2)<=ref+post,2)-ref;
                    resp3{i}{end+1}=resp_points(resp_points(:,3)>=ref-pre & resp_points(:,3)<=ref+post,3)-ref;
            %         valid_reswave{i,1}{end+1,1}=res_data.data(valid_res_{i,1}(ii,1):1500+valid_res_{i,1}(ii,1));
                    cat_spk{i} = cat(1,cat_spk{i},valid_spk{i}{end});
                end
            end
        end
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

figure('position',[20,0,800,1000]);

%两次调用降采样函数做降采样
% ad=decimate(raw_ad, 10);%decimate降采样函数，建议参数<15
% ad=decimate(ad, 10);%降采样为400H，并做8阶chebyshevI型低通滤波器压缩频带(默认）
% freq=raw_freq/80;%频率下降80倍


for i = 1:odor_num
    subplot(2,1,i);
    for res_i = 1:length(valid_spk{i})
        % 画出spike
        scatter(valid_spk{i}{res_i},ones(length(valid_spk{i}{res_i}),1)*0+res_i*5,7,'k','filled'); hold on
        % 画出呼吸的标记
        scatter(resp1{i}{res_i},ones(length(resp1{i}{res_i}),1)*0+res_i*5,7,'g','>','filled'); hold on
        scatter(resp2{i}{res_i},ones(length(resp2{i}{res_i}),1)*0+res_i*5,16,'b','^','filled'); hold on
        scatter(resp3{i}{res_i},ones(length(resp3{i}{res_i}),1)*0+res_i*5,16,'r','<','filled'); hold on
%         axis off
        box off
    end
    trans_spk = floor(cat_spk{i}/win)*win + win/2;
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
picturename=strcat(condition,date);
suptitle([picturename{1} num2str(chanlist)])
saveas(gcf,picturename{1},'fig')
