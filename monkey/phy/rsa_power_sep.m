%% load and reorganize data
monkeys = {'RM035','RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/ras_power/'];
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
if exist([pic_dir 'dis_sep_rsa.mat'],'file')
    load([pic_dir 'dis_sep_rsa.mat'])
else
    dis_mean = zeros(roi_num,10,3);
    % 1-no pca, 2 and 3 pca dimension
    for dim_i=1:3
        for roi_i=1:roi_num
            cur_roi = cur_level_roi{roi_i,1};
            % get data
            data = squeeze(freq_sep_all{roi_i}.powspctrm);
            % time range
            time_range = [0 3];
            t_range = [num2str(time_range(1)) '-' num2str(time_range(2)) 's'];
            time_idx = dsearchn(freq_sep_all{roi_i}.time', time_range');
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
            % pca or not
            if dim_i ~= 1
                % method
                % mapped = compute_mapping(data,'t-SNE', n_dim, init_dim, perplex);
                [mapped, mapping]= compute_mapping(data,'PCA', size(data,2));   
                mapped = mapped(:,1:dim_i);
                % reshape to odor by time&dim    
                dis_data = reshape(mapped,length(unique(label)),[]);
            else
                dis_data = reshape(data,length(unique(label)),[]);
            end
            % remove air
            dis_data = dis_data(1:end-1,:);
            % distance matrix
            % dis = 'euclidean';
            dis = 'correlation';
            cur_dis = pdist2(dis_data,dis_data,dis);
            dis_mean(roi_i,:,dim_i) = cur_dis(triu(true(size(cur_dis)), 1));
        end
    end
    save([pic_dir 'dis_sep_rsa.mat'],'dis_mean','cur_level_roi')
end