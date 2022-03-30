%% load and reorganize data
monkeys = {'RM035','RM033'};
% monkeys = {'RM033'};
if length(monkeys) > 1
    m = '2monkey';
else
    m = monkeys{1};
end
data_dir='/Volumes/WD_D/gufei/monkey_data/yuanliu/merge2monkey/';
pic_dir=[data_dir 'pic/lfp_odorresp/' m '/'];
if ~exist(pic_dir,'dir')
    mkdir(pic_dir);
end
%% generate data
level = 3;
trl_type = 'odorresp';
% combine 2 monkeys
[roi_lfp,roi_resp,cur_level_roi] = save_merge_2monkey(level,trl_type,monkeys);
% get number of roi
roi_num=size(cur_level_roi,1);
odor_num=7;
%% TF analysis
if exist([pic_dir 'tf_' m '.mat'],'file')
    load([pic_dir 'tf_' m '.mat'])
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
    save([pic_dir 'tf_' m '.mat'],'freq_sep_all','-v7.3')
end
%% odor and air
freq_range = [1.5 200];
for roi_i=1:roi_num
    time_ranges = {[-1 7.5],[-1 4]};
    conditions = {'-oddtrial',''};
    cur_roi=cur_level_roi{roi_i,1};
    
    for time_i=1:length(time_ranges)
        % get time range
        time_range = time_ranges{time_i};
        % select data
        cfg=[];        
        cfg.latency=time_range;
        resp=ft_selectdata(cfg,roi_resp{roi_i});
        cfg.frequency=freq_range;
        freq_sep = ft_selectdata(cfg,freq_sep_all{roi_i});
        % average and seperated data
        freq_blc=cell(1,7);
        freq_sepi=cell(1,7);
        for i=1:7
            % average across trials
            cfg = [];
            if i==7
                cfg.trials = find(freq_sep.trialinfo~=6);
            else
                cfg.trials = find(freq_sep.trialinfo==i);
            end
            % odd trials only
            if strcmp(conditions{time_i},'-oddtrial')
                cfg.trials = cfg.trials(1:2:end);
            end
            freq_blc{i}=ft_freqdescriptives(cfg,freq_sep);
            % respiration
            resavg=ft_timelockanalysis(cfg, resp);
            % seperated data
            freq_sepi{i}=ft_selectdata(cfg,freq_sep);
            % baseline correction
            cfg              = [];
            cfg.baseline     = [-1 -0.5];
            cfg.baselinetype = 'db';
            freq_blc{i} = ft_freqbaseline(cfg, freq_blc{i});
            bs=linspace(cfg.baseline(1),cfg.baseline(2),100);

            % permutation test
            cfg = [];
            cfg.baseline = [bs(1) bs(end)];
            cfg.cluster = 1;
            [un_zmapthresh, zmapthresh]= lfp_ptest(freq_blc{i},freq_sepi{i},cfg);

            % plot by contourf
            figure;
            contourf(freq_blc{i}.time,freq_blc{i}.freq,squeeze(freq_blc{i}.powspctrm),40,'linecolor','none');
            set(gca,'ytick',round(logspace(log10(freq_range(1)),log10(freq_range(end)),10)*100)/100,'yscale','log');
            set(gca,'ylim',freq_range,'xlim',time_range,'clim',[-2 2]);
            % colorbarlabel('Baseline-normalized power (dB)')
            xlabel('Time (s)')
            ylabel('Frequency (Hz)')
            colormap jet
            ylabel(colorbar,'Baseline-normalized power (dB)')
            % plot respiration    
            hold on
            % uncorrected
            contour(freq_blc{i}.time,freq_blc{i}.freq,un_zmapthresh,1,'linecolor','k','LineWidth',1)
            % cluster based correction
            % contour(freq_blc{i}.time,freq_blc{i}.freq,zmapthresh,1,'linecolor','k','LineWidth',1)
            set(gca, 'yminortick', 'off');
            plot(bs,1.5*ones(1,100),'k','LineWidth',5)
            yyaxis right
            plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
            set(gca,'xlim',time_range,'ytick',[]);
            title([cur_roi '-odorresp' num2str(i) conditions{time_i}])
            hold off
            saveas(gcf, [pic_dir cur_roi '-odorresp' num2str(i) conditions{time_i}, '-un.fig'], 'fig')
            saveas(gcf, [pic_dir cur_roi '-odorresp' num2str(i) conditions{time_i}, '-un.png'], 'png')
            close all

            % plot by contourf cluster based correction
            figure;
            contourf(freq_blc{i}.time, freq_blc{i}.freq, squeeze(freq_blc{i}.powspctrm), 40, 'linecolor', 'none');
            set(gca, 'ytick', round(logspace(log10(freq_range(1)), log10(freq_range(end)), 10) * 100) / 100, 'yscale', 'log');
            set(gca, 'ylim', freq_range, 'xlim', time_range, 'clim', [-2 2]);
            % colorbarlabel('Baseline-normalized power (dB)')
            xlabel('Time (s)')
            ylabel('Frequency (Hz)')
            colormap jet
            ylabel(colorbar, 'Baseline-normalized power (dB)')
            % plot respiration
            hold on
            % cluster based correction
            contour(freq_blc{i}.time,freq_blc{i}.freq,zmapthresh,1,'linecolor','k','LineWidth',1)
            set(gca, 'yminortick', 'off');
            plot(bs, 1.5 * ones(1, 100), 'k', 'LineWidth', 5)
            yyaxis right
            plot(resavg.time, resavg.avg, 'k', 'LineWidth', 1.5)
            set(gca, 'xlim', time_range, 'ytick', []);
            title([cur_roi '-odorresp' num2str(i) conditions{time_i}])
            hold off
            saveas(gcf, [pic_dir cur_roi '-odorresp' num2str(i) conditions{time_i}, '.fig'], 'fig')
            saveas(gcf, [pic_dir cur_roi '-odorresp' num2str(i) conditions{time_i}, '.png'], 'png')
            close all
        end
    end
