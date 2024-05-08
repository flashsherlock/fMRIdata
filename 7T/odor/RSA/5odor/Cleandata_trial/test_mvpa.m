data='/Volumes/WD_F/gufei/7T_odor/';
datafolder = '/Volumes/WD_F/gufei/7T_odor/';
rois={'Amy8_align'};
sub = 's21';
odors={'lim','tra','car','cit','ind'};
comb=nchoosek(1:length(odors), 2);
% shift=6;
% shift=[-6 -3 6];
shift=[-6 -3 0 3 6];
analysis='pabiode';
for i=1:length(rois)
    roi=rois{i};
    mask=get_filenames_afni([data sub '/mask/' roi '*+orig.HEAD']);
    % avoid matching too many files
    mask=mask(1,:);
    % Set defaults
    cfg = decoding_defaults;

    % Make sure to set software to AFNI
    cfg.software = 'AFNI';
    
    % Set the analysis that should be performed (default is 'searchlight')
    cfg.analysis = 'roi';    
    cfg.files.name={};
    cfg.files.labelname={};
    cfg.files.chunk=[];
    cfg.files.label=[];

    % tr stores all the timing information
    tr = [];
    for shift_i=1:length(shift)
        timing=findtrs(shift(shift_i),sub);
        % lim tra car cit
        tr = [tr;timing];
        numtr=6*6*5;
        F=cell(1,numtr);
        for subi = 1:numtr
            t=timing(subi,2);
            F{subi} = [datafolder sub '/' sub '.' analysis '.results/'  'NIerrts.' sub '.' analysis '.odornova_noblur+orig.BRIK,' num2str(t)];
            % F{subi} = [datafolder sub '/' sub '.' analysis '.results/'  'NIerrts.' sub '.' analysis '.onlypolva+orig.BRIK,' num2str(t)];
            % F{subi} = [datafolder sub '/' sub '.' analysis '.results/'  'allrun.volreg.' sub '.' analysis '+orig.BRIK,' num2str(t)];
        end
        cfg.files.name = [cfg.files.name F];
        cfg.files.chunk = [cfg.files.chunk; reshape(repmat(1:36, [1 5]), [numtr 1])];

        % 1-lim 2-tra 3-car 4-cit
        cfg.files.label = [cfg.files.label;reshape(repmat([1 2 3 4 5], [36 1]), [numtr 1])];
        % cfg.files.label = timing(:, 1);
        cfg.files.labelname = [cfg.files.labelname;reshape(repmat({'lim' 'tra' 'car' 'cit' 'ind'}, [36 1]), [numtr 1])];
    end
    %% apply mask
    cfg.files.mask = mask;    
    %% Nothing needs to be changed below for a standard leave-one-run out cross    
    % load data the standard way
    [passed_data, ~, cfg] = decoding_load_data(cfg);
    % add run number and repeat num as features    
    combine = 1;
    if combine == 1
       nsample = size(passed_data.data, 1);
       nvoxel = size(passed_data.data, 2);
       passed_data.data = reshape(passed_data.data,[nsample/length(shift),length(shift),nvoxel]);
       %%%%%%%%% plot data
       % shape_data = passed_data.data;
       shape_data = reshape(passed_data.data,[nsample/length(shift)/length(odors),length(odors),length(shift),nvoxel]);
       % plot(squeeze(mean(mean(shape_data(:,:,5,:),4),1))')
       means=squeeze(mean(mean(shape_data(:,:,5,:),4),1))';
       sum(abs(bsxfun(@minus,means,means')));
       figure
       hold on
       for i=1:2%length(odors)
        histogram(squeeze(mean(shape_data(:,i,5,:),6)))
       end
       mean(reshape(std(squeeze(mean(shape_data2(:,:,5,:),6)),1),[],1));
        %%%%%%%%% plot data
       % subtract baseline trs
       base = find(shift<0);       
       if ~isempty(base)
           % average baseline
           baseline = squeeze(mean(passed_data.data(:,base,:), 2));
           passed_data.data = squeeze(mean(passed_data.data(:,shift>=0,:), 2))-baseline;
       else
           passed_data.data = squeeze(mean(passed_data.data, 2));       
       end
       %%%%%%%%% plot data
       shape_data2 = reshape(passed_data.data,[nsample/length(shift)/length(odors),length(odors),nvoxel]);
       % plot(squeeze(mean(mean(shape_data2(:,:,:),3),1))')
       means2=squeeze(mean(mean(shape_data2(:,:,:),3),1))';
       sum(abs(bsxfun(@minus,means2,means2')));
       figure
       hold on
       for i=1:2%length(odors)
        histogram(squeeze(mean(shape_data2(:,i,:),6)))
       end
       mean(reshape(std(squeeze(mean(shape_data2(:,:,:),6)),1),[],1));
        %%%%%%%%% plot data
       % passed_data.data = [passed_data.data tr(1:nsample/length(shift),[3 4])];
       % change design
       cfg.files.name = cfg.files.name(1:nsample/length(shift));
       cfg.files.chunk = cfg.files.chunk(1:nsample/length(shift));
       % run as chunk
       % cfg.files.chunk = tr(1:nsample/length(shift),3);
       % rept as chunk
       % cfg.files.chunk = tr(1:nsample/length(shift),4);
       cfg.files.label = cfg.files.label(1:nsample/length(shift));
       cfg.files.labelname = cfg.files.labelname(1:nsample/length(shift));
       passed_data.files.name = passed_data.files.name(1:nsample/length(shift));
    else
       passed_data.data = [passed_data.data tr(:,[3 4])];
    end
    % select voxels
% voxel_num=50;
% [passed_data.data, perw] = select_voxel(passed_data.data',voxel_num);
% passed_data.data = passed_data.data';
% [~,index]=sort(perw,'ascend');
% passed_data.mask_index = passed_data.mask_index(index(1:min(voxel_num,length(passed_data.mask_index))));
% passed_data.mask_each = {passed_data.mask_index};
%% data
[results,decfg]=decoding_test_5odors(passed_data,length(odors));
disp(results.confusion_matrix.output{1});
%% plot
% parameters
colors = {'#F16913','#41AB5D','#4292C6','#ECB556','#777DDD'};  
colors = cellfun(@(x) hex2rgb(x),colors,'UniformOutput',false);
dims = 2;
for dim_i=1:length(dims)
    n_dim = dims(dim_i);
    cur_roi = roi;
    label = cfg.files.label;
    mean_data = passed_data.data;
    % method
%     mapped = compute_mapping(data,'t-SNE', n_dim, init_dim, perplex);
    [mapped, mapping]= compute_mapping(mean_data,'PCA', size(mean_data,2));
    % get lambda
    mapped = mapped(:,1:n_dim);
    lambda = mapping.lambda;
    % variance explained
    var_exp = lambda ./ sum(lambda);
    var_cum = cumsum(var_exp);
    
    % scatter plot
    p_color = colors(label);
    p_size = 30;
    figure('Renderer','Painters');
    hold on
    for p_i = 1:length(unique(label))
        % 3-d
        if n_dim==3
            scatter3(mapped(label==p_i,1), mapped(label==p_i,2),...
                mapped(label==p_i,3), p_size, colors{p_i},'filled');
            zlabel(sprintf('PC3 (%.1f%% of variance)',100*var_exp(3)))
            grid on
            view(3) % view(-37.5,30)
            % view(37.5,30)
        else
            scatter(mapped(label==p_i,1), mapped(label==p_i,2), p_size, colors{p_i},'filled');
        end
    end
    xlabel(sprintf('PC1 (%.1f%% of variance)',100*var_exp(1)))
    ylabel(sprintf('PC2 (%.1f%% of variance)',100*var_exp(2)))    
    title([cur_roi],'Interpreter','none')
    legends = odors;
    legend(legends(1:length(unique(label))),'location','eastoutside')
    set(gca,'FontSize',18);
end
end