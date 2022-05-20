%% load and reorganize data
m = 'RM035';
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
load([data_dir 'tf_' m '.mat'])
pic_dir=[data_dir 'pic/cluster_power/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% get number of roi
load([data_dir 'pic/trial_count/odor_level3_trial_count_' m '.mat'])
roi_num=size(cur_level_roi,1);
odor_num=7;        
% parameters
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556',...
    '#000000', '#E12A3C', '#777DDD', '#41AB5D'};  
colors = cellfun(@(x) hex2rgb(x),colors,'UniformOutput',false);

% frequency bands left-open right-close
bands={[0 4],[4 8],[8 13],[13 30],[30 80]};

%% analyze
for roi_i=1:roi_num
    cur_roi = cur_level_roi{roi_i,1};
    % label
    label = freq_sep_all{roi_i}.trialinfo;
    % get data
    data = squeeze(freq_sep_all{roi_i}.powspctrm);
    % % remove air
    % label = label(label~=6);
    % data = data(label~=6,:,:);
    % time range
    time_range = [0 3];
    t_range = [num2str(time_range(1)) '-' num2str(time_range(2)) 's'];
    time_idx = dsearchn(freq_sep_all{roi_i}.time', time_range');
    diff_1s = diff(time_idx)/diff(time_range);
    % frequency below 80Hz
    data = data(:,1:42,time_idx(1):time_idx(2));
    % calculate z score
    data = zscore(data,0,1);
    % odor mean
    mean_data = zeros(length(unique(label)),size(data,3),size(data,2));
    mean_label = repmat([1:length(unique(label))]',[1,size(data,3)]);
    for odor_i = 1:length(unique(label))
        mean_data(odor_i,:,:) = squeeze(mean(data(label==odor_i,:,:),1))';
    end
    % remove air
    mean_label = mean_label(1:end-1,:);
    mean_data = mean_data(1:end-1,:,:);
    % reshape
    data = reshape(mean_data,[],size(data,2));
    label = reshape(mean_label,[],1);
    
    cgo=clustergram(data,'Colormap',jet,'Annotate',false);
    plot(cgo)

end