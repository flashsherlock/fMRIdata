%% load and reorganize data
% monkeys = {'RM035','RM033'};
monkeys = {'RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/coherence/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% generate data
level = 3;
trl_type = 'odor';
% combine 2 monkeys
[roi_lfp,roi_resp,cur_level_roi] = save_merge_2monkey(level,trl_type);

% one monkey data
% one_data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
% label=[one_data_dir 'RM035_datpos_label.mat'];
% dates=16;
% [roi_lfp,roi_resp,cur_level_roi] = save_merge_position(one_data_dir,label,dates,level,trl_type);

%% parameters 
% number of roi
roi_num=size(cur_level_roi,1);
odor_num=7;
% 1-respiration 2-theta
low={'-respiration','-theta'};
cross_freq_result=cell(roi_num,length(low));
% time and method
latency = [0 7];
freqhigh = 85;
method = 'mi';
nper=1000;
% plot 
colors = {'#777DDD', '#69b4d9', '#149ade', '#41AB5D', '#ECB556', '#000000', '#E12A3C', '#777DDD', '#41AB5D'};
line_wid = 1.5;
%% cross frequency analysis
for roi_i=1:roi_num
    % must have the same label
    lfp = roi_lfp{roi_i};
    roi_resp{roi_i}.label = roi_lfp{roi_i}.label;
    % frequency analysis
    cfg_tf=[];
    cfg_tf.output='fourier';
    cfg_tf.method='mtmconvol';
    cfg_tf.taper='hanning';
    cfg_tf.toi = -3.5:0.05:9.5; 
    cfg_tf.keeptrials='yes';
    % resp
    cfg_tf.foi=0.1:10;
    cfg_tf.t_ftimwin = ones(length(cfg_tf.foi),1).*0.5;
    resp_freq=ft_freqanalysis(cfg_tf,roi_resp{roi_i});
    % lfp
    cfg_tf.foi=1:freqhigh;
    cfg_tf.t_ftimwin = ones(length(cfg_tf.foi),1).*0.5;
    lfp_freq=ft_freqanalysis(cfg_tf,roi_lfp{roi_i});

    % select 7s
    cfg = [];
    cfg.latency= latency;
    resp_freq = ft_selectdata(cfg,resp_freq);
    lfp_freq = ft_selectdata(cfg,lfp_freq);
    % modulation index
    cfg=[];
    cfg.freqlow = [0 10];
    cfg.freqhigh = [1 freqhigh];
    cfg.method = method;
    cfg.keeptrials = 'yes';
    cross_freq_result{roi_i,1} = ft_crossfrequencyanalysis(cfg, resp_freq, lfp_freq);
    cfg.freqlow = [4 8];
    cfg.freqhigh = [13 freqhigh];
    cross_freq_result{roi_i,2} = ft_crossfrequencyanalysis(cfg, lfp_freq);
    % add trialinfo and remove cfg
    for low_i=1:length(low)
        cross_freq_result{roi_i,low_i}.trialinfo = roi_lfp{roi_i}.trialinfo;
        cross_freq_result{roi_i,low_i} = rmfield(cross_freq_result{roi_i,low_i}, 'cfg');        
    end
    %% permutation test
    
    cross_resp_per=zeros([size(squeeze(cross_freq_result{roi_i,1}.crsspctrm)) nper]);
    cross_theta_per=zeros([size(squeeze(cross_freq_result{roi_i,2}.crsspctrm)) nper]);
    
    parfor per_i=1:nper
        % too slow
%         lfp_per=lfp;
%         cutp=randi([1 length(lfp.time{1})],length(lfp.trialinfo),1);
%         % cut and move
%         for trial_i=1:length(lfp.trialinfo)
%             temp=lfp.trial{trial_i};
%             lfp_per.trial{trial_i}=temp([cutp(trial_i)+1:length(lfp.time{1}) 1:cutp(trial_i)]);
%         end                     
%         % frequency analysis
%         lfp_per_freq=ft_freqanalysis(cfg_tf,lfp_per);
%         % select 7s
%         cfg = [];
%         cfg.latency= latency;
%         lfp_per_freq = ft_selectdata(cfg,lfp_per_freq);
        
        % shuffle trials in each condition
        lfp_per_freq = lfp_freq;
        for class_i = unique(lfp_per_freq.trialinfo)'
            class_idx = find(lfp_per_freq.trialinfo == class_i);
            class_idx_per = class_idx(randperm(length(class_idx)));
            lfp_per_freq.fourierspctrm(class_idx,:,:,:) = lfp_per_freq.fourierspctrm(class_idx_per,:,:,:);            
        end
        % coherence
        cfg=[];
        cfg.freqlow = [0 10];
        cfg.freqhigh = [1 freqhigh];
        cfg.method = method;
        cfg.keeptrials = 'yes';
        temp = ft_crossfrequencyanalysis(cfg, resp_freq, lfp_per_freq);
        % save results to matrix
        cross_resp_per(:,:,:,per_i) = squeeze(temp.crsspctrm);
        % theta
        cfg.freqlow = [4 8];
        cfg.freqhigh = [13 freqhigh];
        temp = ft_crossfrequencyanalysis(cfg, lfp_freq, lfp_per_freq);
        % save results to matrix        
        cross_theta_per(:,:,:,per_i) = squeeze(temp.crsspctrm);
    end
    % save to a field in cross_freq_results
    cross_freq_result{roi_i,1}.permute = cross_resp_per;
    cross_freq_result{roi_i,2}.permute = cross_theta_per;
    
    save([pic_dir 'coherence_7s.mat'],'cross_freq_result')
end
% plot
for roi_i=1:roi_num
    % respiration and theta
    for low_i=1:length(low)
        
        figure('position',[20,20,600,600]);
        % modulation index
        subplot(2,1,1)
        hold on;
        title([cur_level_roi{roi_i,1} low{low_i}])
        freqs=cross_freq_result{roi_i,low_i}.freqhigh;
        
        % calculate mean modulation index and plot
        p=cell(odor_num,1);
        for odor_i=1:odor_num
            % slect trials
            if odor_i==7
                trials  = find(cross_freq_result{roi_i,low_i}.trialinfo~=6);
            else
                trials  = find(cross_freq_result{roi_i,low_i}.trialinfo==odor_i);
            end       
            % rpt_chan_freqlow_freqhigh
            plv=cross_freq_result{roi_i,low_i}.crsspctrm(trials,:,:,:);
            % chan_freqlow_freqhigh_nper
            plv_per=cross_freq_result{roi_i,low_i}.permute(trials,:,:,:);
            % p-value percentage of plv_per larger than plv
            p{odor_i} = (sum(bsxfun(@gt, plv_per, squeeze(plv)),4)+1 )./(size(plv_per,4)+1);
            p{odor_i} = squeeze(mean(mean(p{odor_i},1),2));
            plot(freqs,squeeze(mean(mean(plv,1),3)),...
                'Color',hex2rgb(colors{odor_i}),'linewidth', line_wid)
        end
        set(gca,'xlim',[13 80]);
        set(gca,'XTick',[13 20:10:80]);
        set(gca,'XTickLabel',[13 20:10:80]);
        legend('Ind','Iso_l','Iso_h','Peach','Banana','Air','Odor')
        ylabel('Modulation Index')
        
        % p-value        
        subplot(2,1,2)
        hold on;
        for odor_i=1:odor_num            
            plot(freqs,p{odor_i},'Color',hex2rgb(colors{odor_i}),'linewidth', line_wid)
        end
        % 0.05
        plot(freqs,0.05*ones(1,length(freqs)),'k','linestyle','--','LineWidth',2)
        set(gca,'xlim',[13 80]);
        set(gca,'XTick',[13 20:10:80]);
        set(gca,'XTickLabel',[13 20:10:80]);
        ylabel('p')
        xlabel('Frequency(Hz)')  
        % save picture
        saveas(gcf, [pic_dir cur_level_roi{roi_i,1} low{low_i} '-mi', '.fig'], 'fig')
        saveas(gcf, [pic_dir cur_level_roi{roi_i,1} low{low_i} '-mi', '.png'], 'png')
        close all
    end
end