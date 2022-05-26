%% load and reorganize data
m = 'RM033';
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/pic/';
pic_dir=[data_dir 'powerspec/' m '/'];
load([pic_dir 'powspec_odor_7s_1_80hz.mat']);
% load([data_dir 'trial_count/odor_level3_trial_count.mat']);
% get number of roi
roi_num=size(cur_level_roi,1);
odor_num=7;
%% average each condition (same as roi_powspec)
spectr_resp=cell(roi_num,odor_num);
spectr_lfp=spectr_resp;
% zscore
spectr_respz=cell(roi_num,odor_num);
spectr_lfpz=spectr_respz;
for roi_i=1:roi_num
    for odor_i=1:odor_num
        lfp = spectr_lfp_all{roi_i};
        % frequency spectrum
        cfg         = [];
        cfg.avgoverrpt =  'yes';
        if odor_i==7
            cfg.trials  = find(lfp.trialinfo~=6);
        else
            cfg.trials  = find(lfp.trialinfo==odor_i);
        end
        spectr_lfp{roi_i,odor_i} = ft_selectdata(cfg, lfp);
        % zscore
        lfp.powspctrm = zscore(lfp.powspctrm,0,1);
        spectr_lfpz{roi_i,odor_i} = ft_selectdata(cfg, lfp);
    end
end
%% calculate mean zpower for each condition
% left-open right-close
bands={[0 4],[4 8],[8 13],[13 30],[30 50],[50 80],[30 80]};
zpower=zeros(roi_num,odor_num,length(bands));
for roi_i=1:roi_num
    for odor_i=1:odor_num
        for band_i=1:length(bands)
            % frequency band
            band = bands{band_i};
            idx=spectr_lfpz{roi_i,odor_i}.freq>band(1) & spectr_lfpz{roi_i,odor_i}.freq<=band(2);
            power = spectr_lfpz{roi_i,odor_i}.powspctrm;
            % calculate mean zpower
            zpower(roi_i,odor_i,band_i) = mean(power(idx));        
        end
    end
end
%% reorganize data
switch m
case '2monkey'
    roi_select=[8 4 5 10 13 3 9 2 1 12 6 7 11];
case 'RM033'
    roi_select=[8 4 5 10 12 3 9 2 1 6 7 11];    
case 'RM035'
    roi_select=[5 2 3 10 7 6 1 9 4 8];
end
rois=cur_level_roi(:,1);
rois=rois(roi_select);
zpower=zpower(roi_select,:,:);
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#000000', '#E12A3C', '#777DDD', '#41AB5D'};
colors_cp = colors([1:5 7]);
save([pic_dir 'zpower_7s_1_80hz.mat'],'zpower','rois');
%% plot mean zpower
for band_i=1:length(bands)
    figure('position',[20,20,900,450])
    b=bar(zpower(:,[1:6],band_i));
    for i=1:6
        b(i).FaceColor = hex2rgb(colors{i});
    end
    band=bands{band_i};
    title(['frequency: ' num2str(band) ' Hz'])
    xlabel('ROI')
    ylabel('Zpower')
    legend('Ind','Iso_l','Iso_h','Peach','Banana','Air','Location','eastoutside')
    set(gca,'XTickLabel',rois)
    set(gca,'FontSize',18);
    % save plot
    saveas(gcf, [pic_dir  'band_' num2str(band(1)) '-' num2str(band(2)) 'Hz', '.png'], 'png')
    close all
end