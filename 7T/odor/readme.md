# 7T experiment for odor representation

## gendata.m
Gernerate data files, including images, timing files, and phy files.

## analyze_timing.m
Generate timing files for each run and a file including all runs.

## analyze_timing_valence.m
Generate timing files for every odor valence (amplitude modulated).

## analyze_timing_valence_avg.m
Generate timing files that contain averaged odor valence for each run (amplitude modulated).

## analyze_timing_valence_allavg.m
Generate timing files that contain averaged odor valence (amplitude modulated).

## analyze_timing_rating.m
Generate timing files for the presentation of cue words.

## analyze_rating.m
Analyze ratings for four odors.

## bottlerate.m
Analyze ratings for odors presented by bottles.

## mrirate.m
Analyze ratings for odors presented by the olfactometer.

## saverate.m
Save ratings to mat file.

## generate_img.tcsh
Convert DICOM files.

## generate_roi.tcsh
Generate ROI masks (iszero(a-roi_label)) and resample to fit functional images.

## generate_statas.tcsh
Generate activation masks and statistics for each ROI. Try to extract time course from TENT deconvolution

## phy.tcsh
Generate parameters for physiology correction.

## prodata.m
Generate proc files for each subject by running `afni_proc.py` and command files for parallel analysis.

## proc_anatomy.tcsh
Use `@SSwarper` to preprocessing anatomical image, then do recon (resample to 1mm by default) to show data on surface (SUMA).
Only for testing, because high resolution results will be used.

## proc_anatomy_hires.tcsh
Use `@SSwarper` to preprocessing anatomical image, then do recon (keep 0.7mm) to show data on surface (SUMA).
Amygdala can be automatically segmented to 9 nucleis by command `segmentHA_T1.sh`, and `3dAllineate` to EPI grid.

## proc_anatomy_alignUACepi.tcsh
Use `@SSwarper` to preprocessing anatomical image, then align it to EPI and do recon (keep 0.7mm) to show data on surface (SUMA).
It may improve accuracy (avoid transformation) after align to EPI.

## proc_anatomy_alignUACepi_e2a.tcsh
Use anatQQ (skull-stripped and normalized image) to do recon-all and generate masks.

## proc_fmri2xsmooth.tcsh
Use `afni_proc.py` to do preprocessing and deconvolve for all runs (one beta one conditon, adding valence and intensity rating as regressors). Set to 2.2mm smooth. Add odor_va regressor.

## proc_fmri2xsmooth_e2a.tcsh
Same as `proc_fmri2xsmooth.tcsh` but align EPI to anatomical image.

## proc_fmri2xsmooth_censor.tcsh
Same as `proc_fmri2xsmooth.tcsh` but censor motions.

## proc_fmri2xsmooth_censor_e2a.tcsh
Same as `proc_fmri2xsmooth_censor.tcsh` but align EPI to anatomy.

## change_label.tcsh
Change labels in stats file because of a mistake in pro_fmri.tcsh leads to wrong label for a regressor.

## sepmotion.tcsh
Seperate motion files for deconvolve each run.

# Deconvolution
## deconvolve_noblur_rating_odor_TENT.tcsh
Use `TENT(0,10,11)` function to do deconvolution.(${filedec}=odorVI_noblur)

## deconvolve_noblur_rating_odor_va_TENT.tcsh
Use `TENT(0,10,11)` function and odor_va regressor to do deconvolution.(${filedec}=odorVIva_noblur)

## deconvolve_noblur_rating_odor.tcsh
Deconvole with the same regressors as rating_odor, but use the data without blur and scale. Then, subtract fits of no interest from the original data to obtain clean data.(${filedec}=odorVI_noblur)

## deconvolve_noblur_rating_odor_va.tcsh
Deconvole with the regressors in noblur_rating_odor plus amplitude modulated valence regressors.(${filedec}=odorVIva_noblur)

## deconvolve_rating_odor.tcsh
Add valence and intensity ratings to regressors, including regressors for odors.(${filedec}=odorVI)

## deconvolve_rating_odor_va.tcsh
Add odor_va to regressors.(${filedec}=odorVIva)

## deconvolve_censor_odor.tcsh
Only odor and time modulated regressors (for activation mask).

## deconvolve_censor_odor_TENT.tcsh
Use TENT function to deconvolve odors (for time course).

## deconvolve_censor_odorva.tcsh
Amplitude modulated rating regressors but no odor regressor (for clean data).

## deconvolve_run.tcsh
Deconvolve for each run (one beta one conditon in each run).(${filedec}=Run)

## deconvolve_trial.tcsh
Deconvolve for all runs but get betas for each trial (one beta one trial in one brick).(${filedec}=IM)

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

# MVPA

## RSA
Representation similarity analysis.

## MVPA_run
Decoding odors using betas for each run.

## MVPA_tial
Decoding odors using betas for each trial.

## MVPA_cleandata
Decoding odors using clean data generated by subtracting fits of no interest.

* Baseline
* Motion
* Rating

## display_results.m
Display results for ROI based mvpa analysis.

## results.Rmd
Results for piriform and amygdala.

## results_Amy.Rmd
Results for different regions of amygdala.

## results_labels.Rmd
Analyze true labels and predicted labels, which can obtain accuracy and confusion matrices for each run.

## results_labels_mean.Rmd
Analyze true labels and predicted labels for all subject, computing group means.

## ratings.Rmd
Plot valence, intensity, and similarity ratings for odors presented by bottles or the olfactometer. Then, plot valence and intensity ratings for each run during the fMRI scan.

## roistatas.Rmd
Compute and plot mean voxel numbers for each ROI, and plot time courses.

## results_labels_render.R
Render results_labels.Rmd, results_labels_mean.Rmd, rating.Rmd, and roistatas.Rmd with parameters.

# nophy
Analysis same as above but without physioloy correction (pade). This can be a backup for all of the analysis.

# motion
Compare different methods that deal with head movement in the 5th run of S01.

# 5odor
R scripts to show results of 5 odors experiment.