# RSA
Representation similarity analysis.

## betaCorrespondence.m
List of condition names. For example, *'[[subjectName]]_exp1_lim1'*.

## get_name_afni.m
Generate image file names used in `fMRIDataPreparation_afni.m`.

## fMRIDataPreparation_afni.m
Load data from BRIK files (requiring functions in the decoding toolbox). Each **column** is a **conditon** corresponding to names defined in `betaCorrespondence.m`. Results will be saved to folder "imagedata".

## fMRIMaskPreparation_afni.m
Load mask from BRIK files. Results are masks (1×n_voxels matrices) in side a structure named by subjects, which will be saved to folder "imagedata".

## defineUserOptions.m
RSA options.

## modelRDMs_7T.m
Hypothesis RDMs to be tested.
* all separate (only 0 on diagonal)
* absolute (0 and 1) quality
* absolute (0 and 1) structure
* random

## Recipe_fMRI.m
Main workflow for ROI analysis.

## Recipe_fMRI_searchlight.m
Main workflow for searchlignt analysis (have not been edited).