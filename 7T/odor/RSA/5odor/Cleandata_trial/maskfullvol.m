function responsePatterns = maskfullvol( maskname )
% mask full volumes
rsa_base;
if strcmp(maskname,'at165') || strcmp(maskname,'at196')
    userOptions.maskNames(1:5) = strcat(userOptions.maskNames(1:5),'_',maskname);
    userOptions.maskNames(6:end) = strrep(userOptions.maskNames(6:end),'align',maskname);
end
%% Data preparation
fullBrainVols = fMRIDataPreparation_afni(betaCorrespondence, userOptions);
binaryMasks_nS = fMRIMaskPreparation_afni(userOptions);
responsePatterns = rsa.fmri.fMRIDataMasking(fullBrainVols, binaryMasks_nS, betaCorrespondence, userOptions);
save([datafolder 'Cleandata_responsePatterns_' maskname],'responsePatterns')
end