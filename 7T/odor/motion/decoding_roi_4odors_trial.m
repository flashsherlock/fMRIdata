function decoding_roi_4odors_trial(sub,analysis_all,rois,shift,run,fname)
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
if nargin<6
    fname='odorVIva_noblur';
end
if nargin<5
    run=1:6;
end
datafolder='/Volumes/WD_E/gufei/7T_odor/';
% analysis_all={'pabiode','paphde','pade'};
% rois={'Amy','Piriform','APC','PPC','corticalAmy','Amy9'};
% for region=[1 3 5 6 7 8 9 10 15]
%     rois=[rois {['Amy_' num2str(region) 'seg']}];
% end
% rois=[rois {'Amy9_align','corticalAmy_align'}];
% for region=[1 3 5 6 7 8 9 10 15]
%     rois=[rois {['Amy_align' num2str(region) 'seg']}];
% end
% time shift for peak response
% shift=6;
for i_analysis=1:length(analysis_all)
    analysis=analysis_all{i_analysis};
    % Amy_seg starts from 7
    % Amy_align stars from 16
parfor i=1:length(rois)
    roi=rois{i};
    mask=get_filenames_afni([datafolder sub '/mask/' roi '*+orig.HEAD']);
    % Amy will match too many files
    if i==1
        mask=mask(1,:);
    end
    % Set defaults
    cfg = decoding_defaults;

    % Make sure to set software to AFNI
    cfg.software = 'AFNI';

    % Set the analysis that should be performed (default is 'searchlight')
    cfg.analysis = 'roi';
    test=['4odors_' roi];
    cfg.searchlight.radius = 3; % use searchlight of radius 3 (by default in voxels), see more details below

    % Set the output directory where data will be saved, e.g. '/misc/data/mystudy'
    cfg.results.dir = [datafolder sub '/' sub '.' analysis '.results/mvpa/' cfg.analysis '_VIvaodor_l1_label_' num2str(shift) '/' test];
    if ~exist(cfg.results.dir,'dir')
        mkdir(cfg.results.dir)
    end
    
    timing1 = findtrs(shift,'S01_yyt');
    timing2 = findtrs(shift,sub,run(7:end)-6);
    timing2(:,2)=timing2(:,2)+780;
    timing = [timing1;timing2];
    timing = sortrows(timing);
    % Full path to file names (1xn cell array) (e.g.
    % {'c:\exp\glm\model_button\im1.nii', 'c:\exp\glm\model_button\im2.nii', ... }
    % lim tra car cit
    tr=timing(:,2);
    numtr=length(run)*8*4;
    F=cell(1,numtr);
    for subi = 1:numtr
        t=tr(subi);
        F{subi} = [datafolder sub '/' sub '.' analysis '.results/'  'NIerrts.' sub '.' analysis '.' fname '+orig.BRIK,' num2str(t)];
    end
    cfg.files.name =  F;
    % and the other two fields if you use a make_design function (e.g. make_design_cv)
    %
    % (1) a nx1 vector to indicate what data you want to keep together for 
    % cross-validation (typically runs, so enter run numbers)
    % each run is a chunk
    % cfg.files.chunk = reshape(repmat(1:6,[8 4]),[numtr 1]);
    % each trial is a chunk
    cfg.files.chunk = reshape(repmat(1:length(run) * 8, [1 4]), [numtr 1]);
    %
    % (2) any numbers as class labels, normally we use 1 and -1. Each file gets a
    % label number (i.e. a nx1 vector)
    % 1-lim 2-tra 3-car 4-cit
    cfg.files.label = reshape(repmat([1 2 3 4],[length(run)*8 1]),[numtr 1]);
    % cfg.files.label = timing(:, 1);
    cfg.files.labelname = reshape(repmat({'lim' 'tra' 'car' 'cit'},[length(run)*8 1]),[numtr 1]);
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
    cfg.results.output = {'accuracy_minus_chance', 'confusion_matrix','predicted_labels','true_labels'};

    % You can also use all methods that start with "transres_", e.g. use
    %   cfg.results.output = {'SVM_pattern'};
    % will use the function transres_SVM_pattern.m to get the pattern from 
    % linear svm weights (see Haufe et al, 2015, Neuroimage)

    %% Nothing needs to be changed below for a standard leave-one-run out cross
    % This creates the leave-one-run-out cross validation design:
    cfg.design = make_design_cv(cfg); 

    % Run decoding
    results = decoding(cfg);    
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
