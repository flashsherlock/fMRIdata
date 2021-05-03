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
Models = rsa.constructModelRDMs(modelRDMs_7T(1,userOptions.sessions,'S01_yyt'), userOptions);
for i=1:3
    Models = [Models;rsa.constructModelRDMs(modelRDMs_7T(i,userOptions.sessions), userOptions)];
end
% average model RDMs across subjects (Apairs etc. remains the same but ratings are averaged)
Models =Models';
Modelsavg = Models(:,1);
for i=1:length(Modelsavg)
    Modelsavg(i).RDM=mean(reshape([Models(i,:).RDM],4,4,[]),3);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% First-order visualisation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rsa.figureRDMs(RDMs, userOptions, struct('fileName', 'RoIRDMs', 'figureNumber', 1));
% save model RDMs
rsa.figureRDMs(Models(:,1), userOptions, struct('fileName', 'ModelRDMs', 'figureNumber', 2));
saveas(gcf, 'model_yyt.jpg');
for i=2:4
    rsa.figureRDMs(Models(:,i), userOptions, struct('fileName', 'ModelRDMs', 'figureNumber', 2));
    saveas(gcf, ['model' num2str(i-1) '.jpg']);
end

rsa.figureRDMs(Modelsavg, userOptions, struct('fileName', 'ModelRDMs', 'figureNumber', 2));
saveas(gcf, 'model_avg.jpg');

rsa.MDSConditions(RDMs, userOptions);
rsa.dendrogramConditions(RDMs, userOptions);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% relationship amongst multiple RDMs %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate averaged correlation using model RDMs
corrmat=rsa.pairwiseCorrelateRDMs({RDMs, Modelsavg}, userOptions);
saveas(gcf, 'pair_avg.jpg');
% allocate space for results
corrmat=repmat(corrmat,[1 1 4]);
for i=1:4
    corrmat(:,:,i)=rsa.pairwiseCorrelateRDMs({sRDMs(:,i), Models(:,i)}, userOptions);
    saveas(gcf, ['pair' num2str(i) '.jpg']);
end
% average correlation matrices
mcorr=nanmean(corrmat,3);
% plot
figure;
imagesc(mcorr,[-1 1]);
% set color
cols=colorScale([0 0 1; 0.5 0.5 0.5; 1 0 0],256);
colormap(cols); colorbar;
axis square off;
saveas(gcf, 'pair_sub_mean.jpg');
% could not plot MDS, disparities undefined (maybe caused by distance measures in useroptions)
% rsa.MDSRDMs({RDMs, Models}, userOptions);



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
