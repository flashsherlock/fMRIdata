function [results, cfg] = odor_decoding_function(passed_data, odornum)
% Set defaults
cfg = decoding_defaults;
cfg.analysis = 'wholebrain';

%     cfg.scale.method='z';
%     cfg.scale.estimation='all';
% the parameters to be searched should accur here
cfg.decoding.method = 'classification';
%     default -c 1 -g 1/feature large->overfit
%     -t 0 linear 1 polynomial 2 RBF
% cfg.decoding.train.classification.model_parameters = '-s 0 -t 2 -c 0.0001 -g 0.001 -b 0 -q';
%     cfg.parameter_selection.method='grid';
%     cfg.parameter_selection.parameters={'-c';'-g'};
%     cfg.parameter_selection.parameter_range={2.^(-8:2:8);2.^(-8:2:8)};

cfg.files.labelname = {};
cfg.files.chunk = [];
cfg.files.label = [];
cfg.datainfo = [];
cfg.results.write = 0;

%     odornum=5;
numtr = size(passed_data.data, 1);
cfg.files.name = cell(numtr, 1);

for i = 1:numtr
    cfg.files.name{i} = num2str(i);
end

passed_data.mask_index = 1:size(passed_data.data, 2);
passed_data.mask_index_each = 1;
passed_data.dim = [1 1 size(passed_data.data, 2)];
repeat = numtr / odornum;

cfg.files.chunk = [cfg.files.chunk; reshape(repmat(1:repeat, [1 odornum]), [numtr 1])];
%
% (2) any numbers as class labels, normally we use 1 and -1. Each file gets a
% label number (i.e. a nx1 vector)
cfg.files.label = [cfg.files.label; reshape(repmat(1:odornum, [repeat 1]), [numtr 1])];

cfg.results.output = {'accuracy_minus_chance', 'confusion_matrix'};

cfg.design = make_design_cv(cfg);

% Run decoding
[results, cfg] = decoding_odor(cfg, passed_data);

%% Main start
function [results, cfg, passed_data, misc] = decoding_odor(cfg, passed_data, misc)

%% Prepare decoding analysis

cfg = decoding_defaults(cfg); % set defaults
cfg.feature_transformation = inherit_settings(cfg.feature_transformation,cfg,'analysis','software','verbose','decoding');
cfg.parameter_selection    = inherit_settings(cfg.parameter_selection,cfg,'analysis','software','verbose','decoding');
cfg.feature_selection      = inherit_settings(cfg.feature_selection,cfg,'analysis','software','verbose','decoding');
cfg.feature_selection      = decoding_defaults(cfg.feature_selection);

cfg.progress.starttime = datestr(now);

global verbose % MH: don't worry, Kai, this is the only case where global is better than passing!! ;)
global reports % and this is the second only case (there actually is a third somewhere else)...
verbose = cfg.verbose;
reports = []; % init

% Display version
ver = 'The Decoding Toolbox (by Martin Hebart & Kai Goergen), v2020/06/17 3.999'; % also change header of this file and in LOG.txt (maybe year in LICENSE.txt)
cfg.info.ver = ver;
dispv(1,ver)
dispv(1,'Preparing analysis: ''%s''',cfg.analysis)

%% Basic checks

[cfg, n_files, n_steps] = decoding_basic_checks(cfg,nargout); %#ok<ASGLU>
if ~exist('misc','var'), misc = []; end

%% Plot and save design as graphics if requested

% cfg = tdt_plot_design_init(cfg);

%% Open file to write all filenames that we load

if cfg.results.write
    % Open filename to save details for each decoding step
    inputfilenames_fname = [cfg.results.filestart '_filedetails.txt'];
    inputfilenames_fpath = fullfile(cfg.results.dir,inputfilenames_fname);
    dispv(1,'Writing input filenames for each decoding iteration to %s', inputfilenames_fpath)
    inputfilenames_fid = fopen(inputfilenames_fpath, 'wt');
