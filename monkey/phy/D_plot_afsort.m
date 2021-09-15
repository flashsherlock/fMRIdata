% clear;
% clc;
%加载呼吸数据
plxdata_dir='/Volumes/WD_D/gufei/monkey_data/0907/';
date='200807';
plxname=[plxdata_dir date '_rm035_c1-spk_mrg-s.plx'];
odor_num = 6;
unit=2;
sample_rate=500;
chanlist=[34];

for resposition=1
valid_spk = cell(odor_num,1);
cat_spk = cell(odor_num,1);
resp1=cat_spk;
resp2=cat_spk;
resp3=cat_spk;
        %数据文件名
        fl=plxname;
        % date=front(3:6);
        % test=front(13);%换日期需要核对
        % condition='rm035ana_';
        % 通道
        for chan_i=1:length(chanlist)
            cur_chan=chanlist(chan_i);
            channel=num2str(cur_chan);
            SPK_chan=strcat('SPK',channel);
            %read spike time
            [nspk, tspk] = plx_ts(fl, SPK_chan,unit);
            %得到plx时间下的呼吸时间点
            [valid_res_plx,resp_points,~]=find_resp_cbtime(date);
            % 只是取一部分的空气条件
%             valid_res_plx{6}=valid_res_plx{6}(randperm(length(valid_res_plx{6}), 4),:);
            pre = 1;
            post = 4;
            win = 0.05; % 50ms/win
            max_y = 30;
            for i = 1:odor_num
                for res_i = 1:length(valid_res_plx{i})
                   ref = valid_res_plx{i}(res_i,resposition);
                    valid_spk{i}{end+1} = tspk(tspk>=ref-pre & tspk<=ref+post)-ref;
                    resp1{i}{end+1}=resp_points(resp_points(:,1)>=ref-pre & resp_points(:,1)<=ref+post,1)-ref;
                    resp2{i}{end+1}=resp_points(resp_points(:,2)>=ref-pre & resp_points(:,2)<=ref+post,2)-ref;
                    resp3{i}{end+1}=resp_points(resp_points(:,3)>=ref-pre & resp_points(:,3)<=ref+post,3)-ref;
            %         valid_reswave{i,1}{end+1,1}=res_data.data(valid_res_{i,1}(ii,1):1500+valid_res_{i,1}(ii,1));
                    cat_spk{i} = cat(1,cat_spk{i},valid_spk{i}{end});
                end
            end
        end

figure('position',[20,0,800,1000]);

%两次调用降采样函数做降采样
% ad=decimate(raw_ad, 10);%decimate降采样函数，建议参数<15
% ad=decimate(ad, 10);%降采样为400H，并做8阶chebyshevI型低通滤波器压缩频带(默认）
% freq=raw_freq/80;%频率下降80倍


for i = 1:odor_num
    subplot(3,2,i);
    for res_i = 1:length(valid_spk{i})
        % 画出spike
        scatter(valid_spk{i}{res_i},ones(length(valid_spk{i}{res_i}),1)*0+res_i*1,7,'k','filled'); hold on
        % 画出呼吸的标记
        scatter(resp1{i}{res_i},ones(length(resp1{i}{res_i}),1)*0+res_i*1,7,'g','>','filled'); hold on
        scatter(resp2{i}{res_i},ones(length(resp2{i}{res_i}),1)*0+res_i*1,16,'b','^','filled'); hold on
        scatter(resp3{i}{res_i},ones(length(resp3{i}{res_i}),1)*0+res_i*1,16,'r','<','filled'); hold on
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
    set(gca,'ylim',[0,20]);    
    xlabel('Time(s)');
    ylabel('Firing Rate (spk/s)');
    title(['odor ',int2str(i)])
end
% picturename=strcat();
suptitle([date '-' num2str(chanlist) '-unit',num2str(unit)])
end
% saveas(gcf,picturename{1},'fig')