# 7T experiment for odor representation

## analyze_timing.m
Generate timing files for each run and a file including all runs.

## analyze_rating.m
Analyze ratings for four odors.

## generate_img.tcsh
Convert DICOM files.

## generate_roi.tcsh
Generate ROI masks (iszero(a-roi_label)) and resample to fit functional images.

## phy.tcsh
Generate parameters for physiology correction.

## proc_fmri.tcsh
Use afni_proc.py to do preprocessing and deconvolve for all runs (one beta one conditon).

## change_label.tcsh
Change labels in stats file because of a mistake in pro_fmri.tcsh leads to wrong label for a regressor.

## sepmotion.tcsh
Seperate motion files for deconvolve each run.

## deconvolve_run.tcsh
Deconvolve for each run (one beta one conditon in each run).

## deconvolve_trial.tcsh
Deconvolve for all runs but get betas for each trial (one beta one trial in one brick).

## parallelproc.tcsh
Parallel processing for deconvolving each run.

# Biopac respiration
Analysis that use respiration from Biopac has been done by changing each file listed above (paphde to pabiode). Use files listed below to generate respiration that used in physiology correction and then do the same analysis above.

## marker_trans_7T.m
Tranlate markers in acq file. Used by resp_campare.m.

## resp_campare.m
Load and resample respiration from Biopac (variable: data) and cut it to fit scan time by markers. Then load respiration record by scanner (variable: phy), calculate correalation and save to a mat file.

## resp_align.m
Use ft_preproc_lowpassfilter to filt respiration from Biopac. Align and compare two respiration to a point that has max correalation.

## resp_savebio.m
Save respiration from Biopac to 1d file that used in physiology correction.

## nophy
Analysis same as above but without physioloy correction (pade). This can be a backup for all of the analysis.

# MVPA

## decoding_searchlight.m
Searchlight that decodes each odor pairs (6 pairs) using betas for each run.

## decoding_searchlight_4odors.m
Searchlight that decodes 4 odors using betas for each run.

## decoding_roi.m
Decoding each odor pairs (6 pairs) using betas for each run in 4 ROIs.

* APC
* PPC
* Piriform (APC+PPC)
* Amygdala

## decoding_roi_4odors.m
Decoding 4 odors using betas for each run in 4 ROIs.

## decoding_roi_4odors_trial.m
Decoding 4 odors using betas for each trial in 4 ROIs. (Unfinished)

## display_results.m
Display results for ROI based mvpa analysis.