else
    inputfilenames_fid = '';
end

%% Load masked data

if exist('passed_data', 'var') && ~isempty(passed_data)
    % check that passed_data fits to cfg, otherwise load data from files
%     [passed_data, misc, cfg] = decoding_load_data(cfg, misc, passed_data);
else
    % load data the standard way
    [passed_data, misc, cfg] = decoding_load_data(cfg, misc);
end

% unpack all fields from passed_data to shorten names in this function
data = passed_data.data;
mask_index = passed_data.mask_index;
if isfield(passed_data, 'mask_index_each')
    % do nothing
elseif isfield(cfg.files, 'mask') && length(cfg.files.mask) <= 1
    dispv(1, 'Filling passed_data.mask_index_each with data from passed_data.mask_index, because mask_index_each is not provided and one or less masks are used.')
    passed_data.mask_index_each = {passed_data.mask_index};
else
    error('passed_data is used and multiple mask files are provided, but indices of this masks, that should be provided in passed_data.mask_index_each, are not. Please provide these or use only one mask.')
end
mask_index_each = passed_data.mask_index_each;
sz = passed_data.dim;

%% If requested, load miscellaneous data (e.g. residuals or raw data)
misc = decoding_load_misc(cfg, passed_data, misc);

%% Check if result data should be used to only calculate transformations

cfg = tdt_check_transform_only(cfg,passed_data,mask_index);

%% Prepare the decoding

% Scale all data in advance if requested
if strcmpi(cfg.scale.estimation,'all')
    dispv(1,'Scaling all data, using scaling method %s',cfg.scale.method)
    if ~isfield(misc,'residuals')
        data = decoding_scale_data(cfg,data);
    else
        data = decoding_scale_data(cfg,data,[],misc.residuals);
    end
end

% Get number of decodings for searchlight and number of ROIs for ROI (and 1 for wholebrain)
[n_decodings,decoding_subindex] = get_n_decodings(cfg,mask_index,mask_index_each,sz);

% Initialize results vectors
n_outputs = length(cfg.results.output);
cfg.design.n_sets = length(unique(cfg.design.set));

% Set kernel method if used
use_kernel = cfg.decoding.use_kernel;

% Prepare searchlight template (sl_template will be empty for other methods than searchlight)
[cfg,sl_template] = decoding_prepare_searchlight(cfg);

% Initialize results vector and save some information to results, including mask_index and n_decodings
results = tdt_prepare_results(cfg,mask_index,passed_data,n_decodings,n_outputs,decoding_subindex);


%% PERFORM Decoding Analysis

dispv(1,'Starting decoding...')

% Save start time (for time estimate)
start_time = now;

% Preloading
msg_length = [];
previous_fs_data = []; % init
kernel = []; % init
model = []; % init

% init states of parameter_selection, feature_selection, and scaling
feature_transformation_all_on = strcmpi(cfg.feature_transformation.estimation,'all');
feature_transformation_across_on = strcmpi(cfg.feature_transformation.estimation,'across');
parameter_selection_on = ~strcmpi(cfg.parameter_selection.method,'none');
feature_selection_on = ~strcmpi(cfg.feature_selection.method,'none');
scaling_iter_on = strcmpi(cfg.scale.estimation,'all_iter');
scaling_across_on = strcmpi(cfg.scale.estimation,'across');
scaling_separate_on = strcmpi(cfg.scale.estimation,'separate');

% Warn if test mode
if cfg.testmode
    warningv('DECODING:testmode','TEST MODE: Only one decoding step is calculated!');
    n_decodings = 1;
end

% Report files
report_files(cfg,n_steps,inputfilenames_fid);

% General remark how final accuracy values are calculated before we start
if cfg.verbose == 1
    dispv(1, 'All samples in final estimate (e.g. accuracy) weighted equally (see README.txt)...')
