%% load and reorganize data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/powerspec/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% generate data
level = 3;
trl_type = 'odor';
% label=[data_dir 'RM033_datpos_label.mat'];
% dates=1:23;
% [roi_lfp,roi_resp,cur_level_roi] = save_merge_position(data_dir,label,dates,level,trl_type);

% combine 2 monkeys
[roi_lfp,roi_resp,cur_level_roi] = save_merge_2monkey(level,trl_type);

% get number of roi
roi_num=size(cur_level_roi,1);
odor_num=7;
%% power spectrum analysis
spectr_resp_all=cell(roi_num,1);
spectr_lfp_all=spectr_resp_all;
for roi_i=1:roi_num
    lfp=roi_lfp{roi_i};
    resp=roi_resp{roi_i};
    % select time
    cfg         = [];
    cfg.latency = [0 8];
    lfp=ft_selectdata(cfg, lfp);
    resp=ft_selectdata(cfg, resp);
    % frequency spectrum
    cfg         = [];
    cfg.output  = 'pow';
    cfg.method  = 'mtmfft';
    cfg.taper   = 'hanning';
    cfg.keeptrials = 'yes';
    cfg.foilim = [0.1 80];
    spectr_resp_all{roi_i}  = ft_freqanalysis(cfg, resp);
    spectr_lfp_all{roi_i}  = ft_freqanalysis(cfg, lfp);
end
%% average each condition
spectr_resp=cell(roi_num,odor_num);
spectr_lfp=spectr_resp;
for roi_i=1:roi_num
    for odor_i=1:odor_num
        lfp = spectr_lfp_all{roi_i};
        resp = spectr_resp_all{roi_i};
        % frequency spectrum
        cfg         = [];
        cfg.avgoverrpt =  'yes';
        if odor_i==7
            cfg.trials  = find(lfp.trialinfo~=6);
        else
            cfg.trials  = find(lfp.trialinfo==odor_i);
        end
        spectr_resp{roi_i,odor_i} = ft_selectdata(cfg, resp);
        spectr_lfp{roi_i,odor_i} = ft_selectdata(cfg, lfp);
    end
end
%% zscore
spectr_respz=cell(roi_num,odor_num);
spectr_lfpz=spectr_respz;
for roi_i=1:roi_num
    for odor_i=1:odor_num
        lfp = spectr_lfp_all{roi_i};
        lfp.powspctrm = zscore(lfp.powspctrm,0,1);
        resp = spectr_resp_all{roi_i};
        resp.powspctrm = zscore(resp.powspctrm,0,1);
        % frequency spectrum
        cfg         = [];
        cfg.avgoverrpt =  'yes';
        if odor_i==7
            cfg.trials  = find(lfp.trialinfo~=6);
        else
            cfg.trials  = find(lfp.trialinfo==odor_i);
        end
        spectr_respz{roi_i,odor_i} = ft_selectdata(cfg, resp);
        spectr_lfpz{roi_i,odor_i} = ft_selectdata(cfg, lfp);
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
set(gca,'xlim',[4 40]);
title(cur_level_roi{roi_i,1})
legend('Ind','Iso_l','Iso_h','Peach','Banana','Air','Odor')
xlabel('Frequency (Hz)')
ylabel('Power (\mu V^2)')
end
%% plot zscore
for roi_i=1:roi_num
figure;
hold on;
for odor_i=1:odor_num
    plot(spectr_lfpz{roi_i,odor_i}.freq, smooth(mean(spectr_lfpz{roi_i,odor_i}.powspctrm,1),32),'Color',hex2rgb(colors{odor_i}),'linewidth', 2)
end
set(gca,'xlim',[1 75]);
title(cur_level_roi{roi_i,1})
legend('Ind','Iso_l','Iso_h','Peach','Banana','Air','Odor')
xlabel('Frequency (Hz)')
ylabel('ZPower')
saveas(gcf, [pic_dir cur_level_roi{roi_i,1} '-zpower', '.fig'], 'fig')
saveas(gcf, [pic_dir cur_level_roi{roi_i,1} '-zpower', '.png'], 'png')
close all
end
% save([data_dir 'powspec_odor_8s_0.1_80hz.mat'],'spectr_lfp','spectr_resp')
% save([data_dir 'level3_position_2monkey.mat'],'cur_level_roi');