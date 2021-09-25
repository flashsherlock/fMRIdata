function [results,cfg]=decoding_roi_5odors_glm(passed_data,odornum)

    % Set defaults
    cfg = decoding_defaults;
    cfg.analysis = 'wholebrain';
    % Set the output directory where data will be saved, e.g. '/misc/data/mystudy'
%     cfg.results.dir = '/Volumes/WD_E/gufei/7T_odor/testglm';
%     if ~exist(cfg.results.dir,'dir')
%         mkdir(cfg.results.dir)
%     end
    
%     cfg.scale.method='z';
%     cfg.scale.estimation='all';
    % the parameters to be searched should accur here
    cfg.decoding.method='classification';
%     default -c 1 -g 1/feature large->overfit
%     -t 0 linear 1 polynomial 2 RBF
    cfg.decoding.train.classification.model_parameters = '-s 0 -t 2 -c 0.0001 -g 0.001 -b 0 -q';
%     cfg.parameter_selection.method='grid';
%     cfg.parameter_selection.parameters={'-c';'-g'};
%     cfg.parameter_selection.parameter_range={2.^(-8:2:8);2.^(-8:2:8)};
    
    cfg.files.labelname={};
    cfg.files.chunk=[];
    cfg.files.label=[];
    cfg.datainfo=[];
    cfg.results.write=0;
%     cfg.decoding.use_kernel=0;
%     odornum=5;
    numtr=size(passed_data.data,1);
    cfg.files.name=cell(numtr,1);
    for i=1:numtr
        cfg.files.name{i}=num2str(i);
    end
    passed_data.mask_index=1:size(passed_data.data,2);
    passed_data.mask_index_each=1;
    passed_data.dim=[1 1 size(passed_data.data,2)];
    repeat=numtr/odornum;
    % (1) a nx1 vector to indicate what data you want to keep together for 
    % cross-validation (typically runs, so enter run numbers)
    % each run is a chunk
    % cfg.files.chunk = reshape(repmat(1:6,[8 4]),[numtr 1]);
    % each trial is a chunk
    % cfg.files.chunk = [cfg.files.chunk; reshape(repmat(1 + 36 * (shift_i - 1):shift_i * 36, [1 5]), [numtr 1])];
    cfg.files.chunk = [cfg.files.chunk; reshape(repmat(1:repeat, [1 odornum]), [numtr 1])];
    %
    % (2) any numbers as class labels, normally we use 1 and -1. Each file gets a
    % label number (i.e. a nx1 vector)
    cfg.files.label = [cfg.files.label;reshape(repmat(1:odornum, [repeat 1]), [numtr 1])];
    % cfg.files.label = timing(:, 1);
    % cfg.files.labelname = [cfg.files.labelname;reshape(repmat({'lim' 'tra' 'car' 'cit' 'ind'}, [repeat 1]), [numtr 1])];

    % cfg = decoding_describe_data(cfg, {labelname1 labelname2 labelname3 labelname4}, [1 2 3 4], regressor_names, beta_loc);
    cfg.results.output = {'accuracy_minus_chance', 'confusion_matrix', 'model_parameters'};

    %% Nothing needs to be changed below for a standard leave-one-run out cross
    % This creates the leave-one-run-out cross validation design:
    cfg.design = make_design_cv(cfg); 

    % Run decoding
    [results,cfg]= decoding_glm(cfg,passed_data);    
end
