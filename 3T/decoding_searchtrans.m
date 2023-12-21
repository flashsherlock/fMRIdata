function decoding_searchtrans(sub, analysis_all, rois, shift, decode, con)
% This script is a template that can be used for a decoding analysis on 
% brain image data. It is for people who ran one deconvolution per run
% using AFNI and want to automatically extract the relevant images used for
% classification, as well as corresponding labels and decoding chunk numbers
% (e.g. run numbers). If you don't have this available, then use
% decoding_template_nobetas.m

% Make sure the decoding toolbox and afni_matlab are on the Matlab path
% (e.g. addpath('/home/decoding_toolbox') )
% addpath('$ADD FULL PATH TO TOOLBOX AS STRING OR MAKE THIS LINE A COMMENT IF IT IS ALREADY$')
% addpath('$ADD FULL PATH TO AFNI_MATLAB AS STRING OR MAKE THIS LINE A COMMENT IF IT IS ALREADY$')

datafolder='/Volumes/WD_F/gufei/3t_cw/';
% time shift for peak response
% shift=6;
for i_analysis=1:length(analysis_all)
    analysis=analysis_all{i_analysis};
    % rois = {'BoxROIext'};
    rois = {'epi_anat'};
for i=1:length(rois)
    roi=rois{i};
    % mask=get_filenames_afni([datafolder sub '/mask/' roi '*+orig.HEAD']);
    mask=get_filenames_afni([datafolder sub '/' sub '.' analysis '.results/mask_' roi '*+orig.HEAD']);
    % avoid matching too many files
    mask=mask(1,:);
    % Set defaults
    cfg = decoding_defaults;

    % Make sure to set software to AFNI
    cfg.software = 'AFNI';
    
    % Set the analysis that should be performed (default is 'searchlight')
    cfg.analysis = 'searchlight';
    test = [con '_' roi];
    cfg.searchlight.radius = 4; % use searchlight of radius 4 (by default in voxels), see more details below

    % Set the output directory where data will be saved, e.g. '/misc/data/mystudy'
    cfg.results.dir = [datafolder sub '/' sub '.' analysis '.results/mvpa/' cfg.analysis '_' 'trans_shift' strrep(num2str(shift), ' ', '') '/' test];
    if ~exist(cfg.results.dir,'dir')
        mkdir(cfg.results.dir)
    end
    
    cfg.files.name={};
    cfg.files.labelname={};
    cfg.files.chunk=[];
    cfg.files.label=[];

    % tr stores all the timing information
    tr = [];
    for data_code=1:2
    for shift_i=1:length(shift)
        timing=findtrs3t(shift(shift_i),sub);        
        tr = [tr;timing];
        numtr=8*5*3;
        F=cell(1,numtr);
        for subi = 1:numtr
            t=timing(subi,2);
            F{subi} = [datafolder sub '/' sub '.' analysis '.results/'  'NIerrts.' sub '.' analysis '.odor_noblur+orig.BRIK,' num2str(t)];
        end
        cfg.files.name = [cfg.files.name F];        
        % and the other two fields if you use a make_design function (e.g. make_design_cv)
        %
        % (1) a nx1 vector to indicate what data you want to keep together for 
        % cross-validation (typically runs, so enter run numbers)
        % each trial is a chunk
        cfg.files.chunk = [cfg.files.chunk; reshape(repmat(1:15, [1 8]), [numtr 1])];
        % decoding faces
        switch data_code
            case 1
            % face emotion
            cfg.files.label = [cfg.files.label;reshape(repmat([1 1 1 1 2 2 2 2], [15 1]), [numtr 1])];
            names={'Fear','Fear','Fear','Fear','Happy','Happy','Happy','Happy'};
            case 2
            % odor emotion
            cfg.files.label = [cfg.files.label;reshape(repmat([1 1 2 2 1 1 2 2], [15 1]), [numtr 1])];
            names={'Plea','Plea','Unplea','Unplea','Plea','Plea','Unplea','Unplea'};
        end
        % cfg.files.label = timing(:, 1);
        % names={'FearPleaVis','FearPleaInv','FearUnpleaVis','FearUnpleaInv',...
        %       'HappPleaVis','HappPleaInv','HappUnpleaVis','HappUnpleaInv'};              
        cfg.files.labelname = [cfg.files.labelname;reshape(repmat(names, [15 1]), [numtr 1])];        
    end
    end
    %% Decide whether you want to see the searchlight/ROI/... during decoding
    cfg.plot_selected_voxels = 500; % 0: no plotting, 1: every step, 2: every second step, 100: every hundredth step...

    %% apply mask
    cfg.files.mask = mask;
    %% Add additional output measures if you like
    % See help decoding_transform_results for possible measures

    % cfg.results.output = {'accuracy_minus_chance', 'AUC'}; % 'accuracy_minus_chance' by default
    % TDT allows you to run multiclass searchlight analysis. I assume you
    % use decoding_template as a template (see decoding_tutorial for a more
    % detailed version of it). Then you set:

    % cfg = decoding_describe_data(cfg, {labelname1 labelname2 labelname3 labelname4}, [1 2 3 4], regressor_names, beta_loc);
    cfg.results.output = {'confusion_matrix','predicted_labels','true_labels'};

    % You can also use all methods that start with "transres_", e.g. use
    %   cfg.results.output = {'SVM_pattern'};
    % will use the function transres_SVM_pattern.m to get the pattern from 
    % linear svm weights (see Haufe et al, 2015, Neuroimage)

    %% Nothing needs to be changed below for a standard leave-one-run out cross    
    % load data the standard way
    [passed_data, ~, cfg] = decoding_load_data(cfg);
    % add run number and repeat num as features    
    combine = 0;
    if combine == 1
       nsample = size(passed_data.data, 1);
       nvoxel = size(passed_data.data, 2);
       passed_data.data = reshape(passed_data.data,[nsample/length(shift),length(shift),nvoxel]);
       % subtract baseline trs
       base = find(shift<0);       
       if ~isempty(base)
           % average baseline
           baseline = squeeze(mean(passed_data.data(:,base,:), 2));
           passed_data.data = squeeze(mean(passed_data.data(:,shift>=0,:), 2))-baseline;
       else
           passed_data.data = squeeze(mean(passed_data.data, 2));       
       end
       % change design
       cfg.files.name = cfg.files.name(1:nsample/length(shift));
       cfg.files.chunk = cfg.files.chunk(1:nsample/length(shift));
       cfg.files.label = cfg.files.label(1:nsample/length(shift));
       cfg.files.labelname = cfg.files.labelname(1:nsample/length(shift));
       passed_data.files.name = passed_data.files.name(1:nsample/length(shift));
    end
    % This creates the leave-one-run-out cross validation design:
    cfg.design = make_design_cv(cfg);     
    invisible = kron([1;1],reshape(repmat([0 1 0 1 0 1 0 1], [15 1]), [numtr 1]));
