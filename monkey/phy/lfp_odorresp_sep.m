%% load and reorganize data
monkeys = {'RM035','RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/lfp_sep/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
level = 3;
trl_type = 'odorresp';
odor_num=7;
%% load data or generate data
if exist([data_dir 'tf_sep_' m '.mat'],'file')
    load([data_dir 'tf_sep_' m '.mat'])
    % get number of positions
    roi_num=size(cur_level_roi,1);
else
    % combine 2 monkeys
    [roi_lfp,roi_resp,cur_level_roi] = save_sep_2monkey(level,trl_type,monkeys);
    % get number of positions
    roi_num=size(cur_level_roi,1);    
    % TF analysis
    freq_sep_all=cell(roi_num,1);
    for roi_i=1:roi_num
        cur_roi=cur_level_roi{roi_i,1};
        % filt data
        cfg=[];
        cfg.bsfilter    = 'yes';
        cfg.bsfilttype = 'fir';
        cfg.bsfreq      = [99 101;149 151;199 201];
        lfp = ft_preprocessing(cfg,roi_lfp{roi_i});
        % time frequency analysis
        cfgtf=[];
        cfgtf.method     = 'mtmconvol';
        cfgtf.toi        = -3.5:0.05:9.5;
        % cfgtf.foi        = 1:1:100;
        % other wavelet parameters
        cfgtf.foi = logspace(log10(1),log10(200),51);
        % cfgtf.t_ftimwin  = ones(length(cfgtf.foi),1).*0.5;
        cfgtf.t_ftimwin  = 5./cfgtf.foi;
        cfgtf.taper      = 'hanning';
        cfgtf.output     = 'pow';
        cfgtf.keeptrials = 'yes';
        freq_sep_all{roi_i} = ft_freqanalysis(cfgtf, lfp);
    end
    save([data_dir 'tf_sep_' m '.mat'],'freq_sep_all','cur_level_roi','-v7.3')
end
%% analyze mean distance
if exist([pic_dir 'dis_sep_' m '.mat'],'file')
    load([pic_dir 'dis_sep_' m '.mat'])
else
    dims = 2:3;
    dis_time = cell(roi_num,2);
    dis_mean = zeros(roi_num,6,2);
    % 2 and 3 dimension
    for dim_i=1:2
        n_dim = dims(dim_i);
        for roi_i=1:roi_num
            cur_roi = cur_level_roi{roi_i,1};
            % get data
            data = squeeze(freq_sep_all{roi_i}.powspctrm);
            % time range
            time_range = [0 3];
            t_range = [num2str(time_range(1)) '-' num2str(time_range(2)) 's'];
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

            % method
        %     mapped = compute_mapping(data,'t-SNE', n_dim, init_dim, perplex);
            [mapped, mapping]= compute_mapping(data,'PCA', size(data,2));
            % get lambda
            mapped = mapped(:,1:n_dim);
            lambda = mapping.lambda;
            % variance explained
            var_exp = lambda ./ sum(lambda);
            var_cum = cumsum(var_exp);   

            % calculate mean distance    
            dis_data = reshape(mapped,length(unique(label)),[],n_dim);    
            % smoothed data
            % smooth_width = 20;
            % line_data = reshape(mapped,length(unique(label)),[],n_dim);
            % for comp_i = 1:size(line_data,3)
            %     for odor_i = 1:size(line_data,1)
            %         line_data(odor_i,:,comp_i) = smooth(line_data(odor_i,:,comp_i),smooth_width);
            %     end
            % end
            % line_data = reshape(line_data,[],n_dim);
            % dis_data = reshape(line_data,length(unique(label)),[],n_dim);    
            dis_time_roi = zeros(size(dis_data,2),3);
            for time_i = 1:size(dis_data,2)
                tmp = squeeze(dis_data(:,time_i,:));
                % 5 condition
                dis_time_roi(time_i, 1) = mean(pdist(tmp(1:5,:)));
                % conbine iso_h and iso_l        
                dis_time_roi(time_i, 2) = mean(pdist([tmp(1, :);mean(tmp(2:3,:));tmp(4:5,:)]));
                % mean distance between pleasant and unpleasant(odor mean first)
                dis_time_roi(time_i, 3) = pdist2(mean(tmp(1:3,:)),mean(tmp(4:5,:)));   
                % mean distance between iso_h and iso_l
                dis_time_roi(time_i, 4) = pdist2(tmp(2, :), tmp(3, :));        
            end
            dis_time{roi_i,dim_i} = dis_time_roi;

            % mean distance
            tmp = squeeze(mean(dis_data,2));
            % 5 condition
            dis_mean(roi_i, 1, dim_i) = mean(pdist(tmp(1:5,:)));
            % combine iso_h and iso_l
            dis_mean(roi_i, 2, dim_i) = mean(pdist([tmp(1, :); mean(tmp(2:3, :)); tmp(4:5, :)]));
            % mean distance between pleasant and unpleasant(odor mean first)
            dis_mean(roi_i, 3, dim_i) = pdist2(mean(tmp(1:3,:)),mean(tmp(4:5,:)));
            % mean distance between iso_h and iso_l
            dis_mean(roi_i, 4, dim_i) = pdist2(tmp(2, :), tmp(3, :));
        end
    end
    save([pic_dir 'dis_sep_' m '.mat'],'dis_mean','cur_level_roi','dis_time')
end
%% scatter plot in 3d space
% load cur_level_roi
% load([data_dir 'tf_sep_' m '.mat'],'cur_level_roi')
distance = {'odor5','odor4','valence','intensity'};
plot_data = cell2mat(cur_level_roi(:,1));
% deal with some strange points
plot_data(346,2)=plot_data(346,2)-0.001;
plot_data(414,1)=plot_data(414,1)-0.001;
for monkey_i=1:2
    % find the index of two monkeys
    monkey = find(strcmp(cur_level_roi(:,3),monkeys{monkey_i}));
    
    % apply transformation
    file_dir = [data_dir '../IMG/' monkeys{monkey_i}];   
    if ~exist([file_dir '_2NMT_WARP.nii.gz'],'file')
        cmd=['3dNwarpCat -warp1 ' file_dir '_anat_shft_WARP.nii.gz'...
            ' -warp2 ' file_dir '_anat_composite_linear_to_template.1D'...
            ' -prefix ' file_dir '_2NMT_WARP.nii.gz'];
        unix(cmd);
    end
    infile = [file_dir '_elec_LPI.1D'];
    outfile = [file_dir '_elec_STD.1D'];
    % if outfile does not exist
    if ~exist(outfile,'file')
        warp = ['' file_dir '_2NMT_WARP.nii.gz' ''];
        dlmwrite(infile,[-1 -1 1].*plot_data(monkey,:),'delimiter',' ');
        cmd = ['3dNwarpXYZ -nwarp ' warp ' -iwarp ' infile ' > ' outfile];
        unix(cmd);
    else
        plot_data(monkey,:) = [-1 -1 1].*dlmread(outfile);
    end
    
    % apply transformation
%     file = dir([data_dir '../IMG/' monkeys{monkey_i} '*template.1D']);
%     x = dlmread([file.folder filesep file.name]);
%     trans = inv(spm_matrix(x(:)'));
%     A=[1 1 -1 -1;1 1 -1 -1;-1 -1 1 1;1 1 1 1];
%     trans = trans.*A;
%     plot_data(monkey,:)=ft_warp_apply(trans, plot_data(monkey,:), 'homogenous');

    % % demean y and z for each monkey
    % plot_data(monkey,2:3) = plot_data(monkey,2:3) - mean(plot_data(monkey,2:3))+10*(1.5-monkey_i);
    % % demean x for each monkey
    % plot_data(monkey,1) = plot_data(monkey,1) - mean(plot_data(monkey,1))+10*(1.5-monkey_i);

end
%% get and normalize distance data
dis_data = plot_data;
for dis=[1 3 4]
    % get distance
    color_data = dis_mean(:,dis,1);
    % normalization for each monkey
    figure
    for monkey_i=1:2    
        % find the index of two monkeys
        monkey = find(strcmp(cur_level_roi(:,3),monkeys{monkey_i}));        
        subplot(2,2,monkey_i)
        hist(color_data(monkey))
        title([monkeys{monkey_i} '-' distance{dis}])
        % calculate zscore color
%         color_data(monkey) = zscore(color_data(monkey));
        % min-max normalization
        color_data(monkey) = (color_data(monkey)-min(color_data(monkey)))/(max(color_data(monkey))-min(color_data(monkey)));
        subplot(2,2,2+monkey_i)
        hist(color_data(monkey))
        title([monkeys{monkey_i} '-normalized-' distance{dis}])       
    end
    % output to dis_data matrix
    dis_data = [dis_data color_data];
    % output data to csv
    file_dir = [data_dir '../IMG/']; 
    outfile = [file_dir '2m_' distance{dis} '.csv'];
    dlmwrite(outfile,[plot_data color_data],'delimiter',',');
end
%% correlation between x,y,z and distances
xl = {'x','y','z'};
yl = distance([1 3 4]);
monkeys = {'RM033','RM035','2m'};
for m = 1:length(monkeys)
    figure('position',[20,450,900,800],'Renderer','Painters');
    % change x to abs(x)
    dis_data_select = dis_data;
    % select roi
%     index = ~ismember(cur_level_roi(:,2),{'Hi','S'});
%     dis_data_select = dis_data_select(index,:);
    switch monkeys{m}
        case 'RM033'
            dis_data_select = dis_data_select(dis_data_select(:,1)<0,:);
        case 'RM035'
            dis_data_select = dis_data_select(dis_data_select(:,1)>0,:);
    end
    dis_data_select(:,1) = abs(dis_data_select(:,1));
    % plot 3 coords
    coord = 3;
    for dis=1:3
        for j=1:coord
            % get data
            x = dis_data_select(:,j);
            y = dis_data_select(:,3+dis);
            % correlation
            [r,p]=corr(x,y);
            % scatter plot
            subplot(3,coord,(dis-1)*coord+j);
            scatter(x,y,'.')
            % add regression line
            hold on
            pfit = polyfit(x, y, 1);
            ycalc = polyval(pfit, x);
            plot(x,ycalc,'k')
            % add r and p values
            xlabel(xl(j))
            ylabel(yl(dis))
            set(gca,'ylim',[0 1],'xlim',[min(x)-1 max(x)+1],'FontSize',18);
            text(min(x),0.9,[sprintf('r=%0.2f, p=%0.3f',round(r,2),round(p,3))],'Fontsize',18)
        end
    end
    saveas(gcf, [pic_dir 'corr_' monkeys{m} '.svg'],'svg')
    close all
end
%% plot each distance
file_dir = [data_dir '../IMG/'];
right_AH = ft_read_headshape([file_dir 'right_AH_level5.stl'],'format','stl');
right_AH.coordsys = 'acpc';
left_AH = ft_read_headshape([file_dir 'left_AH_level5.stl'],'format','stl');
left_AH.coordsys = 'acpc';
meshcolor = 0.75*[1 1 1];
meshalpha = 0.2; 
for dis=4:5
    for plot_i = 1:2
        % scatter3 plot plot_data and use color_data to color
        figure
        hold on    
        ft_plot_mesh(right_AH,'facecolor',meshcolor,'facealpha',meshalpha);
        if plot_i == 2
            % separate left and right
            ft_plot_mesh(left_AH,'facecolor',meshcolor,'facealpha',meshalpha);
            scatter3(plot_data(:,1),plot_data(:,2),plot_data(:,3),25,color_data,'filled')
        else
            % flip RM033 to right side
            scatter3(abs(plot_data(:,1)),plot_data(:,2),plot_data(:,3),25,color_data,'filled')
        end
        % set colorscale
        set(gca,'clim',[-1.5 1.5],'FontSize',18)
%         set(gca,'clim',[0 1],'FontSize',18)
%         set(gca,'xlim',[-15 15],'ylim',[10 25],'zlim',[0 10])
        colormap(bluered(1000))
%         colors = hot(1000);
%         index = [kron(1:100,ones(1,2)) 101:201 kron(201:2:400,ones(1,2)) ones(1,400)*401];
%         colormap(colors(index,:))
%         ylabel(colorbar,'normalized-distance')
        ylabel(colorbar,'Z-distance')
        xlabel('x')
        ylabel('y')
        zlabel('z')
        view(125,30)%37.5,30
        title(distance{dis})
        saveas(gcf, [pic_dir num2str(plot_i) 'side_Zmesh_'  distance{dis} '.png'],'png')
        saveas(gcf, [pic_dir num2str(plot_i) 'side_Zmesh_'  distance{dis} '.fig'],'fig')
    end
end