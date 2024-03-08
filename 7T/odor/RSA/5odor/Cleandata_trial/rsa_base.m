%% Project details
userOptions.analysis='pabiode';
userOptions.sessions=1;
userOptions.conditions=180/userOptions.sessions;
userOptions.analysisName = 'Cleandata';
% This is the root directory of the project.
userOptions.rootPath = '/Volumes/WD_F/gufei/7T_odor/results_RSA/5odor_rmbase_trial';
datafolder = '/Volumes/WD_F/gufei/7T_odor';
if ~exist(userOptions.rootPath,'dir')
    mkdir(userOptions.rootPath)
end
userOptions.betaPath = [datafolder filesep '[[subjectName]]/' ['[[subjectName]]' '.' userOptions.analysis '.results'] '/[[betaIdentifier]]'];
% time shift for peak response
userOptions.shift=[-6 -3 6];
userOptions.combine=1;
% The list of subjects to be included in the study.
userOptions.subn={};
for sub_i=[4:11 13 14 16:18 19:29 31:34]
    userOptions.subn=[userOptions.subn sprintf('S%02d',sub_i)];
end
userOptions.subjectNames = userOptions.subn';
userOptions.getSPMData = false;
userOptions.afni.software = 'AFNI';
userOptions.maskPath = [datafolder filesep '[[subjectName]]' '/mask/[[maskName]].*orig.HEAD'];
userOptions.maskNames={'Amy8_align','corticalAmy_align','CeMeAmy_align','BaLaAmy_align','Pir_new','Pir_old','APC_new','APC_old','PPC'};
% userOptions.maskNames={'Amy8_at165','corticalAmy_at165','CeMeAmy_at165','BaLaAmy_at165','Pir_new_at165','Pir_old_at165','APC_new_at165','APC_old_at165','PPC_at165'};
% prefix and suffix
userOptions.filename={'allrun.volreg.','+orig.BRIK,'};
%% Data preparation
% fullBrainVols = fMRIDataPreparation_afni(betaCorrespondence, userOptions);
% binaryMasks_nS = fMRIMaskPreparation_afni(userOptions);
% responsePatterns = rsa.fmri.fMRIDataMasking(fullBrainVols, binaryMasks_nS, betaCorrespondence, userOptions);