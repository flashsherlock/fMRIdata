# RSA
Representation similarity analysis. Trials for each odor are averaged.

## betaCorrespondence.m
List of condition names. For example, *'[[subjectName]]_exp1_lim1'*.

## get_name_afni.m
Generate image file names used in `fMRIDataPreparation_afni.m`. Make use of names in Useroptions.subn to list image file names. Different `filedec` in used for file name in deconvolve should be set here.

## fMRIDataPreparation_afni.m
Load data from BRIK files (requiring functions in the decoding toolbox). Each **column** is a **conditon** corresponding to names defined in `betaCorrespondence.m`. Results will be saved to folder "imagedata".

## fMRIMaskPreparation_afni.m
Load mask from BRIK files. Results are masks (1×n_voxels matrices) in side a structure named by subjects, which will be saved to folder "imagedata".

## defineUserOptions.m
RSA options.

## read_rating.m
Read intensity and valence ratings. Return a n_odors × 2 (valence, intensity) matrix, the first column is valence, the second column is intensity (unuseful now, replaced by mrirate and bottlerate).

## modelRDMs_7T.m
Hypothesis RDMs to be tested.
* Atom pairs tanimoto
* MCS tanimoto
* Haddad 2008
* Odor space
* mriintensity
* mrivalence
* mrisimilariy
* bointensity
* bovalence
* bosimilariy
* random

## Recipe_fMRI.m
Main workflow for ROI analysis. Correlation matrice for model and neuro RDMs are averaged across subjects or use the averaged model and neuro RDMs to compute.