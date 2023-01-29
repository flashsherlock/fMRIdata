function data_pca_per = pca_permutation_sep( freq_sep_all, cur_level_roi, time_range, seed )
% return permutated data_pca_tf
    cp_air = 0;
    roi_num = size(cur_level_roi,1);
    rng(seed);
    data_pca_per = cell(roi_num,3);
    % analyze
    for roi_i=1:roi_num
        cur_roi = cur_level_roi{roi_i,2};
        % label
        true_label = freq_sep_all{roi_i}.trialinfo;        
        % get data
        data = squeeze(freq_sep_all{roi_i}.powspctrm);
        time_idx = dsearchn(freq_sep_all{roi_i}.time', time_range');
        % frequency below 80Hz
        data = data(:,1:42,time_idx(1):time_idx(2));
        % calculate z score
        if cp_air == 1
            data_air = data(true_label==6,:,:);
            mean_air = mean(data_air);
            std_air = std(data_air);
            data = (data-mean_air)./std_air;
        else
            data = zscore(data,0,1);
        end
        % shuffle labels for 5 odors
        label = true_label;
        odor_idx = find(label ~= 6);
        label(odor_idx) = label(odor_idx(randperm(length(odor_idx))));
        % odor mean
        mean_data = zeros(length(unique(label)),size(data,3),size(data,2));
        mean_label = repmat([1:length(unique(label))]',[1,size(data,3)]);
        for odor_i = 1:length(unique(label))
            mean_data(odor_i,:,:) = squeeze(mean(data(label==odor_i,:,:),1))';
        end
        % store data
        data_pca_per{roi_i,1} = cur_roi;
        data_pca_per{roi_i,2} = mean_data;
        data_pca_per{roi_i,3} = mean_label;      
    end
end

% test memory usage: do not use parfor!
% parfor i=1:10
%     data_pca_per{i} = pca_permutation_sep( freq_sep_all, cur_level_roi, time_range, i );
% end