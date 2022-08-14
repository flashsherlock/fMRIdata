function userOptions = defineUserOptions()
%
%  projectOptions is a nullary function which initialises a struct
%  containing the preferences and details for a particular project.
%  It should be edited to taste before a project is run, and a new
%  one created for each substantially different project (though the
%  options struct will be saved each time the project is run under
%  a new name, so all will not be lost if you don't do this).
%
%  For a guide to how to fill out the fields in this file, consult
%  the documentation folder (particularly the userOptions_guide.m)
%
%  Cai Wingfield 11-2009
%__________________________________________________________________________
% Copyright (C) 2009 Medical Research Council

%% Project details
userOptions.analysis='pabiode';
userOptions.sessions=1;
userOptions.conditions=180/userOptions.sessions;
% This name identifies a collection of files which all belong to the same run of a project.
userOptions.analysisName = 'Cleandata';

% This is the root directory of the project.
% some files will be saved in this folder
userOptions.rootPath = '/Volumes/WD_E/gufei/7T_odor/results_RSA/5odor_rmpolort_trial';
datafolder = '/Volumes/WD_E/gufei/7T_odor';
if ~exist(userOptions.rootPath,'dir')
    mkdir(userOptions.rootPath)
end
% The path leading to where the scans are stored (not including subject-specific identifiers).
% "[[subjectName]]" should be used as a placeholder to denote an entry in userOptions.subjectNames
% "[[betaIdentifier]]" should be used as a placeholder to denote an output of betaCorrespondence.m if SPM is not being used; or an arbitrary filename if SPM is being used.
userOptions.betaPath = [datafolder filesep '[[subjectName]]/' ['[[subjectName]]' '.' userOptions.analysis '.results'] '/[[betaIdentifier]]'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXPERIMENTAL SETUP %%
%%%%%%%%%%%%%%%%%%%%%%%%

% time shift for peak response
userOptions.shift=6;

% The list of subjects to be included in the study.
userOptions.subn={};
for sub_i=[4:11 13 14 16:18]
    userOptions.subn=[userOptions.subn sprintf('S%02d',sub_i)];
end
userOptions.subjectNames = userOptions.subn';
% userOptions.subjectNames = cell(length(userOptions.subn),1);
% for sub_i=1:length(userOptions.subn)
%     d=dir(sprintf('%s/%s',datafolder,userOptions.subn{sub_i}));
%     userOptions.subjectNames{sub_i}=d.name;
% end

% The default colour label for RDMs corresponding to RoI masks (as opposed to models).
userOptions.RoIColor = [0 0 1];
userOptions.ModelColor = [0 1 0];

% Should information about the experimental design be automatically acquired from SPM metadata?
% If this option is set to true, the entries in userOptions.conditionLabels MUST correspond to the names of the conditions as specified in SPM.
userOptions.getSPMData = false;
userOptions.afni.software = 'AFNI';
%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FEATUERS OF INTEREST SELECTION OPTIONS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	%% %% %% %% %%
	%% fMRI  %% Use these next three options if you're working in fMRI native space:
	%% %% %% %% %%
	
	% The path to a stereotypical mask data file is stored (not including subject-specific identifiers).
	% "[[subjectName]]" should be used as a placeholder to denote an entry in userOptions.subjectNames
	% "[[maskName]]" should be used as a placeholder to denote an entry in userOptions.maskNames
	userOptions.maskPath = [datafolder filesep '[[subjectName]]' '/mask/[[maskName]].*orig.HEAD'];%'/imaging/mb01/lexpro/multivariate/ffx_simple/[[subjectName]]/[[maskName]].img';
		
		% The list of mask filenames (minus .hdr extension) to be used.
		userOptions.maskNames = {'Pir_new','Pir_old','APC_new','APC_old','PPC'};
        userOptions.maskNames=[userOptions.maskNames {'Amy8_align','corticalAmy_align','CeMeAmy_align','BaLaAmy_align'}];
%         for region=[1 3 5 6 7 8 9 10 15]
%             userOptions.maskNames=[userOptions.maskNames {['Amy_align' num2str(region) 'seg']}];
%         end
%         userOptions.maskNames={'Amy9_at165','corticalAmy_at165'};
%         for region=[1 3 7 8 9 10 15]
%             userOptions.maskNames=[userOptions.maskNames {['Amy_at165' num2str(region) 'seg']}];
%         end
%%%%%%%%%%%%%%%%%%%%%%%%%
%% SEARCHLIGHT OPTIONS %%
%%%%%%%%%%%%%%%%%%%%%%%%%

	%% %% %% %% %%
	%% fMRI  %% Use these next three options if you're working in fMRI native space:
	%% %% %% %% %%

		% What is the path to the anatomical (structural) fMRI scans for each subject?
		% "[[subjectName]]" should be used to denote an entry in userOptions.subjectNames
        % for spm to transform results to common space
		% userOptions.structuralsPath = 'paathToWhereYourSubject''s structuralImagesAreStored ';% e.g. /imaging/mb01/lexpro/[[subjectName]]/structurals/
	
		% What are the dimensions (in mm) of the voxels in the scans?
		userOptions.voxelSize = [1.1 1.1 1.1];
	
		% What radius of searchlight should be used (mm)?
		userOptions.searchlightRadius = 15;
	
%%%%%%%%%%%%%%%%%%%%%%%%


%% ANALYSIS PREFERENCES %%
%%%%%%%%%%%%%%%%%%%%%%%%%%

%% First-order analysis

% Text lables which may be attached to the conditions for MDS plots.
betas=betaCorrespondence;
betas=betas(1,:);
conditions=split(squeeze(struct2cell(betas)),'_');
conditions=cellstr(conditions(:,3));
userOptions.conditionLabels = conditions;
% userOptions.useAlternativeConditionLabels = false;

% What colours should be given to the conditions?
userOptions.conditionColours = kron([1 0 0; 0 1 0; 0 0 1; 1 .7 0], ones(length(betas)/userOptions.conditions,1));

% Which distance measure to use when calculating first-order RDMs.
userOptions.distance = 'Correlation';

%% Second-order analysis

% Which similarity-measure is used for the second-order comparison.
userOptions.distanceMeasure = 'Spearman';

% How many permutations should be used to test the significance of the fits?  (10,000 highly recommended.)
userOptions.significanceTestPermutations = 10000;

% Bootstrap options
userOptions.nResamplings = 1000;
userOptions.resampleSubjects = true;
userOptions.resampleConditions = false;

% Should RDMs' entries be rank transformed into [0,1] before they're displayed?
userOptions.rankTransform = true;

% Should rubber bands be shown on the MDS plot?
userOptions.rubberbands = true;

% What criterion shoud be minimised in MDS display?
% has been changed to avoid errors
userOptions.criterion = 'metricsstress';

% What is the colourscheme for the RDMs?
userOptions.colourScheme = bone(128);

% How should figures be outputted?
userOptions.displayFigures = true;
userOptions.saveFiguresPDF = true;
userOptions.saveFiguresFig = false;
userOptions.saveFiguresPS = false;
% Which dots per inch resolution do we output?
userOptions.dpi = 300;
% Remove whitespace from PDF/PS files?
% Bad if you just want to print the figures since they'll
% no longer be A4 size, good if you want to put the figure
% in a manuscript or presentation.
userOptions.tightInset = false;

% userOptions.forcePromptReply = 'S';

end%function