elseif cfg.verbose == 2
    dispv(2, sprintf(['\n', ...
    'General remark: The final accuracy (and most other measures) for each voxel is calculated by weighting all test examples equally.\n', ...
    'This means that if e.g. one decoding step contains 2 test examples, and another contains 5, the average of all 7 will be taken.\n', ...
    'If you want to weight all decoding steps equally, please use cfg.results.setwise=1 and cfg.design.set = 1:length(cfg.design.set) and average over the resulting output images']))
end

if scaling_separate_on || scaling_iter_on
    dispv(1,'Using scaling estimation type: %s',cfg.scale.estimation)
end

lasttime = now; % for updating figures

% Start
for i_decoding = 1:n_decodings % e.g. voxels for searchlight (decoding_subindex in most cases is 1:n_decodings)
    
    % Display status info (i.e. how far is the analysis?)
    if verbose, [msg_length] = display_progress(cfg,i_decoding,n_decodings,start_time,msg_length); end
    % update display every 500ms
    if cfg.plot_design && (now - lasttime)*24*60*60 > .5
        drawnow; lasttime = now;
    end
    
    curr_decoding = decoding_subindex(i_decoding); % if cfg.searchlight.subset wasn't called, then curr_decoding is identical to i_decoding

    % Get the current maskindices (e.g. of the current searchlight or of the current ROI)
    indexindex = get_ind(cfg,mask_index,curr_decoding,sz,sl_template,passed_data);
    current_data = data(:,indexindex);
    
    % Scale current data if it is done separately
    if scaling_separate_on
        current_data = tdt_scale_separate(cfg,current_data,misc,indexindex);
    end
    
    % Scale current data if it should be done together but iteratively
    if scaling_iter_on
        current_data = tdt_scale_iter(cfg,current_data,misc,indexindex);
    end
    
    % Plot selected voxels online if requested
    cfg = tdt_plot_selected_voxels(cfg, i_decoding, n_decodings, mask_index, indexindex, sz, data(1, :));

    % Data transformation (e.g. PCA) if requested
    if feature_transformation_all_on
        [cfg,current_data] = decoding_feature_transformation(cfg,current_data);
    end
    
    % init variables that are used to check whether the previous training
    % set equals the current decoding (used below to skip these trainings)
    previous_i_train = []; % init
    previous_trainlabels = []; % init
    
    if use_kernel
        % kernel passing is most often much faster for cross-validation.
        % default is linear kernel (see decoding_defaults)
        kernel = cfg.decoding.kernel.function(current_data,current_data);
    end

    % Loop over design columns (e.g. cross-validation runs)
    for i_step = 1:n_steps
        
        % Display status info (step in decoding 1, useful for large design)
        if verbose && i_decoding == 1 && (any(i_step == [5 10 100 500]) || mod(i_step, 1000) == 0)
            [msg_length] = display_progress(cfg,(i_decoding-1)+i_step/n_steps,n_decodings,start_time,msg_length,sprintf('(decoding %i/%i, step %i/%i)',i_decoding,n_decodings,i_step,n_steps)); 
        end
        
        % Get indices for training
        i_train = find(cfg.design.train(:, i_step) > 0);
        % Get indices for testing
        i_test = find(cfg.design.test(:, i_step) > 0);

        % Separate current data in training and test data
        [data_train,data_test] = tdt_get_train_test(cfg,current_data,kernel,use_kernel,i_train,i_test);
        
        labels_train = cfg.design.label(i_train, i_step);
        labels_test = cfg.design.label(i_test, i_step);

        % Skip feature selection and training if training set & training
        % labels are identical to previous iteration (saves time)
        % never skip on first decoding step
        skip_training = i_step~=1 & isequal(previous_i_train, i_train) & isequal(previous_trainlabels, labels_train);
        
        % also skip training if data should be used directly
        if cfg.decoding.use_loaded_results
            if i_decoding == 1 && i_step == 1
                warningv('decoding:skip_training_loading_results', 'NEVER EXECUTING TRAINING because results should be loaded from data (cfg.decoding.use_loaded_results = 1)');
            end
            skip_training = true;
        end
        
        % Data transformation (e.g. PCA) applied to training data and extended to test data if requested
        if feature_transformation_across_on
            [cfg,data_train,data_test] = decoding_feature_transformation(cfg,data_train,data_test);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Parameter selection (e.g. optimize C for SVM) %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if parameter_selection_on && ~skip_training
            cfg = decoding_parameter_selection(cfg,data_train,i_train);
        end

        %%%%%%%%%%%%%%%%%%%%%
        % Feature selection %
        %%%%%%%%%%%%%%%%%%%%%
        if feature_selection_on
            if ~skip_training
                % Step 1: Pack
                [fs_data, skip_feature_selection] = ...
                    decoding_prepare_feature_selection(cfg,i_train,i_test,i_step,current_data,mask_index(indexindex),previous_fs_data);
                % Step 2: Perform feature selection method
                if ~skip_feature_selection
                    [fs_index,fs_results,previous_fs_data] = decoding_feature_selection(cfg,fs_data);
                end
                results.feature_selection(i_decoding).n_vox_selected(i_step) = fs_results.n_vox_selected;
                results.feature_selection(i_decoding).n_vox_steps{i_step} = fs_results.n_vox_steps;
                results.feature_selection(i_decoding).output{i_step} = fs_results.output;
                results.feature_selection(i_decoding).curr_decoding = curr_decoding;
                results.feature_selection(i_decoding).fs_index{i_step} = fs_results.fs_index;
            end
            % Step 3: Select features (unless 'all' is selected which would be double dipping)
            if ~strcmpi(cfg.feature_selection.estimation,'all')
                data_train = data_train(:,fs_index); % if training was skipped, use fs_index from previous iteration
                data_test = data_test(:,fs_index);
            end
        end


        %%%%%%%%%%%%%%%%%%%%
        % PERFORM DECODING %
        %%%%%%%%%%%%%%%%%%%%

        %   TRAIN DATA    %
        %%%%%%%%%%%%%%%%%%%
        
        % Do scaling on training set if requested
        if ~skip_training && scaling_across_on
            if i_decoding == 1 && i_step == 1, dispv(1,'Using scaling estimation type: %s',cfg.scale.estimation), end
            [data_train,scaleparams] = decoding_scale_data(cfg,data_train);
        end
        
        if skip_training
            if ~cfg.decoding.use_loaded_results
                % use model from previous step
                model = decoding_out(i_step-1).model;
            end
        else
            % e.g. when software is libsvm, then:
            % model = libsvm_train(labels_train,data_train,cfg);
            model = cfg.decoding.fhandle_train(labels_train,data_train,cfg);
        end

        % store current training indices & training labels to check if they
        % are equal in the next decoding step
        previous_i_train = cfg.design.train(:,i_step); % update for next step
        previous_trainlabels = labels_train;

        %    TEST DATA    %
        %%%%%%%%%%%%%%%%%%%

        % Do scaling on test data if requested
        if scaling_across_on
            data_test = decoding_scale_data(cfg,data_test,scaleparams); % if skip_training is active, scaleparams from previous iteration are used
        end

        % Test Estimated Model
        if cfg.decoding.use_loaded_results
            % get decoding_out from passed_data
            decoding_out(i_step) = get_decoding_out_from_passed_data(cfg,labels_test,passed_data,i_decoding,mask_index(curr_decoding),i_step); %#ok<AGROW>
        else
            % do standard testing
            % e.g. when software is libsvm, then:
            % decoding_out(i_step) = libsvm_test(labels_test,data_test,cfg,model);
            decoding_out(i_step) = cfg.decoding.fhandle_test(labels_test,data_test,cfg,model); %#ok<AGROW>
        end

    end % i_step

    %%%%%%%%%%%%%%%%%%%
    % Generate output %
    % This is where result transformations are called 
    % (so they can use all decoding steps of the current voxel at once)
    results = decoding_generate_output(cfg,results,decoding_out,i_decoding,curr_decoding,current_data);

