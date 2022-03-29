function [un_zmapthresh, zmapthresh]= lfp_ptest(data,data_sepi,cfg)
% threshold by permutation test
    voxel_pval   = 0.05;
    cluster_pval = 0.05;
    n_permutes = 1000;
    num_frex = length(data.freq);
    nTimepoints = length(data.time);
    baseidx(1) = dsearchn(data_sepi.time',cfg.baseline(1));
    baseidx(2) = dsearchn(data_sepi.time',cfg.baseline(2));
    % initialize null hypothesis matrices
    permuted_vals    = zeros(n_permutes,num_frex,nTimepoints);
    max_clust_info   = zeros(n_permutes,1);  
    % permutate baseline
    trial_num = size(data_sepi.powspctrm,1);    
%     realbaselines = squeeze(nanmean(data_sepi.powspctrm(:,:,:,baseidx(1):baseidx(2)),4));    
    parfor perm_i = 1:n_permutes        
%         len = diff(baseidx);
        % permutated trials rpt_freq_time
        tmp = zeros(trial_num,size(data_sepi.powspctrm,3),size(data_sepi.powspctrm,4));
        for trial_i = 1:trial_num
            % cut and move each trial
            cutpoint = randsample(2:nTimepoints,1);
            tmp(trial_i,:,:) = squeeze(data_sepi.powspctrm(trial_i,:,:,[cutpoint:end 1:cutpoint-1]));    
%             realbaselines = squeeze(nanmean(data_sepi.powspctrm(trial_i,:,:,cutpoint:cutpoint+len),4));
%             tmp(trial_i,:,:) = 10*log10(bsxfun(@rdivide,squeeze(data_sepi.powspctrm(trial_i,:,:,:)),nanmean(realbaselines,1)'));        
        end
        % calculate db change
        realbaselines = squeeze(nanmean(tmp(:,:,baseidx(1):baseidx(2)),3));
        permuted_vals(perm_i,:,:) = 10*log10(bsxfun(@rdivide,squeeze(nanmean(tmp,1)),nanmean(realbaselines,1)'));
%         permuted_vals(perm_i,:,:) = squeeze(nanmean(tmp,1));
    end
    realmean=squeeze(data.powspctrm);
    m = nanmean(permuted_vals);
    s = nanstd(permuted_vals);
    zmap = (realmean-squeeze(m)) ./ squeeze(s);
    threshmean = realmean;
    threshmean(abs(zmap)<=norminv(1-voxel_pval/2))=0;
    un_zmapthresh=abs(sign(threshmean));

    if isfield(cfg,'cluster') && cfg.cluster ==1
        %cluster correction        
        parfor perm_i = 1:n_permutes
            % for cluster correction, apply uncorrected threshold and get maximum cluster sizes
            fakecorrsz = squeeze((permuted_vals(perm_i,:,:)-m) ./ s );
            fakecorrsz(abs(fakecorrsz)<norminv(1-voxel_pval/2))=0;
            % get number of elements in largest supra-threshold cluster
            clustinfo = bwconncomp(fakecorrsz);
            max_clust_info(perm_i) = max([ 0 cellfun(@numel,clustinfo.PixelIdxList) ]); % the zero accounts for empty maps
            % using cellfun here eliminates the need for a slower loop over cells
        end
        % apply cluster-level corrected threshold
        zmapthresh = zmap;
        % uncorrected pixel-level threshold
        zmapthresh(abs(zmapthresh)<norminv(1-voxel_pval/2))=0;
        % find islands and remove those smaller than cluster size threshold
        clustinfo = bwconncomp(zmapthresh);
        clust_info = cellfun(@numel,clustinfo.PixelIdxList);
        clust_threshold = prctile(max_clust_info,100-cluster_pval*100);
        % identify clusters to remove
        whichclusters2remove = find(clust_info<clust_threshold);
        % remove clusters
        for i_r=1:length(whichclusters2remove)
            zmapthresh(clustinfo.PixelIdxList{whichclusters2remove(i_r)})=0;
        end
        zmapthresh=abs(sign(zmapthresh));
    else
        zmapthresh = un_zmapthresh;
    end
end