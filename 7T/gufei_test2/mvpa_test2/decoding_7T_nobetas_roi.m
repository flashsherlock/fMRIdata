% This script is a template that can be used for a decoding analysis on 
% brain image data. It is for people who don't have betas available to do
% their classification and who need to enter their image names, labels and
% decoding chunks (e.g. run numbers) separately.

% Make sure the decoding toolbox and your favorite software (SPM or AFNI)
% are on the Matlab path (e.g. addpath('/home/decoding_toolbox') )
% addpath('$ADD FULL PATH TO TOOLBOX AS STRING OR MAKE THIS LINE A COMMENT IF IT IS ALREADY$')
% addpath('$ADD FULL PATH TO TOOLBOX AS STRING OR MAKE THIS LINE A COMMENT IF IT IS ALREADY$')

% Set defaults
cfg = decoding_defaults;

% Make sure to set software to AFNI
cfg.software = 'AFNI';

% Set the analysis that should be performed (default is 'searchlight')
cfg.analysis = 'roi';

for runnum=1:3
run=['run' num2str(runnum)];
% run2=['run' num2str(7-runum)];
sub=['gufei.' run '.pade'];
% sub2=['gufei.' run2 '.pade'];
% Set the output directory where data will be saved, e.g. 'c:\exp\results\buttonpress'
cfg.results.dir = ['/Volumes/WD_D/gufei/7t/mvpa/roi/' run];

% Set the filename of your brain mask (or your ROI masks as cell array) 
% for searchlight or wholebrain e.g. 'c:\exp\glm\model_button\mask.img' OR 
% for ROI e.g. {'c:\exp\roi\roimaskleft.img', 'c:\exp\roi\roimaskright.img'}
% You can also use a mask file with multiple masks inside that are
% separated by different integer values (a "multi-mask")
cfg.files.mask = ['/Volumes/WD_D/gufei/7t/' sub '.results/testamy+orig.HEAD'];
% cfg.files.mask = ['/Volumes/WD_D/share/7T/' sub '.results/full_mask.' sub '+orig.BRIK.gz'];

% Set the following field:
% Full path to file names (1xn cell array) (e.g.
% {'c:\exp\glm\model_button\im1.nii', 'c:\exp\glm\model_button\im2.nii', ... }
% 4 TRs for each block, start from the 3rd TR
tr=[3:7:128;4:7:128;5:7:128;6:7:128];
numtr=4*2*9;
F=cell(1,numtr*2);
for i = 1:numtr
    t=tr(i);
    F{i} = ['/Volumes/WD_D/gufei/7t/' sub '.results/'  'pb04.' sub '.r01.volreg+orig.BRIK,' num2str(t)];
    F{i+numtr} = ['/Volumes/WD_D/gufei/7t/' sub '.results/'  'pb04.' sub '.r02.volreg+orig.BRIK,' num2str(t)];
end 
cfg.files.name =  F;
% and the other two fields if you use a make_design function (e.g. make_design_cv)
%
% (1) a nx1 vector to indicate what data you want to keep together for 
% cross-validation (typically runs, so enter run numbers)

cfg.files.chunk = reshape(repmat([1;2;3;4],[1 numtr/4*2]),[numtr*2 1]);
%
% (2) any numbers as class labels, normally we use 1 and -1. Each file gets a
% label number (i.e. a nx1 vector)
% 1:fear -1:neutral
times=9;
if mod(runnum,2)
    % fear first
    seq=[1 -1];
else
    % neutral first
    seq=[-1 1];
end
seq=repmat(seq,[1 times]);
% balance
for b=1:3
seq=[seq;fliplr(seq)];
seq=reshape(seq(:,1:times),1,[]);
end

seq=[seq -seq];

cfg.files.label = reshape(repmat(seq,[4 1]),[numtr*2 1]);

if mod(str2double(run(4)),2)==0
    cfg.files.label = -cfg.files.label;
end
% Set additional parameters manually if you want (see decoding.m or
% decoding_defaults.m). Below some example parameters that you might want 
% to use:

% cfg.searchlight.unit = 'mm';
% cfg.searchlight.radius = 12; % this will yield a searchlight radius of 12mm.
% cfg.searchlight.spherical = 1;
% cfg.verbose = 2; % you want all information to be printed on screen
% cfg.decoding.train.classification.model_parameters = '-s 0 -t 0 -c 1 -b 0 -q'; 

% Some other cool stuff
% Check out 
%   combine_designs(cfg, cfg2)
% if you like to combine multiple designs in one cfg.

% Decide whether you want to see the searchlight/ROI/... during decoding
cfg.plot_selected_voxels = 500; % 0: no plotting, 1: every step, 2: every second step, 100: every hundredth step...

% Add additional output measures if you like
% cfg.results.output = {'accuracy_minus_chance', 'AUC_minus_chance'}

% If you have a balanced design with multiple chunks, use this function
cfg.design = make_design_cv(cfg);
% This creates the leave-one-pair-out cross validation design with 100 steps (assuming there is only one chunk):
% cfg.design = make_design_boot(cfg,100,1); % the 1 keeps test data balanced, too
% If there are several unbalanced chunks, use this function:
% cfg.design = make_design_boot_cv(cfg,100,1); % the 1 keeps test data balanced, too
% If you used a bootstrap design, then you might speed up processing using this function:
% cfg.design = sort_design(cfg.design);

% Run decoding
results = decoding(cfg);
end