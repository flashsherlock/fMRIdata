%% load and reorganize data
monkeys = {'RM035','RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/decoding/tf/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
level = 3;
trl_type = 'odorresp';
odor_num=7;
cp_air = 0;
% time range
time = '-33';
time_range = [-3 3];
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
%% PCA
% load data or analyze data
if exist([pic_dir 'data_pca' time '.mat'],'file')
    load([pic_dir 'data_pca' time '.mat']);
else
    roi_num=size(cur_level_roi,1);
    data_pca=cell(roi_num,3);
    data_pca(:,1)=cur_level_roi(:,2);
    % analyze
    for roi_i=1:roi_num
        cur_roi = cur_level_roi{roi_i,1};
        % label
        label = freq_sep_all{roi_i}.trialinfo;
        % get data
        data = squeeze(freq_sep_all{roi_i}.powspctrm);
        % % remove air
        % label = label(label~=6);
        % data = data(label~=6,:,:);                
        time_idx = dsearchn(freq_sep_all{roi_i}.time', time_range');
        % frequency below 80Hz
        data = data(:,1:42,time_idx(1):time_idx(2));
        % calculate z score
        if cp_air == 1
            data_air = data(label==6,:,:);
            mean_air = mean(data_air);
            std_air = std(data_air);
            data = (data-mean_air)./std_air;
        else
            data = zscore(data,0,1);
        end
        % odor mean
        mean_data = zeros(length(unique(label)),size(data,3),size(data,2));
        mean_label = repmat([1:length(unique(label))]',[1,size(data,3)]);
        for odor_i = 1:length(unique(label))
            mean_data(odor_i,:,:) = squeeze(mean(data(label==odor_i,:,:),1))';
        end
        % store data
        data_pca(roi_i,2:end)={mean_data,mean_label};
    end
save([pic_dir 'data_pca' time '.mat'],'data_pca','cur_level_roi');
end
%% permutated data
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
save([pic_dir 'data_pca_per' time '.mat'],'data_pca_per');