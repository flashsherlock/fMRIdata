%% load and reorganize data
m = '2monkey';
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/pca_power/noair/' m '/iso/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% time range
time_range = [0 3];
t_range = [num2str(time_range(1)) '-' num2str(time_range(2)) 's'];
% load data or analyze data
load([pic_dir '../data_pca.mat']);
%% plot
% parameters
colors = {'#69b4d9', '#149ade'};  
colors = cellfun(@(x) hex2rgb(x),colors,'UniformOutput',false);
roi_num = size(data_pca,1);
dims = 2;
% odor distance
dis_num = 1;
dis_time = cell(roi_num,length(dims));
dis_mean = zeros(roi_num,dis_num,length(dims));
for dim_i=1:length(dims)
    n_dim = dims(dim_i);
for roi_i=1:roi_num
    cur_roi = data_pca{roi_i,1};
    mean_label = data_pca{roi_i,3};
    mean_data = data_pca{roi_i,2};
    % iso only
    mean_label = mean_label(2:3,:);
    mean_data = mean_data(2:3,:,:);
    % reshape
    data = reshape(mean_data,[],size(mean_data,3));
    label = reshape(mean_label,[],1)-1;
    % method
%     mapped = compute_mapping(data,'t-SNE', n_dim, init_dim, perplex);
    [mapped, mapping]= compute_mapping(data,'PCA', size(data,2));
    % get lambda
    mapped = mapped(:,1:n_dim);
    lambda = mapping.lambda;
    % variance explained
    var_exp = lambda ./ sum(lambda);
    var_cum = cumsum(var_exp);
    
    % plot weights
    figure('Renderer','Painters')
    hold on
    freq = logspace(log10(1),log10(200),51);
    x = freq(1:size(mapping.M,1));
    plot(x,mapping.M(:,1:n_dim),'Linewidth',2)
    plot(x,zeros(length(x),1),'--k','Linewidth',1)
    set(gca,'Xlim',[x(1) x(end)])
    legend(strcat({'PC'},cellstr(num2str((1:n_dim)'))))
    xlabel('Frequency')
    ylabel('Weights')
    title([cur_roi ' ' t_range])   
    set(gca,'FontSize',18);
    saveas(gcf, [pic_dir num2str(n_dim) 'd_wei' cur_roi '_pca_'  t_range '.png'],'png')
    saveas(gcf, [pic_dir num2str(n_dim) 'd_wei' cur_roi '_pca_'  t_range '.svg'],'svg')
    
    % scatter plot
    p_color = colors(label);
    p_size = 30;
    figure('Renderer','Painters');
    hold on
    for p_i = 1:length(unique(label))
        % 3-d
        if n_dim==3
            scatter3(mapped(label==p_i,1), mapped(label==p_i,2),...
                mapped(label==p_i,3), p_size, colors{p_i},'filled');
            zlabel(sprintf('PC3 (%.1f%% of variance)',100*var_exp(3)))
            grid on
            view(3) % view(-37.5,30)
            % view(37.5,30)
        else
            scatter(mapped(label==p_i,1), mapped(label==p_i,2), p_size, colors{p_i},'filled');

        end
    end
    xlabel(sprintf('PC1 (%.1f%% of variance)',100*var_exp(1)))
    ylabel(sprintf('PC2 (%.1f%% of variance)',100*var_exp(2)))    
    title([cur_roi ' ' t_range])
    legends = {'Iso_l', 'Iso_h'};
    legend(legends(1:length(unique(label))),'location','eastoutside')
    set(gca,'FontSize',18);
    saveas(gcf, [pic_dir num2str(n_dim) 'd_' cur_roi '_pca_'  t_range '.png'],'png')
    saveas(gcf, [pic_dir num2str(n_dim) 'd_' cur_roi '_pca_'  t_range '.svg'],'svg')
    close all
    
    % line plot
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
    
    figure('Renderer','Painters');
    hold on
    for p_i = 1:length(unique(line_label))
        side = line_data_side(line_label_side==p_i,:);
        p_sign = {'o','s'};
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
                    50, colors{p_i},p_sign{side_i},'filled','MarkerEdgeColor','black')
            end            
        else            
            % trajectory
            plot(line_data(line_label==p_i,1), line_data(line_label==p_i,2),...
                'Color', colors{p_i},'Linewidth',2);
            % start and end point
            for side_i=1:2                
                scatter(side(side_i,1),side(side_i,2),...
                    50, colors{p_i},p_sign{side_i},'filled','MarkerEdgeColor','black')
            end
        end
    end
    xlabel(sprintf('PC1 (%.1f%% of variance)',100*var_exp(1)))
    ylabel(sprintf('PC2 (%.1f%% of variance)',100*var_exp(2)))
    title([cur_roi ' ' t_range])    
    set(gca,'FontSize',18);
    saveas(gcf, [pic_dir num2str(n_dim) 'd_' cur_roi '_pca_line_'  t_range '.png'],'png')
    saveas(gcf, [pic_dir num2str(n_dim) 'd_' cur_roi '_pca_line_'  t_range '.svg'],'svg')
    close all    
    
    % calculate mean distance    
    dis_data = reshape(mapped,length(unique(label)),[],n_dim);    
    % smoothed data
    % dis_data = reshape(line_data,length(unique(label)),[],n_dim);    
    dis_time_roi = zeros(size(dis_data,2),dis_num);
    for time_i = 1:size(dis_data,2)
        tmp = squeeze(dis_data(:,time_i,:));
        % mean distance between iso_h and iso_l
        dis_time_roi(time_i, 1) = pdist2(tmp(1, :), tmp(2, :));
        
    end
    dis_time{roi_i,dim_i} = dis_time_roi;
    
    % mean distance
    tmp = squeeze(mean(dis_data,2));
    % mean distance between iso_h and iso_l
    dis_mean(roi_i, 1, dim_i) = pdist2(tmp(1, :), tmp(2, :));    
end
end
%% plot distance
cmap = hsv(roi_num);
figure('Renderer','Painters')
hold on
for roi_i=1:roi_num
    tmp = dis_time{roi_i,1}(:,1);%+roi_i*0.1;
    plot(linspace(time_range(1),time_range(2),length(tmp)),tmp,'Color',cmap(roi_i,:),'Linewidth',2)
end
xlabel('time')
ylabel('Distance between Iso_l and Iso_h')
set(gca,'FontSize',18);
title(['Mean_distance ',t_range],'Interpreter','none')
legend(data_pca(:,1),'location','best')
saveas(gcf, [pic_dir 'Mean_int_dist_roi.png'],'png')
saveas(gcf, [pic_dir 'Mean_int_dist_roi.svg'],'svg')
close all
% mean distance
figure('Renderer','Painters')
hold on
for dim_i=1%:2
    tmp = dis_mean(:,1,dim_i);
    plot(1:roi_num, tmp, 'Color',hex2rgb('#0072BD'), 'Linewidth', 2)
end
xlabel('ROI')
ylabel('Distance between Iso_l and Iso_h')
set(gca,'XTick',1:size(data_pca,1),'xlim',[1 size(data_pca,1)])
set(gca,'XTickLabel',data_pca(:,1))
set(gca,'FontSize',18);
title(['Mean_distance' ' ' t_range],'Interpreter','none')   
saveas(gcf, [pic_dir 'Mean_int_dist'  t_range '.png'],'png')
saveas(gcf, [pic_dir 'Mean_int_dist'  t_range '.svg'],'svg')
close all
% dendrogram can not be saved as nomal plot
% cgo=clustergram(data,'Colormap',jet,'Annotate',false);
% plot(cgo)