%% comparison t-test          
    % set comparison
    comp = cell(5,3);
    for comp_i=1:7
        comp{comp_i,1}=comp_i;
        comp{comp_i,2}=6;
        comp{comp_i,3}=[num2str(comp_i) '-vs-air-'];
    end
    comp{7,1}=1:5;
    % valence
    comp{6,1}=4:5;    
    comp{6,2}=1:3;
    comp{6,3}='-valence-';
    
    % analyze
    for comp_i=1:size(comp,1)
        % select data
        cfg=[];
        cfg.trials = find(ismember(freq_sep.trialinfo,[comp{comp_i,1} comp{comp_i,2}])==1);
        freq_cp=ft_selectdata(cfg,freq_sep);
        % respiration
        cfg.trials = find(ismember(freq_sep.trialinfo,comp{comp_i,1})==1);
        resavg=ft_timelockanalysis(cfg, resp);
        % baseline correction
        cfg              = [];
        cfg.baseline     = [-1 -0.5];
        cfg.baselinetype = 'absolute';
        freq_cp = ft_freqbaseline(cfg, freq_cp);
        
        % permutation test
        voxel_pval = 0.05; 
        cluster_pval = 0.05;
        n_permutes = 1000; 
        % change dimension
        eegpower=permute(squeeze(freq_cp.powspctrm),[2 3 1]);
        
        % generate labels
        real_condition_mapping=zeros(size(freq_cp.trialinfo));
        real_condition_mapping(ismember(freq_cp.trialinfo,comp{comp_i,1}))=1;
        real_condition_mapping(ismember(freq_cp.trialinfo,comp{comp_i,2}))=2;        
        % compute actual t-test of difference (using unequal N and std)
        tnum   = squeeze(mean(eegpower(:,:,real_condition_mapping==1),3) - mean(eegpower(:,:,real_condition_mapping==2),3));
        tdenom = sqrt( (std(eegpower(:,:,real_condition_mapping==1),0,3).^2)./sum(real_condition_mapping==1) + (std(eegpower(:,:,real_condition_mapping==2),0,3).^2)./sum(real_condition_mapping==2) );
        real_t = tnum./tdenom;

        % initialize null hypothesis matrices
        num_frex = length(freq_cp.freq);
        nTimepoints = length(freq_cp.time);
        permuted_tvals  = zeros(n_permutes,num_frex,nTimepoints);
        max_pixel_pvals = zeros(n_permutes,2);
        max_clust_info  = zeros(n_permutes,1);

        % generate pixel-specific null hypothesis parameter distributions
        parfor permi = 1:n_permutes
            fake_condition_mapping = real_condition_mapping(randperm(length(real_condition_mapping)));

            % compute t-map of null hypothesis
            tnum   = squeeze(mean(eegpower(:,:,fake_condition_mapping==1),3)-mean(eegpower(:,:,fake_condition_mapping==2),3));
            tdenom = sqrt( (std(eegpower(:,:,fake_condition_mapping==1),0,3).^2)./sum(fake_condition_mapping==1) + (std(eegpower(:,:,fake_condition_mapping==2),0,3).^2)./sum(fake_condition_mapping==2) );
            tmap   = tnum./tdenom;

            % save all permuted values
            permuted_tvals(permi,:,:) = tmap;

            % save maximum pixel values
            max_pixel_pvals(permi,:) = [ min(tmap(:)) max(tmap(:)) ];

            % cluster correction
            tmap(abs(tmap)<tinv(1-voxel_pval/2,length(real_condition_mapping)-2))=0;

            % get number of elements in largest supra-threshold cluster
            clustinfo = bwconncomp(tmap);
            max_clust_info(permi) = max([ 0 cellfun(@numel,clustinfo.PixelIdxList) ]); % notes: cellfun is superfast, and the zero accounts for empty maps
        end

        % now compute Z-map
        zmap = (real_t-squeeze(mean(permuted_tvals,1)))./squeeze(std(permuted_tvals));

        % apply cluster-level corrected threshold
        zmapthresh = zmap;
        % uncorrected pixel-level threshold
        zmapthresh(abs(zmapthresh)<norminv(1-voxel_pval/2))=0;
        % find islands and remove those smaller than cluster size threshold
        clustinfo = bwconncomp(zmapthresh);
        clust_info = cellfun(@numel,clustinfo.PixelIdxList);
        clust_threshold = prctile(max_clust_info,100-cluster_pval*100);

        % remove clusters
        whichclusters2remove = find(clust_info<clust_threshold);
        for i_r=1:length(whichclusters2remove)
            zmapthresh(clustinfo.PixelIdxList{whichclusters2remove(i_r)})=0;
        end

        figure;
        contourf(freq_cp.time,freq_cp.freq,real_t,40,'linecolor','none');
        set(gca,'ytick',round(logspace(log10(freq_range(1)),log10(freq_range(end)),10)*100)/100,'yscale','log');
        set(gca,'ylim',freq_range,'xlim',time_range,'clim',[-3 3]);
        % colorbarlabel('Baseline-normalized power (dB)')
        xlabel('Time (s)')
        ylabel('Frequency (Hz)')
        colormap jet
        ylabel(colorbar,'t-value')
        hold on
        % cluster based correction
        contour(freq_cp.time,freq_cp.freq,abs(sign(zmapthresh)),1,'linecolor','k','LineWidth',1)
        set(gca, 'yminortick', 'off');
        plot(bs,1.5*ones(1,100),'k','LineWidth',5)
        yyaxis right
        plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
        set(gca,'xlim',time_range,'ytick',[]);
        title([cur_roi '-odorresp' comp{comp_i,3} 't'])
        hold off
        saveas(gcf, [pic_dir cur_roi '-odorresp' comp{comp_i,3} 't', '.fig'], 'fig')
        saveas(gcf, [pic_dir cur_roi '-odorresp' comp{comp_i,3} 't', '.png'], 'png')
        close all

        % apply uncorrected threshold
        zmapthresh = zmap;
        zmapthresh(abs(zmapthresh)<norminv(1-voxel_pval/2))=false;
        zmapthresh=logical(zmapthresh);
        figure;
        contourf(freq_cp.time,freq_cp.freq,real_t,40,'linecolor','none');
        set(gca,'ytick',round(logspace(log10(freq_range(1)),log10(freq_range(end)),10)*100)/100,'yscale','log');
        set(gca,'ylim',freq_range,'xlim',time_range,'clim',[-3 3]);
        % colorbarlabel('Baseline-normalized power (dB)')
        xlabel('Time (s)')
        ylabel('Frequency (Hz)')
        colormap jet
        ylabel(colorbar,'t-value')
        hold on
        % cluster based correction
        contour(freq_cp.time,freq_cp.freq,zmapthresh,1,'linecolor','k','LineWidth',1)
        set(gca, 'yminortick', 'off');
        plot(bs,1.5*ones(1,100),'k','LineWidth',5)
        yyaxis right
        plot(resavg.time,resavg.avg,'k','LineWidth',1.5)
        set(gca,'xlim',time_range,'ytick',[]);
        title([cur_roi '-odorresp' comp{comp_i,3} 'tun'])
        hold off
        saveas(gcf, [pic_dir cur_roi '-odorresp' comp{comp_i,3} 'tun', '.fig'], 'fig')
        saveas(gcf, [pic_dir cur_roi '-odorresp' comp{comp_i,3} 'tun', '.png'], 'png')
        close all
    end

    % % % apply pixel-level corrected threshold
    % % lower_threshold = prctile(max_pixel_pvals(:,1),    voxel_pval*100/2);
    % % upper_threshold = prctile(max_pixel_pvals(:,2),100-voxel_pval*100/2);
    % % zmapthresh = zmap;
    % % zmapthresh(zmapthresh>lower_threshold & zmapthresh<upper_threshold)=0;
end