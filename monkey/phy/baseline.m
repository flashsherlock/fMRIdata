
clear all;
clc;
%% load .mat res data
[filenames, pathname] = uigetfile( ...
    {'*.bhv2;*.h5;*.mat;','All Data Files'},...
    '请选择数据文件', ...
    'MultiSelect', 'on');   
res_data = load(filenames);

%% find out valid res points
ordor_num = 5;
points = findpoints(res_data.data);
markers(:,1) = find(res_data.data(:,2)>0);
markers(:,2) = res_data.data(markers(:,1),2);

marker_info(:,1) = markers(find(markers(:,2) ~=6),2);
marker_info(:,2) = markers(find(markers(:,2) ~=6),1);
marker_info(:,3) = markers(find(markers(:,2) == 6),1);

p = 1; % mark the index of current loc 
valid_res= cell(5,1);
%test = cell(5,1);
for i = 1:length(marker_info)
    ordor = marker_info(i,1);
    ordor_start = marker_info(i,2)-7000;
    ordor_end = marker_info(i,2);
    for ii = p:length(points)
        res_start = points(ii,1);
        res_end = points(ii,3);
        if  res_start>=ordor_start&res_end<ordor_end
            valid_res{ordor,1} = [valid_res{ordor,1};[res_start,res_end]];
            %test{ordor}{end+1} = res_data.data(res_start:res_end)';
        elseif res_start > ordor_start
            break
        else 
            continue
        end
        p = ii;
    end
end

%% 
fl = 'G:\rm035_麻醉\200529_testo1_rm035_1.plx';
[raw_freq, raw_n, raw_ts, raw_fn, raw_ad] = plx_ad(fl,'AI08'); % raw res data
%read spike time
post = 3;
[nspk, tspk] = plx_ts(fl, 'SPK64',0); % spike data
valid_spk = cell(ordor_num,1);
figure('position',[20,0,800,1000]);

%% plot raster
win = 0.05 % 50ms/win
max_y = 30;
for i = 1:ordor_num
    cat_spk = [];
    subplot(3,2,i);
    for ii = 1:length(valid_res{i,1})
      
        ref = valid_res{i,1}(ii,1)/raw_freq;
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
    set(gca,'ylim',[0,120]);    
    xlabel('Time(s)');
    ylabel('Baseline of Firing Rate (spk/s)');
    title(['ordor ',int2str(i)])
end

 saveas(gcf,'rm035ana_0529_test01_64baseline2','pdf')