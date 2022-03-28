%% load and reorganize data
m = '2monkey';
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
load([data_dir 'pic/lfp_odorresp/' m '/' 'tf_' m '.mat'])
pic_dir=[data_dir 'pic/pca_power/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% get number of roi
load([data_dir 'pic/trial_count/odor_level3_trial_count_' m '.mat'])
roi_num=size(cur_level_roi,1);
odor_num=7;        
%% parameters
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556',...
    '#000000', '#E12A3C', '#777DDD', '#41AB5D'};  
colors = cellfun(@(x) hex2rgb(x),colors,'UniformOutput',false);
for n_dim=2:3
% init_dim = 30;
% perplex = 10;
% frequency bands left-open right-close
% bands={[0 4],[4 8],[8 13],[13 30],[30 80]};
% data_roi = zeros(roi_num,80);
%% analyze
for roi_i=1:roi_num
    cur_roi = cur_level_roi{roi_i,1};
    % get data
    data = squeeze(freq_sep_all{roi_i}.powspctrm);
    % time range
    time_range = [0 4];
    time_idx = dsearchn(freq_sep_all{roi_i}.time', time_range');
    diff_1s = diff(time_idx)/diff(time_range);
    % frequency below 80Hz
    data = data(:,1:42,time_idx(1):time_idx(2));
    % calculate z score
    data = zscore(data,0,1);
    % label
    label = freq_sep_all{roi_i}.trialinfo;
    % odor mean
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
    [mapped, mapping]= compute_mapping(data,'PCA', size(data,2));
    % get lambda
    mapped = mapped(:,1:n_dim);
    lambda = mapping.lambda;
    % variance explained
    var_exp = lambda ./ sum(lambda);
    var_cum = cumsum(var_exp);
    
    % plot
    p_color = colors(label);
    figure;
    hold on
    for p_i = 1:length(unique(label))
        % 3-d
        if n_dim==3
            scatter3(mapped(label==p_i,1), mapped(label==p_i,2),...
                mapped(label==p_i,3), 15, colors{p_i},'filled');
            zlabel(sprintf('PC3 (%.1f%% of variance)',100*var_exp(3)))
            grid on
            view(3) % view(-37.5,30)
            % view(37.5,30)
        else
            scatter(mapped(label==p_i,1), mapped(label==p_i,2), 15, colors{p_i},'filled');

        end
    end
    xlabel(sprintf('PC1 (%.1f%% of variance)',100*var_exp(1)))
    ylabel(sprintf('PC2 (%.1f%% of variance)',100*var_exp(2)))
    t_range = [num2str(time_range(1)) '-' num2str(time_range(2))  's'];
    title([cur_level_roi{roi_i,1} ' ' t_range])
    legend('Ind','Iso_l','Iso_h','Peach','Banana')    
    saveas(gcf, [pic_dir num2str(n_dim) 'd_' cur_roi '_pca_'  t_range '.png'],'png')
    close all
    
    % line
    % select integer time
    tmp = zeros(size(mean_data,2),1);
%     tmp(1:diff_1s:end)=1;
    % start and end point
    tmp([1 length(tmp)])=1;
    line_idx=kron(tmp,ones(length(unique(label)),1));
    line_data_side = mapped(line_idx==1,:);
    line_label_side = label(line_idx==1);
    
    % smooth data
    smooth_width = 20;
    line_data = reshape(mapped,length(unique(label)),[],n_dim);
    for comp_i = 1:size(line_data,3)
        for odor_i = 1:size(line_data,1)
            line_data(odor_i,:,comp_i) = smooth(line_data(odor_i,:,comp_i),smooth_width);
        end
    end
    line_data = reshape(line_data,[],n_dim);
    line_label = label;
    
    figure;
    hold on
    for p_i = 1:length(unique(line_label))
        side = line_data_side(line_label_side==p_i,:);
        sign = {'o','s'};
        % 3-d
        if n_dim==3                   
            % trajectory
            plot3(line_data(line_label==p_i,1), line_data(line_label==p_i,2),...
                line_data(line_label==p_i,3), 'Color', colors{p_i},'Linewidth',2);
            zlabel(sprintf('PC3 (%.1f%% of variance)',100*var_exp(3)))
            grid on
            view(3) % view(-37.5,30)
            % view(37.5,30)
            
            % start and end point
            for side_i=1:2                
                scatter3(side(side_i,1),side(side_i,2),side(side_i,3),...
                    50, colors{p_i},sign{side_i},'filled','MarkerEdgeColor','black')
            end            
        else            
            % trajectory
            plot(line_data(line_label==p_i,1), line_data(line_label==p_i,2),...
                'Color', colors{p_i},'Linewidth',2);
            % start and end point
            for side_i=1:2                
                scatter(side(side_i,1),side(side_i,2),...
                    50, colors{p_i},sign{side_i},'filled','MarkerEdgeColor','black')
            end
        end
    end
    xlabel(sprintf('PC1 (%.1f%% of variance)',100*var_exp(1)))
    ylabel(sprintf('PC2 (%.1f%% of variance)',100*var_exp(2)))
    title([cur_level_roi{roi_i,1} ' ' t_range])    
    saveas(gcf, [pic_dir num2str(n_dim) 'd_' cur_roi '_pca_line_'  t_range '.png'],'png')
    close all
end
end