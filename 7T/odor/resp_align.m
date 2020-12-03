% fieldtrip的滤波器 每一行是一组数据
clc;
clear
respdir='/Volumes/WD_D/gufei/7T_odor/S01_yyt/respiration/';

filename=dir([respdir filesep 'resp*.mat']);

sprate=500;
time=390;
run=6;
scale=1;

plot_a=1;
plot_b=sprate*20;

for i=1:run
    load([respdir filesep filename(i).name]);
    data(:,1)=ft_preproc_lowpassfilter(data(:,1)',500,10)';
    % flip biopac data
    if scale==1
        data(:,1)=rescale(-data(:,1));
        phy=rescale(phy);
    else
        data(:,1)=-data(:,1);
        phy=phy/10000;
    end
    
    disp(['run' num2str(i)]);
    % disp(corr(data(:,1),phy));
    initial_r=corr(data(:,1),phy);
    
    figure;
    plot(phy(plot_a:plot_b,1));
    hold on
    plot(data(plot_a:plot_b,1));
    
    % delay<0 means the second one(data) is previous to the first one(phy)
    % delay=finddelay(phy,data(:,1));
    
    % lags>0 has the same meaning with delay<0
    % lags>0 means the second one(data) should move right
    xc=xcorr(phy,data(:,1),'coeff');
    [c,lags]=max(xc);
    lags=lags-length(phy);
        
    if lags>0
        disp([lags xc(length(phy)) c initial_r corr(data(1:end-lags,1),phy(1+lags:end))]);
        figure;
        plot(phy(plot_a+lags:plot_b+lags,1));
        hold on
        plot(data(plot_a:plot_b,1));
    else
        disp([lags xc(length(phy)) c initial_r corr(data(1-lags:end,1),phy(1:end+lags))]);
        figure;
        plot(phy(plot_a:plot_b,1));
        hold on
        plot(data(plot_a-lags:plot_b-lags,1));
    end
end