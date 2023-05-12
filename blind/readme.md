# exp
Experiment program for blind people.

## gendata.m
Generate images and timing files.

## generate_img.tcsh
Generate images.

## blind_timing.m
Genrate timing files for each odor.

## blind_timing_rating.m
Genrate timing files for each rating.

## proc_2xsmooth_censor.tcsh
Preprocess data using `afni_proc.py`.

## proc_blindanat.tcsh
Parcellate anataomy data using `recon-all` and `segmentHA_T1.sh` in freesurfer.

## deconvolve_censor_TENT.tcsh
Deconvolve data using `3dDeconvolve` and TENT function.

## generate_blind_roi.tcsh
Generate ROI for each subject after drawing piriform.

## generate_blind_statas.tcsh
Generate statistics for each roi.

## roistatas.Rmd
Plot time course.

## results_blind_render.R
Render results.