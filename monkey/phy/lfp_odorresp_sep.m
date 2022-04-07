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
%% generate data
level = 3;
trl_type = 'odorresp';
% combine 2 monkeys
[roi_lfp,roi_resp,cur_level_roi] = save_sep_2monkey(level,trl_type,monkeys);
% get number of positions
roi_num=size(cur_level_roi,1);
odor_num=7;
%% TF analysis
if exist([data_dir 'tf_sep_' m '.mat'],'file')
    load([data_dir 'tf_sep_' m '.mat'])
else
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
dims = 2:3;
dis_time = cell(roi_num,2);
dis_mean = zeros(roi_num,5,2);
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
            % 6 condition
            dis_time_roi(time_i,1) = mean(pdist(tmp));
            % mean distance to air        
            dis_time_roi(time_i,2) = mean(pdist2(tmp(end,:),tmp(1:end-1,:)));
            % mean distance between pleasant and unpleasant
            dis_time_roi(time_i,3) = mean(mean(pdist2(tmp(1:3,:),tmp(4:5,:))));        
        end
        dis_time{roi_i,dim_i} = dis_time_roi;

        % mean distance
        tmp = squeeze(mean(dis_data,2));
        % 6 condition
        dis_mean(roi_i,1,dim_i) = mean(pdist(tmp));
        % mean distance to air        
        dis_mean(roi_i,2,dim_i) = mean(pdist2(tmp(end,:),tmp(1:end-1,:)));
        % mean distance between pleasant and unpleasant
        dis_mean(roi_i,3,dim_i) = mean(mean(pdist2(tmp(1:3,:),tmp(4:5,:))));
        % mean distance to air (odor mean first)       
        dis_mean(roi_i,4,dim_i) = pdist2(tmp(end,:),mean(tmp(1:end-1,:)));
        % mean distance between pleasant and unpleasant(odor mean first)
        dis_mean(roi_i,5,dim_i) = pdist2(mean(tmp(1:3,:)),mean(tmp(4:5,:)));
    end
end
save([pic_dir 'dis_sep_' m '.mat'],'dis_mean','cur_level_roi','dis_time')

%% scatter plot in 3d space
% load([pic_dir 'dis_sep_' m '.mat'])
distance={'6condition','odor-air','valence','mean-odor-air','mean-valence'};
for dis=1:5
plot_data = cell2mat(cur_level_roi(:,1));
color_data = dis_mean(:,dis,1);
% find the index of two monkeys
monkey_35 = find(strcmp(cur_level_roi(:,3),'RM035'));
monkey_33 = find(strcmp(cur_level_roi(:,3),'RM033'));
% demean y and z for each monkey
plot_data(monkey_35,2:3) = plot_data(monkey_35,2:3) - mean(plot_data(monkey_35,2:3))+5;
plot_data(monkey_33,2:3) = plot_data(monkey_33,2:3) - mean(plot_data(monkey_33,2:3))-5;
% demean x for each monkey
plot_data(monkey_35,1) = plot_data(monkey_35,1) - mean(plot_data(monkey_35,1))+5;
plot_data(monkey_33,1) = plot_data(monkey_33,1) - mean(plot_data(monkey_33,1))-5;
% calculate zscore color for each monkey
color_data(monkey_35) = zscore(color_data(monkey_35));
color_data(monkey_33) = zscore(color_data(monkey_33));
% scatter3 plot plot_data and use color_data to color
figure
scatter3(plot_data(:,1),plot_data(:,2),plot_data(:,3),25,color_data,'filled')
% set colorscale
set(gca,'clim',[-2 2],'FontSize',18)
colormap jet
ylabel(colorbar,'Z-distance')
xlabel('x')
ylabel('y')
zlabel('z')
view(66,22)%37.5,30
title(distance{dis})
end