end % End decoding iterations (e.g. voxel)

% done
dispv(1,'All %s steps finished successfully!',cfg.analysis)

%% Save and write results

% indices, not volumes. Is that desirable?
if cfg.results.write
    % Close txt files to store filenames
    dispv(1,['Closing file to store filenames ' inputfilenames_fname])
    fclose(inputfilenames_fid);
    dispv(1,'done!')

    % Write results
    dispv(1,'Writing results to disk...')
    decoding_write_results(cfg,results)
    dispv(1,'done!')
end

% save end time
cfg.progress.endtime = datestr(now);

   
%% plot & save design again at the end (to show that job is finished)
% Endtime shows user that job is over
% cfg = tdt_plot_design_final(cfg);


%% END OF MAIN FUNCTION


%% SUBFUNCTIONS

function cfg = tdt_plot_design_init(cfg)

try
    if cfg.plot_design == 1 % plot + save fig, save hdl
        cfg.fighandles.plot_design = plot_design(cfg);
        save_fig(fullfile(cfg.results.dir, 'design'), cfg, cfg.fighandles.plot_design); 
        drawnow;
    elseif cfg.plot_design == 2 % only save fig, plot invisible, dont save hdl
        fighdl = plot_design(cfg, 0); 
        save_fig(fullfile(cfg.results.dir, 'design'), cfg, fighdl); 
        close(fighdl); clear fighdl
    end
