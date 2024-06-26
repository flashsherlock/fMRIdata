%% load and reorganize data
% monkeys = {'RM035','RM033'};
monkeys = {'RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/coherence/' m '_HA/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
% generate data
level = 6;
trl_type = 'odor';
% combine 2 monkeys
[roi_lfp,roi_resp,cur_level_roi] = save_merge_2monkey(level,trl_type,monkeys);

% one monkey data
% one_data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/rm035_ane/mat/';
% label=[one_data_dir 'RM035_datpos_label.mat'];
% dates=16;
% [roi_lfp,roi_resp,cur_level_roi] = save_merge_position(one_data_dir,label,dates,level,trl_type);

%% parameters 
% number of roi
roi_num=size(cur_level_roi,1);
odor_num=4;
% 1-respiration 2-theta
low={'-respiration','-theta'};
% odor and air condition
cross_freq_result=cell(roi_num,length(low),2);
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
            % too slow
            % lfp_per=lfp;
            % cutp=randi([2 length(lfp.time{1})],length(lfp.trialinfo),1);
            % % cut and move
            % for trial_i=1:length(lfp.trialinfo)
            %     temp=lfp.trial{trial_i};
            %     lfp_per.trial{trial_i}=temp([cutp(trial_i):length(lfp.time{1}) 1:cutp(trial_i)-1]);
            % end                     
            % % frequency analysis
            % lfp_per_freq=ft_freqanalysis(cfg_tf,lfp_per);
            % % select 7s
            % cfg = [];
            % cfg.latency= latency;
            % lfp_per_freq = ft_selectdata(cfg,lfp_per_freq);

            % shuffle trials in each condition
            % lfp_per_freq = lfp_freq;
            % for class_i = unique(lfp_per_freq.trialinfo)'
            %     class_idx = find(lfp_per_freq.trialinfo == class_i);
            %     class_idx_per = class_idx(randperm(length(class_idx)));
            %     lfp_per_freq.fourierspctrm(class_idx,:,:,:) = lfp_per_freq.fourierspctrm(class_idx_per,:,:,:);            
            % end

            lfp_per_freq = lfp_freq;
            % cut and move
            time_len = length(lfp_per_freq.time);
                cutp=randi([2 time_len],size(lfp_per_freq.fourierspctrm,1),1);
            for trial_i=1:size(lfp_per_freq.fourierspctrm,1)
                temp=lfp_per_freq.fourierspctrm(trial_i,:,:,:);
                lfp_per_freq.fourierspctrm(trial_i,:,:,:)=temp(:,:,:,[cutp(trial_i):time_len 1:cutp(trial_i)-1]);
            end

            % shuffle time points
            % for trial_i=1:length(lfp_per_freq.trialinfo)
            %     temp=lfp_per_freq.fourierspctrm(trial_i,:,:,:);
            %     lfp_per_freq.fourierspctrm(trial_i,:,:,:)=temp(:,:,:,randperm(time_len));
            % end

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

save([pic_dir 'coherence_7s.mat'],'cross_freq_result','cur_level_roi')

%% plot
cpair = 1;
label = {'Ind','Iso_l','Iso_h','Peach','Banana','Air','Odor','UnPlea','Plea'};
for roi_i=1:size(cross_freq_result,1)
    % respiration and theta
    for low_i=1:length(low)
        
        figure('position',[20,20,600,600],'Renderer','Painters');
        % modulation index
%         subplot(3,1,1)
%         hold on;
        suptitle([cur_level_roi{roi_i,1} low{low_i}])
        freqs=cross_freq_result{roi_i,low_i,1}.freqhigh;
        
        % calculate mean modulation index and plot
        p=cell(odor_num,1);
        plvair=cross_freq_result{roi_i,low_i,1}.crsspctrm;
        plv_perair=cross_freq_result{roi_i,low_i,1}.permute;
        zair = (squeeze(plvair)-mean(plv_perair,3))./std(plv_perair,0,3);
        zplv_perair = (squeeze(plv_perair)-mean(plv_perair,3))./std(plv_perair,0,3);
        for odor_i=1:odor_num
            % rpt_chan_freqlow_freqhigh
            plv=cross_freq_result{roi_i,low_i,odor_i}.crsspctrm;
            % chan_freqlow_freqhigh_nper
            plv_per=cross_freq_result{roi_i,low_i,odor_i}.permute;
            % p-value percentage of plv_per larger than plv
            p{odor_i} = (sum(bsxfun(@gt, plv_per, squeeze(plv)),3)+1 )./(size(plv_per,3)+1);
            p{odor_i} = squeeze(mean(p{odor_i},1));
            % problem in all odor condition
%             pcpair{odor_i} = (sum(bsxfun(@gt, plv_per-plv_perair, squeeze(plv-plvair)),3)+1 )./(size(plv_per,3)+1);
%             pcpair{odor_i} = squeeze(mean(pcpair{odor_i},1));
%             plot(freqs,squeeze(mean(mean(plv,1),3)),...
%                 'Color',hex2rgb(colors{odor_i+5}),'linewidth', line_wid)
        end
        if low_i==1
            xl = [1 80];
            xt = [1 10:10:80];
        else
            xl = [13 80];
            xt = [13 20:10:80];
        end
%         set(gca,'xlim', xl);
%         set(gca,'XTick', xt);
%         set(gca,'XTickLabel',xt);
%         legend(label(6:7))
%         ylabel('Modulation Index')
        
        % normalized mi
        subplot(2,1,1)
        hold on;
        for odor_i=1:odor_num            
            % rpt_chan_freqlow_freqhigh
            plv=cross_freq_result{roi_i,low_i,odor_i}.crsspctrm;
            % chan_freqlow_freqhigh_nper
            plv_per=cross_freq_result{roi_i,low_i,odor_i}.permute;
            % calculate zscore according to permutated distribution
            mean_per = mean(plv_per,3);
            std_per = std(plv_per,0,3);
            zmi = (squeeze(plv)-mean_per)./std_per;
            zplv_per = (squeeze(plv_per)-mean_per)./std_per;
            pcpair{odor_i} = (sum(bsxfun(@gt, zplv_per-zplv_perair, squeeze(zmi-zair)),3)+1 )./(size(plv_per,3)+1);
            pcpair{odor_i} = squeeze(mean(pcpair{odor_i},1));
            % plot zmi (average low freq)
            plot(freqs,mean(zmi),'Color',hex2rgb(colors{odor_i+5}),'linewidth', line_wid)
            % add sig line
            ystart = 2-odor_i*0.5;
            if cpair == 1
                if odor_i ~= 1
                plotsigx( freqs, pcpair{odor_i}, hex2rgb(colors{odor_i+5}), ystart, line_wid)
                end
            else
                plotsigx( freqs, p{odor_i}, hex2rgb(colors{odor_i+5}), ystart, line_wid)
            end
        end
        set(gca,'xlim',xl);
        set(gca,'XTick',xt);
        set(gca,'XTickLabel',xt);
        set(gca,'FontSize',18);
        legend(label(6:6+odor_num-1));
        ylabel('Normalized MI (z score)');
        xlabel('Frequency(Hz)');
        
        % p-value        
        subplot(2,1,2)
        hold on;
        for odor_i=1:odor_num            
            plot(freqs,p{odor_i},'Color',hex2rgb(colors{odor_i+5}),'linewidth', line_wid)
        end
        % 0.05
        plot(freqs,0.05*ones(1,length(freqs)),'k','linestyle','--','LineWidth',2)
        set(gca,'xlim',xl);
        set(gca,'XTick',xt);
        set(gca,'XTickLabel',xt);
        set(gca,'FontSize',18);
        xlabel('Frequency(Hz)');
        ylabel('p');
                
        % save picture
        saveas(gcf, [pic_dir cur_level_roi{roi_i,1} low{low_i} '-mi', '.svg'], 'svg')
        saveas(gcf, [pic_dir cur_level_roi{roi_i,1} low{low_i} '-mi', '.png'], 'png')
        close all
    end
end
