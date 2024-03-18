# RSA
Representation similarity analysis using single trials.

## betaCorrespondence.m
List of condition names. For example, *'[[subjectName]]_exp1_lim1'*.

## defineUserOptions.m
RSA options.

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

## test_corr.m
Try to compute correlation between model and neuro RDMs without functions from rsatoolbox.

## rsa_base.m
Use data the same as MVPA (remove 2 TRs before onset).

## maskfullvol.m
Function to use data the same as MVPA (input mask name).

## select_voxel.m
Function to select voxels in RSA.

## rating_corr.m
Write images of rating-beta correlation.

## mrivi.m
Get valence and intensity ratings in MRI, then calculate runwise RDMs.