catch
    warningv('DECODING:PlotDesignFailed', 'Failed to plot design')
end

% show design as text
try 
    display_design(cfg); 
catch
    warningv('DECODING:DisplayDesignFailed', 'Failed to display design to screen ( display_design(cfg) )')
end

%%
function cfg = tdt_check_transform_only(cfg,passed_data,mask_index)

% By default, calculate the data, if not specified otherwise
if ~isfield(cfg.decoding, 'use_loaded_results') || cfg.decoding.use_loaded_results == 0
    cfg.decoding.use_loaded_results = 0; % set default
else
    % check that passed_data contains the loaded results
    if ~isfield(passed_data, 'loaded_results')
        error('cfg specifies that loaded results should be used instead of recomputing them (cfg.decoding.use_loaded_results = 1), but no result data is passed in passed_data.loaded_results. See read_resultdata.m on how to use this feature.')
    end
    % check that mask_index agrees
    if ~isequal(mask_index, passed_data.loaded_results.mask_index)
        error('mask_index in decding does not fit to passed_data.loaded_results.mask_index')
    end
    
    warningv('decoding:loaded_results_experimental', 'cfg specifies that loaded results should be used instead of recomputing them (cfg.decoding.use_loaded_results = 1). This features is still experimental. Use with care.')
    display('Skip calculating data and using results from passed_data.loaded_results instead.')
end

%%
function results = tdt_prepare_results(cfg,mask_index,passed_data,n_decodings,n_outputs,decoding_subindex)

% initialize results vector
results = {};

% Save analysis type
results.analysis        = cfg.analysis;
% Save number of conditions (e.g. to get the chancelevel later)
results.n_cond          = cfg.design.n_cond;
results.n_cond_per_step = cfg.design.n_cond_per_step;
% Save mask_index
results.mask_index      = mask_index;
% Save all mask indices separately (useful if several masks are provided)
results.mask_index_each = passed_data.mask_index_each;
% Save number of decodings that could be performed
results.n_decodings     = n_decodings;
% save data info (voxel dimensions, size)
results.datainfo        = cfg.datainfo;
% Save subindices if they are provided
if isfield(cfg.searchlight,'subset')
    results.decoding_subindex = decoding_subindex;
