function responsePatterns = maskfullvol( maskname )
% mask full volumes
% maskname='at196'
rsa_base;
if strcmp(maskname,'at165') || strcmp(maskname,'at196')
    userOptions.maskNames(6:end) = strcat(userOptions.maskNames(6:end),'_',maskname);
    userOptions.maskNames(1:5) = strrep(userOptions.maskNames(1:5),'align',maskname);
end
%% Data preparation
fullBrainVols = fMRIDataPreparation_afni(betaCorrespondence, userOptions);
binaryMasks_nS = fMRIMaskPreparation_afni(userOptions);
responsePatterns = rsa.fmri.fMRIDataMasking(fullBrainVols, binaryMasks_nS, betaCorrespondence, userOptions);
save([datafolder 'ImageData/Cleandata_responsePatterns_' maskname],'responsePatterns')
end