%% Project details
subs=[2:4,6:14,16];
userOptions.analysis='pade';
userOptions.sessions=1;
userOptions.conditions=192/userOptions.sessions;
userOptions.analysisName = 'Cleandata';
% This is the root directory of the project.
userOptions.rootPath = '/Volumes/WD_F/gufei/blind/results_RSA/8odor_trial';
datafolder = '/Volumes/WD_F/gufei/blind';
if ~exist(userOptions.rootPath,'dir')
    mkdir(userOptions.rootPath)
end
userOptions.betaPath = [datafolder filesep '[[subjectName]]/' ['[[subjectName]]' '.' userOptions.analysis '.results'] '/[[betaIdentifier]]'];
% time shift for peak response
userOptions.shift=[6];
userOptions.combine=1;
% The list of subjects to be included in the study.
userOptions.subn={};
for sub_i=subs
    userOptions.subn=[userOptions.subn sprintf('S%02d',sub_i)];
end
userOptions.subjectNames = userOptions.subn';
userOptions.getSPMData = false;
userOptions.afni.software = 'AFNI';
userOptions.maskPath = [datafolder filesep '[[subjectName]]' '/mask/[[maskName]]*orig.HEAD'];
% userOptions.maskNames={'Amy8_at165','Pir_new_at165','Pir_old_at165','APC_new_at165','APC_old_at165','PPC_at165','EarlyV_at165','V1_at165','V2_at165','V3_at165'};
userOptions.maskNames={'Amy8_align','Pir_new','Pir_old','APC_new','APC_old','PPC','EarlyV','V1','V2','V3'};
% prefix and suffix
userOptions.filename={'NIerrts.','.odor_noblur+orig.BRIK,'};
%% Data preparation
fullBrainVols = fMRIDataPreparation_blind(betaCorrespondence, userOptions);
binaryMasks_nS = fMRIMaskPreparation_blind(userOptions);
responsePatterns = rsa.fmri.fMRIDataMasking(fullBrainVols, binaryMasks_nS, betaCorrespondence, userOptions);