end
if isfield(cfg.searchlight,'size')
    results.searchlight_size = cfg.searchlight.size;
end

for i_output = 1:n_outputs
    outname = char(cfg.results.output{i_output}); % char necessary to get name of objects
    
    if strcmp(cfg.analysis, 'searchlight')
        % use number of voxels to allocate space independent of number of
        % decodings (because cfg.searchlight.subset allows to choose fewer
        % voxels, but we want in the end an image that has the same
        % dimension as the original image)
        n_dim = length(mask_index);  % n_voxel = length(mask_index)
    else
        % otherwise, get as many output dimensions as decodings (no subset
        % selection possible at the moment)
        n_dim = n_decodings;
    end

    % Preallocation
    results.(outname).output = zeros(n_dim,1);

    if cfg.results.setwise && cfg.design.n_sets > 1
        for i_set = 1:cfg.design.n_sets
            results.(outname).set(i_set).output = zeros(n_dim,1);
        end
    end
    clear n_dim
end

%%

function data = tdt_scale_separate(cfg,data,misc,miscindex)

use_misc = ~isempty(misc);

uchunk  = uniqueq(cfg.files.chunk);
for i_chunk = 1:length(uchunk)
    dataind  = cfg.files.chunk==uchunk(i_chunk);
    if use_misc
        residind = cfg.files.residuals.chunk==uchunk(i_chunk);
        data(dataind,:) = decoding_scale_data(cfg,data(dataind,:),[],misc.residuals(residind,miscindex));
    else
        data(dataind,:) = decoding_scale_data(cfg,data(dataind,:));
    end
end

function data = tdt_scale_iter(cfg,data,misc,miscindex)


if isfield(misc,'residuals')
    data = decoding_scale_data(cfg,data,[],misc.residuals(:,miscindex));
else
    data = decoding_scale_data(cfg,data);
end



%%
function cfg = tdt_plot_selected_voxels(cfg, i_decoding, n_decodings, mask_index, indexindex, sz, currdata)

if isfield(cfg, 'plot_selected_voxels') && cfg.plot_selected_voxels > 0 && (cfg.plot_selected_voxels == 1 || mod(i_decoding, cfg.plot_selected_voxels) == 1 || i_decoding == n_decodings)
    if ~isfield(cfg, 'fighandles') || ~isfield(cfg.fighandles, 'plot_selected_voxels')
        cfg.fighandles.plot_selected_voxels = ''; % will be set during call
    end
    try
        % plot searchlight with brain projection
        cfg.fighandles.plot_selected_voxels = plot_selected_voxels(mask_index(indexindex), sz, currdata, mask_index, [], cfg.fighandles.plot_selected_voxels, cfg);
    catch
        warningv('DECODING:PlotSelectedVoxelsFailed', 'plot_selected_voxels failed');
    end
end

%%
function [data_train,data_test] = tdt_get_train_test(cfg,current_data,kernel,use_kernel,i_train,i_test)

% Get data for training & testing at current position
if use_kernel
    % get relevant parts of kernel
    data_train.kernel = kernel(i_train, i_train);
    data_test.kernel = kernel(i_test, i_train);
    % additionally pass original data vectors, if selected
    if cfg.decoding.kernel.pass_vectors
        data_train.vectors = current_data(i_train, :);
        data_test.vectors = current_data(i_test, :);
    end
else
    % no kernel used, set the training vectors as training data
    data_train = current_data(i_train, :);
    data_test = current_data(i_test, :);
end

%%
function cfg = tdt_plot_design_final(cfg)

try
    if cfg.plot_design
        cfg.fighandles.plot_design = plot_design(cfg,1); 
        if cfg.results.write
            save_fig(fullfile(cfg.results.dir, 'design'), cfg, cfg.fighandles.plot_design);
        end
    end
catch %#ok<*CTCH>
    warningv('DECODING:PlotDesignFailed', 'Failed to plot design')
end