%     congruent = kron([1;1],reshape(repmat([0 0 1 1 1 1 0 0], [15 1]), [numtr 1]));
    facetrial = kron([1;0],reshape(repmat([1 1 1 1 1 1 1 1], [15 1]), [numtr 1]));
    % decoding training conditions 
    switch decode
        case 'face'  
            % on face
            cfg.design.test(facetrial==0,:) = 0;   
            cfg.design.train(facetrial==0,:) = 0;  
        case 'odor'  
            % on odor
            cfg.design.test(facetrial==1,:) = 0; 
            cfg.design.train(facetrial==1,:) = 0; 
        case 'of'  
            % test on face
            cfg.design.test(facetrial==0,:) = 0;   
            % train on odors
            cfg.design.train(facetrial==1,:) = 0;  
        case 'fo'  
            % test on odors
            cfg.design.test(facetrial==1,:) = 0; 
            % train on faces
            cfg.design.train(facetrial==0,:) = 0; 
    end
    switch con
        case 'vis_inv'                       
            % train on visible    
            cfg.design.train(invisible==1,:) = 0;
            % test on invisible
            cfg.design.test(invisible==0,:) = 0;   
        case 'inv_vis'                       
            % train on invisible    
            cfg.design.train(invisible==0,:) = 0;
            % test on visible
            cfg.design.test(invisible==1,:) = 0;   
        case 'train_vis'                       
            % train on visible    
            cfg.design.train(invisible==1,:) = 0;  
        case 'train_inv'                       
            % train on invisible    
            cfg.design.train(invisible==0,:) = 0;
        case 'test_vis'                       
            % test on visible    
            cfg.design.test(invisible==1,:) = 0;  
        case 'test_inv'                       
            % test on invisible    
            cfg.design.test(invisible==0,:) = 0;
    end
    % overwrite existing results
    cfg.results.overwrite = 1;
    cfg.basic_checks.DoubleFilenameEntriesOk = 1;
    % Run decoding
    decoding(cfg, passed_data);   
    
end
end
end
