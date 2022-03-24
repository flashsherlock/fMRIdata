%% load and reorganize data
m = 'RM033';
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/pic/';
pic_dir=[data_dir 'powerspec/' m '/'];
load([pic_dir 'powspec_odor_7s_1_80hz.mat']);
% load([data_dir 'trial_count/odor_level3_trial_count.mat']);
% get number of roi
roi_num=size(cur_level_roi,1);
odor_num=7;        
%% plot in 2D spaces
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556',...
    '#000000', '#E12A3C', '#777DDD', '#41AB5D'};  
colors = cellfun(@(x) hex2rgb(x),colors,'UniformOutput',false);
n_dim=3;
init_dim = 30;
perplex = 10;
% frequency bands left-open right-close
bands={[0 4],[4 8],[8 13],[13 30],[30 80]};
% data_roi = zeros(roi_num,80);

for roi_i=1:roi_num
    
    % calculate z score
    data = squeeze(spectr_lfp_all{roi_i}.powspctrm);
    data = zscore(data,0,1);
    label = spectr_lfp_all{roi_i}.trialinfo;
    
    % mean zpower for each band
    zpower = zeros(size(data,1),length(bands));
    for band_i=1:length(bands)
        % frequency band
        band = bands{band_i};
        idx=spectr_lfp_all{roi_i}.freq>band(1) & spectr_lfp_all{roi_i}.freq<=band(2);
        % calculate mean zpower
        zpower(:,band_i) = mean(data(:,idx),2);        
    end

    % select abs(zscore)>1
%     a = mean(data,2);
%     data = data(abs(a)>1,1:80);     
%     label = label(abs(a)>1);

    % method
%     mapped = compute_mapping(data,'t-SNE', n_dim, init_dim, perplex);
    mapped = compute_mapping(data,'PCA', n_dim);
    
    % select mapped data
%     mapped = zscore(mapped,0,1);
%     mapped = mapped(:,1:3);
    
    % plot
    p_color = colors(label);
    figure;
    hold on
    for p_i = 1:length(unique(label))-1
        if n_dim==3
            scatter3(mapped(label==p_i,1), mapped(label==p_i,2),...
                mapped(label==p_i,3), 15, colors{p_i},'filled');
        else
            scatter(mapped(label==p_i,1), mapped(label==p_i,2), 15, colors{p_i},'filled');

        end
    end
    title(cur_level_roi{roi_i,1})
    legend('Ind','Iso_l','Iso_h','Peach','Banana')
end