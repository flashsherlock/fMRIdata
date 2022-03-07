%% load and reorganize data
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/powerspec/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% generate data
level = 3;
trl_type = 'odor';
% combine 2 monkeys
% [roi_lfp,roi_resp,cur_level_roi] = save_merge_2monkey(level,trl_type);

% one monkey data
one_data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
label=[one_data_dir 'RM035_datpos_label.mat'];
dates=16;
[roi_lfp,roi_resp,cur_level_roi] = save_merge_position(one_data_dir,label,dates,level,trl_type);

%% parameters 
% number of roi
roi_num=size(cur_level_roi,1);
odor_num=7;
cross_freq_result=cell(roi_num,odor_num);
% filter
latency = [0 8];
freqs=13:1:80;
bandwidth=1;
% modulation index
nbins=20;
nsurrogates=10;
randtype=2; %timesplice
%% cross frequency analysis
for roi_i=1:roi_num
    % select trials
    for odor_i=1:odor_num
        cfg         = [];
        if odor_i==7
            cfg.trials  = find(roi_lfp{roi_i}.trialinfo~=6);
        else
            cfg.trials  = find(roi_lfp{roi_i}.trialinfo==odor_i);
        end
        lfp = ft_selectdata(cfg, roi_lfp{roi_i});
        resp = ft_selectdata(cfg, roi_resp{roi_i});    
        % get low frequency phase and high frequency amplitude
        [xphase, xamp]=get_signal_pa(resp, lfp, latency, freqs, bandwidth);
        % compute modulation index
        cross_freq_result{roi_i,odor_i} = get_mi(xphase,xamp,nbins,nsurrogates,randtype);
    end
end
