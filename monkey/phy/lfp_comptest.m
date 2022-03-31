function [real_t, un_zmapthresh, zmapthresh] = lfp_comptest(freq_cp,comp)
    % permutation test
    voxel_pval = 0.05; 
    cluster_pval = 0.05;
    n_permutes = 1000; 
    % change dimension
    eegpower=permute(squeeze(freq_cp.powspctrm),[2 3 1]);

    % generate labels
    real_condition_mapping=zeros(size(freq_cp.trialinfo));
    real_condition_mapping(ismember(freq_cp.trialinfo,comp{1}))=1;
    real_condition_mapping(ismember(freq_cp.trialinfo,comp{2}))=2;        
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
    
    % uncorrected pixel-level threshold
    zmapthresh = zmap;
    zmapthresh(abs(zmapthresh)<=norminv(1-voxel_pval/2))=0;
    un_zmapthresh=abs(sign(zmapthresh));
    
    % cluster-level corrected threshold
    % find islands and remove those smaller than cluster size threshold
    clustinfo = bwconncomp(zmapthresh);
    clust_info = cellfun(@numel,clustinfo.PixelIdxList);
    clust_threshold = prctile(max_clust_info,100-cluster_pval*100);
    % remove clusters
    whichclusters2remove = find(clust_info<clust_threshold);
    for i_r=1:length(whichclusters2remove)
        zmapthresh(clustinfo.PixelIdxList{whichclusters2remove(i_r)})=0;
    end
    zmapthresh=abs(sign(zmapthresh));

    % % pixel-level corrected threshold
    % lower_threshold = prctile(max_pixel_pvals(:,1),    voxel_pval*100/2);
    % upper_threshold = prctile(max_pixel_pvals(:,2),100-voxel_pval*100/2);
    % zmapthresh(zmap>=lower_threshold & zmap<=upper_threshold)=0;
    % zmapthresh = abs(sign(zmapthresh));
end