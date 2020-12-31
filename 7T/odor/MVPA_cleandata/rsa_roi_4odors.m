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
sub='S01_yyt';
analysis='pabiode';
rois={'Amy','Piriform','APC','PPC'};

for i=1%:length(rois)
    roi=rois{i};
    mask=get_filenames_afni(['/Volumes/WD_D/gufei/7T_odor/' sub '/' sub '.' analysis '.results/mvpamask/' roi '*+orig.HEAD']);
    % Set defaults
    cfg = decoding_defaults;

    % Make sure to set software to AFNI
    cfg.software = 'AFNI';

    % Set the analysis that should be performed (default is 'searchlight')
    cfg.analysis = 'roi';
    test=['4odors_' roi];
    cfg.searchlight.radius = 3; % use searchlight of radius 3 (by default in voxels), see more details below

    % set everything to similarity analysis (for available options as model parameters, check decoding_software/pattern_similarity/pattern_similarity.m)
    cfg.decoding.software = 'similarity';
    cfg.decoding.method = 'classification';
    cfg.decoding.train.classification.model_parameters = 'pearson'; % this is pearson correlation
    
    % Set the output directory where data will be saved, e.g. '/misc/data/mystudy'
    cfg.results.dir = ['/Volumes/WD_D/gufei/7T_odor/' sub '/' sub '.' analysis '.results/rsa/' cfg.analysis '/' test];
    if ~exist(cfg.results.dir,'dir')
        mkdir(cfg.results.dir)
    end
    % Set the full path to the files where your coefficients for each run are stored e.g. 
    % {'/misc/data/mystudy/results1+orig.BRIK','/misc/data/mystudy/results2+orig.BRIK',...}
    %    If all your BRIK files are in the same folder, you can use the
    %    following function to call them all together in one line:
    %    beta_loc = get_filenames_afni('/misc/data/mystudy/results*+orig.BRIK');
    beta_loc = get_filenames_afni(['/Volumes/WD_D/gufei/7T_odor/' sub '/' sub '.' analysis '.results/stats*Run*+orig.BRIK']);

    % Set the filename of your brain mask (or your ROI masks as cell matrix) 
    % for searchlight or wholebrain e.g. '/misc/data/mystudy/mask+orig.BRIK' OR 
    % for ROI e.g. {'/misc/data/mystudy/roimask1+orig.BRIK', '/misc/data/mystudy/roimask2+orig.BRIK'}
    % You can also use a mask file with multiple masks inside that are
    % separated by different integer values (a "multi-mask")
    %
    % If you don't have a brain mask, use 3dAutomask or run the following (both may fail if you have scaled your input data in AFNI!)
    % cfg.files.mask = decoding_create_maskfile(cfg,beta_loc);
    cfg.files.mask = mask;

    % Set the label names to the regressor names which you want to use for 
    % decoding, e.g. 'button left' and 'button right'
    % don't remember the names? -> run display_regressor_names(beta_loc)
    labelname1 = 'lim';
    labelname2 = 'tra';
    labelname3 = 'car';
    labelname4 = 'cit';

    %% Decide whether you want to see the searchlight/ROI/... during decoding
    cfg.plot_selected_voxels = 500; % 0: no plotting, 1: every step, 2: every second step, 100: every hundredth step...

    %% Add additional output measures if you like
    % See help decoding_transform_results for possible measures

    % cfg.results.output = {'accuracy_minus_chance', 'AUC'}; % 'accuracy_minus_chance' by default
    % TDT allows you to run multiclass searchlight analysis. I assume you
    % use decoding_template as a template (see decoding_tutorial for a more
    % detailed version of it). Then you set:

    % cfg = decoding_describe_data(cfg, {labelname1 labelname2 labelname3 labelname4}, [1 2 3 4], regressor_names, beta_loc);
    cfg.results.output = {'other_average'};

    % You can also use all methods that start with "transres_", e.g. use
    %   cfg.results.output = {'SVM_pattern'};
    % will use the function transres_SVM_pattern.m to get the pattern from 
    % linear svm weights (see Haufe et al, 2015, Neuroimage)

    %% Nothing needs to be changed below for a standard leave-one-run out cross
    %% validation analysis.

    % The following function extracts all beta names and corresponding run
    % numbers from the SPM.mat
    regressor_names = design_from_afni(beta_loc);

    % Extract all information for the cfg.files structure (labels will be [1 -1] )
    % cfg = decoding_describe_data(cfg,{labelname1 labelname2},[1 -1],regressor_names,beta_loc);
    cfg = decoding_describe_data(cfg, {labelname1 labelname2 labelname3 labelname4}, [1 2 3 4], regressor_names, beta_loc);
    % This creates the leave-one-run-out cross validation design:
    cfg.design = make_design_rsa_cv(cfg); 

    % Run decoding
    results = decoding(cfg);    
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
