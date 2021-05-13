% Recipe_fMRI
% this 'recipe' performs region of interest analysis on fMRI data.
% Cai Wingfield 5-2010, 6-2010, 7-2010, 8-2010
%__________________________________________________________________________
% Copyright (C) 2010 Medical Research Council

%%%%%%%%%%%%%%%%%%%%
%% Initialisation %%
%%%%%%%%%%%%%%%%%%%%

% toolboxRoot = '/Users/mac/matlab/rsatoolbox'; addpath(genpath(toolboxRoot));
% userOptions.criterion has been changed to avoid errors
userOptions = defineUserOptions();

%%%%%%%%%%%%%%%%%%%%%%
%% Data preparation %%
%%%%%%%%%%%%%%%%%%%%%%

fullBrainVols = fMRIDataPreparation_afni(betaCorrespondence, userOptions);
binaryMasks_nS = fMRIMaskPreparation_afni(userOptions);
responsePatterns = rsa.fmri.fMRIDataMasking(fullBrainVols, binaryMasks_nS, betaCorrespondence, userOptions);

%%%%%%%%%%%%%%%%%%%%%
%% RDM calculation %%
%%%%%%%%%%%%%%%%%%%%%

RDMs  = rsa.constructRDMs(responsePatterns, betaCorrespondence, userOptions);
sRDMs = rsa.rdm.averageRDMs_subjectSession(RDMs, 'session');
% RDMs  = rsa.rdm.averageRDMs_subjectSession(RDMs, 'session', 'subject');
% RDMs  = rsa.rdm.averageRDMs_subjectSession(sRDMs(:,[1 3 4]),'subject');
RDMs  = rsa.rdm.averageRDMs_subjectSession(sRDMs, 'subject');
% construct model RDMs
Models = rsa.constructModelRDMs(modelRDMs_7T(1,userOptions.sessions), userOptions);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% First-order visualisation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rsa.figureRDMs(RDMs, userOptions, struct('fileName', 'RoIRDMs', 'figureNumber', 1));
rsa.figureRDMs(Models, userOptions, struct('fileName', 'ModelRDMs', 'figureNumber', 2));
saveas(gcf, [userOptions.rootPath filesep 'model' num2str(1) '.jpg']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% relationship amongst multiple RDMs %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% allocate space for results
corrmat=rsa.pairwiseCorrelateRDMs({sRDMs, Models}, userOptions);
saveas(gcf, [userOptions.rootPath filesep 'pair.jpg']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% statistical inference %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% roiIndex = 1;% index of the ROI for which the group average RDM will serve 
% % as the reference RDM. 
% for i=1:numel(Models)
%     models{i}=Models(i);
% end
% userOptions.RDMcorrelationType='Kendall_taua';
% userOptions.RDMrelatednessTest = 'subjectRFXsignedRank';
% userOptions.RDMrelatednessThreshold = 0.05;
% userOptions.figureIndex = [10 11];
% userOptions.RDMrelatednessMultipleTesting = 'FDR';
% userOptions.candRDMdifferencesTest = 'subjectRFXsignedRank';
% userOptions.candRDMdifferencesThreshold = 0.05;
% userOptions.candRDMdifferencesMultipleTesting = 'none';
% % has been changed to avoid out of bound error
% % userOptions.nRandomisations = 24;
% stats_p_r=rsa.compareRefRDM2candRDMs(RDMs(roiIndex), models, userOptions);
