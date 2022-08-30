function pca_permutation(monkeys, seed)
% generate mean time frequency data after shuffling labels
% random seed
if nargin<2
    seed = 100;
end
rng(seed);
% whether zscore to air
cp_air = 1;
% monkeys = {'RM033','RM035','2monkey'};
for m_i = 1:length(monkeys)
    % load and reorganize data
    m = monkeys{m_i};
    data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
    pic_dir=[data_dir 'pic/pca_power/noair/' m '_air/'];
    % time range
    time_range = [0 3];
    % load data or analyze data
    load([data_dir 'tf_level5_' m '.mat'],'freq_sep_all')
    load([data_dir 'pic/trial_count/odorresp_level5_trial_count_' m '.mat'],'cur_level_roi')
    roi_num=size(cur_level_roi,1);
    % number of permutation
    per_num = 1000;
    data_pca_per = cell(per_num,1);
    % initiate empty data
    for per_i = 1:per_num
        data_pca_per{per_i} = cell(roi_num,3);        
    end           
    % analyze
    for roi_i=1:roi_num
        cur_roi = cur_level_roi{roi_i,1};
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
        parfor per_i = 1:per_num
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
            data_pca_per{per_i}{roi_i,1} = cur_roi;
            data_pca_per{per_i}{roi_i,2} = mean_data;
            data_pca_per{per_i}{roi_i,3} = mean_label;
        end        
    end
    save([pic_dir 'data_pca_per.mat'],'data_pca_per');
end