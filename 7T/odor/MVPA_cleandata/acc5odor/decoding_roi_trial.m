function decoding_roi_trial(sub,analysis_all,rois,shift)
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
% subn=1;
% sub='S01_yyt';
% datafolder='/Volumes/WD_E/gufei/7T_odor/';
datafolder='/Volumes/WD_F/gufei/7T_odor/';
% analysis_all={'pabiode','paphde','pade'};
% rois={'Amy','Piriform','APC','PPC','corticalAmy','Amy9'};
% for region=[1 3 5 6 7 8 9 10 15]
%     rois=[rois {['Amy_' num2str(region) 'seg']}];
% end
% rois=[rois {'Amy9_align','corticalAmy_align'}];
% for region=[1 3 5 6 7 8 9 10 15]
%     rois=[rois {['Amy_align' num2str(region) 'seg']}];
% end
odors={'lim','tra','car','cit','ind'};
comb=nchoosek(1:length(odors), 2);
% shift=6;
for i_analysis=1:length(analysis_all)
    analysis=analysis_all{i_analysis};
    % Amy_seg starts from 7
for roi_i=1:length(rois)
    roi=rois{roi_i};
    mask=get_filenames_afni([datafolder sub '/mask/' roi '*+orig.HEAD']);
    % Amy will match too many files
    if roi_i==1
        mask=mask(1,:);
    end
parfor i=1:length(comb)
    odornumber=comb(i,:);
    % Set defaults
    cfg = decoding_defaults;

    % Make sure to set software to AFNI
    cfg.software = 'AFNI';
    
    % model_parameters
%     cfg.decoding.method='classification';
%     cfg.decoding.train.classification.model_parameters = '-s 0 -t 2 -c 0.001 -g 0.001 -b 0 -q';
%     cfg.results.overwrite = 1;
%     cfg.parameter_selection.method='grid';
%     cfg.parameter_selection.parameters={'-c';'-g'};
%     cfg.parameter_selection.parameter_range={10.^(-6:1:6);10.^(-6:1:6)};
    % Set the analysis that should be performed (default is 'searchlight')
    cfg.analysis = 'roi';
    labelname1 = odors{odornumber(1)};
    labelname2 = odors{odornumber(2)};
    test=[roi '/' '2odors_' labelname1 '_' labelname2];
    cfg.searchlight.radius = 3; % use searchlight of radius 3 (by default in voxels), see more details below

    % Set the output directory where data will be saved, e.g. '/misc/data/mystudy'
    cfg.results.dir = [datafolder sub '/' sub '.' analysis '.results/mvpa/' cfg.analysis '_ARodor_l1_labelpolandva_' strrep(num2str(shift), ' ', '') '/' test];
    if ~exist(cfg.results.dir,'dir')
        mkdir(cfg.results.dir)
    end
    
    cfg.files.name = {};
    cfg.files.labelname = {};
    cfg.files.chunk = [];
    cfg.files.label = [];
    
    % tr stores all the timing information
    tr = [];
    for shift_i = 1:length(shift)
        timing = findtrs(shift(shift_i), sub);
        % images selected by odornumber
        timing = timing(timing(:, 1) == odornumber(1) | timing(:, 1) == odornumber(2), :);
        tr = [tr;timing];
        numtr=6*6*2;
        F=cell(1,numtr);
        for subi = 1:numtr
            t=timing(subi,2);
            F{subi} = [datafolder sub '/' sub '.' analysis '.results/'  'NIerrts.' sub '.' analysis '.onlypolandva+orig.BRIK,' num2str(t)];
%             F{subi} = [datafolder sub '/' sub '.' analysis '.results/'  'NIfittshead.' sub '.' analysis '.odorVIva_noblur+orig.BRIK,' num2str(t)];
            % F{subi} = [datafolder sub '/' sub '.' analysis '.results/'  'allrun.volreg.' sub '.' analysis '+orig.BRIK,' num2str(t)];
        end
        cfg.files.name = [cfg.files.name F];
        % and the other two fields if you use a make_design function (e.g. make_design_cv)
        %
        % (1) a nx1 vector to indicate what data you want to keep together for 
        % cross-validation (typically runs, so enter run numbers)
        % each run is a chunk
        % cfg.files.chunk = reshape(repmat(1:6,[8 2]),[numtr 1]);
        % each trial is a chunk
%         cfg.files.chunk = [cfg.files.chunk; reshape(repmat(1 + 36 * (shift_i - 1):shift_i * 36, [1 2]), [numtr 1])];
        cfg.files.chunk = [cfg.files.chunk; reshape(repmat(1:36, [1 2]), [numtr 1])];
        %
        % (2) any numbers as class labels, normally we use 1 and -1. Each file gets a
        % label number (i.e. a nx1 vector)
        % 1-lim 2-tra 3-car 4-cit 5-ind
        cfg.files.label = [cfg.files.label;reshape(repmat([odornumber(1) odornumber(2)], [36 1]), [numtr 1])];
        cfg.files.labelname = [cfg.files.labelname;reshape(repmat({labelname1 labelname2}, [36 1]), [numtr 1])];
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
    cfg.results.output = {'confusion_matrix','predicted_labels','true_labels','model_parameters'};

    % You can also use all methods that start with "transres_", e.g. use
    %   cfg.results.output = {'SVM_pattern'};
    % will use the function transres_SVM_pattern.m to get the pattern from 
    % linear svm weights (see Haufe et al, 2015, Neuroimage)

    %% Nothing needs to be changed below for a standard leave-one-run out cross    
    % load data the standard way
    [passed_data, ~, cfg] = decoding_load_data(cfg);
    % add run number and repeat num as features
    combine = 1;
    if combine == 1
       nsample = size(passed_data.data, 1);
       nvoxel = size(passed_data.data, 2);
       passed_data.data = reshape(passed_data.data,[nsample/length(shift),length(shift),nvoxel]);
       passed_data.data = squeeze(mean(passed_data.data, 2));
       % passed_data.data = [passed_data.data tr(1:nsample/length(shift),[3 4])];
       % change design
       cfg.files.name = cfg.files.name(1:nsample/length(shift));
       cfg.files.chunk = cfg.files.chunk(1:nsample/length(shift))
       % run as chunk
       % cfg.files.chunk = tr(1:nsample/length(shift),3);
       % rept as chunk
       % cfg.files.chunk = tr(1:nsample/length(shift),4);
       cfg.files.label = cfg.files.label(1:nsample/length(shift));
       cfg.files.labelname = cfg.files.labelname(1:nsample/length(shift));
    else
       passed_data.data = [passed_data.data tr(:,[3 4])];
    end
    % This creates the leave-one-run-out cross validation design:
    cfg.design = make_design_cv(cfg); 
    % Run decoding
    cfg.results.overwrite = 1
    decoding(cfg, passed_data);    
end
end
end
end
% some warnings
% there may be errors when saving fig because of replacing . with _
% edit save_fig.m
    
% Results for output confusion_matrix and roi
% 'Piriform.S01_yyt' cannot be written, because the format is wrong
% (e.g. leave-one-run-out with more than one output per run). 

% You can trust the result. The confusion matrix cannot be written as an
% image. Sorry for the confusion with the warning (pun intended)
% http://web.bccn-berlin.de/pipermail/tdt_list/2016-May/000118.html
