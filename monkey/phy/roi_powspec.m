%% load and reorganize data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
pic_dir=[data_dir 'pic/odorresp_roi/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% generate data
label='/Volumes/WD_D/gufei/monkey_data/IMG/RM035_NMT/RM035_allpos_label5d.mat';
dates = {'200731', '200807', '200814', '200820', '200828'};
level = 4;
trl_type = 'odor';
[roi_lfp,roi_resp,cur_level_roi] = save_merge_position(data_dir,label,dates,level,trl_type);
% get number of roi
roi_num=size(cur_level_roi,1);
odor_num=6;
%% power spectrum analysis
spectr_resp=cell(roi_num,odor_num);
spectr_lfp=spectr_resp;
for roi_i=1:roi_num
    for odor_i=1:odor_num
    cur_roi=cur_level_roi{roi_i,1};
    lfp=roi_lfp{roi_i};
    resp=roi_resp{roi_i};
    
    % frequency spectrum
    cfg         = [];
    cfg.output  = 'pow';
    cfg.method  = 'mtmfft';
    cfg.taper   = 'hanning';
    cfg.trials  = find(lfp.trialinfo==odor_i);
    % cfgtf.foi = logspace(log10(1),log10(200),51);
    cfg.foi = 0.1:0.1:10;
    spectr_resp{roi_i,odor_i}  = ft_freqanalysis(cfg, resp);
    spectr_lfp{roi_i,odor_i}  = ft_freqanalysis(cfg, lfp);
    end
end
%% plot
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#000000', '#E12A3C', '#777DDD', '#41AB5D'};
for roi_i=1:roi_num
figure;
hold on;
for odor_i=1:odor_num
%     plot(spectr_resp{roi_i,odor_i}.freq, mean(spectr_resp{roi_i,odor_i}.powspctrm,1),'Color',hex2rgb(colors{odor_i}), 'linewidth', 2)
%     set(gca,'yscale','log');
%     yyaxis right
    plot(spectr_lfp{roi_i,odor_i}.freq, mean(spectr_lfp{roi_i,odor_i}.powspctrm,1),'Color',hex2rgb(colors{odor_i}),'linewidth', 2)
end
set(gca,'yscale','log');
set(gca,'xlim',[0.1 1]);
title(cur_level_roi{roi_i,1})
legend('Ind','Iso_l','Iso_h','Peach','Banana','Air')
xlabel('Frequency (Hz)')
ylabel('Power (\mu V^2)')
end
