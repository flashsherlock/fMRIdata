%% load and reorganize data
m = '2monkey';
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/pic/';
% pic_dir=[data_dir 'powerspec/' m '/'];
% load([pic_dir 'powspec_odor_7s_1_80hz.mat']);
pic_dir=[data_dir 'pic/lfp_odorresp/' m '/'];
load([pic_dir 'tf_' m '.mat'])
% get number of roi
roi_num=size(cur_level_roi,1);
odor_num=7;        
%% parameters
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556',...
    '#000000', '#E12A3C', '#777DDD', '#41AB5D'};  
colors = cellfun(@(x) hex2rgb(x),colors,'UniformOutput',false);
n_dim=2;
init_dim = 30;
perplex = 10;
% frequency bands left-open right-close
% bands={[0 4],[4 8],[8 13],[13 30],[30 80]};
% data_roi = zeros(roi_num,80);
%% analyze
for roi_i=1:roi_num
    % get data
    data = squeeze(freq_sep_all{roi_i}.powspctrm);
    time_range = [0 4];
    time_idx = dsearchn(freq_sep_all{roi_i}.time', time_range');
    diff_1s = diff(time_idx)/diff(time_range);
    data = data(:,:,time_idx(1):time_idx(2));
    % calculate z score
    data = zscore(data,0,1);
    label = freq_sep_all{roi_i}.trialinfo;
    mean_data = zeros(length(unique(label)),size(data,3),size(data,2));
    mean_label = repmat([1:length(unique(label))]',[1,size(data,3)]);
    for odor_i = 1:length(unique(label))
        mean_data(odor_i,:,:) = squeeze(mean(data(label==odor_i,:,:),1))';
    end
    data = reshape(mean_data,[],size(data,2));
    label = reshape(mean_label,[],1);
    % calculate z score
%     data = squeeze(spectr_lfp_all{roi_i}.powspctrm);
%     data = zscore(data,0,1);
%     label = spectr_lfp_all{roi_i}.trialinfo;
    
    % mean zpower for each band
%     zpower = zeros(size(data,1),length(bands));
%     for band_i=1:length(bands)
%         % frequency band
%         band = bands{band_i};
%         idx=spectr_lfp_all{roi_i}.freq>band(1) & spectr_lfp_all{roi_i}.freq<=band(2);
%         % calculate mean zpower
%         zpower(:,band_i) = mean(data(:,idx),2);        
%     end


    % method
%     mapped = compute_mapping(data,'t-SNE', n_dim, init_dim, perplex);
    mapped = compute_mapping(data,'PCA', n_dim);
    
    % plot
    p_color = colors(label);
    figure;
    hold on
    for p_i = 1:length(unique(label))
        if n_dim==3
            scatter3(mapped(label==p_i,1), mapped(label==p_i,2),...
                mapped(label==p_i,3), 15, colors{p_i},'filled');
        else
            scatter(mapped(label==p_i,1), mapped(label==p_i,2), 15, colors{p_i},'filled');

        end
    end
    xlabel('PC1')
    ylabel('PC2')
    title([cur_level_roi{roi_i,1} ' 0-' num2str(time_range(2)) 's'])
    legend('Ind','Iso_l','Iso_h','Peach','Banana')

end