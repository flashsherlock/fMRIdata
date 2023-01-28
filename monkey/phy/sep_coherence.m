%% load and reorganize data
monkeys = {'RM035','RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/coherence/sep_elec/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
%% generate data
level = 3;
trl_type = 'odorresp';
% combine 2 monkeys
[roi_lfp,roi_resp,cur_level_roi] = save_sep_2monkey(level,trl_type,monkeys);
%% parameters 
% number of roi
roi_num=size(cur_level_roi,1);
odor_num=4;
% 1-respiration 2-theta
low={'-respiration','-theta'};
% odor and air condition
cross_freq_result=cell(roi_num,length(low),odor_num);
% time and method
latency = [0 7];
freqhigh = 80;
method = 'mi';
nper=1000;
% plot 
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#000000', '#E12A3C', '#777DDD', '#41AB5D'};
line_wid = 1.5;
%% cross frequency analysis
for roi_i=1:roi_num
    % display progress
    len = 50;
    fin = floor(len*roi_i/roi_num);
    disp([num2str(roi_i) repmat('=',1,fin) '>' repmat('_',1,len-fin) num2str(roi_num)])
    % must have the same label
    roi_resp{roi_i}.label = roi_lfp{roi_i}.label;
    % select 7s
    cfg = [];
    cfg.latency= latency;
    for con_i = 1:odor_num
        % concatenate trials manually
        lfp = ft_concat(ft_selectdata(cfg,roi_lfp{roi_i}), con_i+5);
        resp = ft_concat(ft_selectdata(cfg,roi_resp{roi_i}), con_i+5);
        time = resp.time;
        % frequency analysis
        cfg_tf=[];
        cfg_tf.output='fourier';
        cfg_tf.method='mtmconvol';
        cfg_tf.taper='hanning';
        cfg_tf.toi = [0:1:time(end)]; 
        cfg_tf.keeptrials='yes';
        % cfg_tf.pad = 'nextpow2';
        % resp
        cfg_tf.foi=0.2:0.1:0.5;
        % cfg_tf.t_ftimwin = ones(length(cfg_tf.foi),1).*2;
        cfg_tf.t_ftimwin = 5./cfg_tf.foi;
        resp_freq=ft_freqanalysis(cfg_tf,resp);
        % lfp
        cfg_tf.foi=1:freqhigh;
        % cfg_tf.t_ftimwin = ones(length(cfg_tf.foi),1).*1;
        cfg_tf.t_ftimwin = 5./cfg_tf.foi;
        lfp_freq=ft_freqanalysis(cfg_tf,lfp);

        resp_freq.dimord = 'rpt_chan_freq_time';
        lfp_freq.dimord = 'rpt_chan_freq_time';

        % select non nan data
        cfg = [];
        cfg.latency= [15 time(end)-15];
        resp_freq = ft_selectdata(cfg,resp_freq);
        lfp_freq = ft_selectdata(cfg,lfp_freq);
        
        % modulation index
        cfg=[];
        cfg.freqlow = [0.1 1];
        cfg.freqhigh = [1 freqhigh];
        cfg.method = method;
        cfg.keeptrials = 'yes';
        cross_freq_result{roi_i,1,con_i} = ft_crossfrequencyanalysis(cfg, resp_freq, lfp_freq);
        cfg.freqlow = [4 8];
        cfg.freqhigh = [13 freqhigh];
        cross_freq_result{roi_i,2,con_i} = ft_crossfrequencyanalysis(cfg, lfp_freq, lfp_freq);
        % remove cfg
        for low_i=1:length(low)
            cross_freq_result{roi_i,low_i,con_i} = rmfield(cross_freq_result{roi_i,low_i,con_i}, 'cfg');        
        end
        %% permutation test
    
        cross_resp_per=zeros([size(squeeze(cross_freq_result{roi_i,1,con_i}.crsspctrm)) nper]);
        cross_theta_per=zeros([size(squeeze(cross_freq_result{roi_i,2,con_i}.crsspctrm)) nper]);
    
        parfor per_i=1:nper
            lfp_per_freq = lfp_freq;
            % cut and move
            time_len = length(lfp_per_freq.time);
                cutp=randi([2 time_len],size(lfp_per_freq.fourierspctrm,1),1);
            for trial_i=1:size(lfp_per_freq.fourierspctrm,1)
                temp=lfp_per_freq.fourierspctrm(trial_i,:,:,:);
                lfp_per_freq.fourierspctrm(trial_i,:,:,:)=temp(:,:,:,[cutp(trial_i):time_len 1:cutp(trial_i)-1]);
            end
            % coherence
            cfg=[];
            cfg.freqlow = [0.1 1];
            cfg.freqhigh = [1 freqhigh];
            cfg.method = method;
            cfg.keeptrials = 'yes';
            temp = ft_crossfrequencyanalysis(cfg, resp_freq, lfp_per_freq);
            % save results to matrix
                cross_resp_per(:,:,per_i) = squeeze(temp.crsspctrm);
            % theta
            cfg.freqlow = [4 8];
            cfg.freqhigh = [13 freqhigh];
            temp = ft_crossfrequencyanalysis(cfg, lfp_freq, lfp_per_freq);
            % save results to matrix        
                cross_theta_per(:,:,per_i) = squeeze(temp.crsspctrm);
        end
        % save to a field in cross_freq_results
        cross_freq_result{roi_i,1,con_i}.permute = cross_resp_per;
        cross_freq_result{roi_i,2,con_i}.permute = cross_theta_per;
    end
end
save([pic_dir 'coherence_sep_7s.mat'],'cross_freq_result','cur_level_roi','-v7.3')
