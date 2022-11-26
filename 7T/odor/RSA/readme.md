# RSA
Representation similarity analysis.

# 5odor
RSA for 5 odors experiment.

## Cleandata_trial
Use all of the trials to construct RDMs (4 odors).

## Cleandata_avgtrials
Average all trials for each odor and then construct RDMs.

## Cleandata_avgruns
Average trials in each run for each odor and then construct RDMs. Currently active.

## figureDendrogram.m
Changed this function in rsatoolbox to match labels and colors on dendrograms.

## get_name_afni.m
Generate image file names used in `fMRIDataPreparation_afni.m`. Make use of names in Useroptions.subn to list image file names. Different `filedec` used for file name in deconvolve should be set here.

## fMRIDataPreparation_afni.m
Load data from BRIK files (requiring functions in the decoding toolbox). Each **column** is a **conditon** corresponding to names defined in `betaCorrespondence.m`. Results will be saved to folder "imagedata".

## fMRIMaskPreparation_afni.m
Load mask from BRIK files. Results are masks (1×n_voxels matrices) in side a structure named by subjects, which will be saved to folder "imagedata".

## read_rating.m
Read intensity and valence ratings. Return a n_odors × 2 (valence, intensity) matrix, the first column is valence, the second column is intensity (unuseful now, replaced by mrirate and bottlerate).

## decoding tool box RSA
Use decoding toolbox to perform RSA (deprecated).

### rsa_roi_4odors_trial
Generate a big RDM based on trial images.

### rsa_roi_4odors
Perform RSA on run betas (with cross validation).