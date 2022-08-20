# Preprocessing

## proc_fmri2xsmooth.tcsh
Use `afni_proc.py` to do preprocessing and deconvolve for all runs (one beta one conditon, adding valence and intensity rating as regressors). Set to 2.2mm smooth. Add odor_va regressor and censor motions.

## proc_fmri2xsmooth_e2a.tcsh
Same as `proc_fmri2xsmooth.tcsh` but align EPI to anatomical image.

## change_label.tcsh
Change labels in stats file because of a mistake in pro_fmri.tcsh leads to wrong label for a regressor.

# Deconvolve for 4 odors experiment

## deconvolve_noblur_rating_odor_TENT.tcsh
Use `TENT(0,10,11)` function to do deconvolution.(${filedec}=odorVI_noblur)

## deconvolve_noblur_rating_odor_va_TENT.tcsh
Use `TENT(0,10,11)` function and odor_va regressor to do deconvolution.(${filedec}=odorVIva_noblur)

## deconvolve_noblur_rating_odor.tcsh
Deconvole with the same regressors as rating_odor, but use the data without blur and scale. Then, subtract fits of no interest from the original data to obtain clean data.(${filedec}=odorVI_noblur)

## deconvolve_noblur_rating_odor_va.tcsh
Deconvole with the regressors in noblur_rating_odor plus amplitude modulated valence regressors.(${filedec}=odorVIva_noblur)

## deconvolve_rating_odor.tcsh
Add valence and intensity ratings to regressors (for cleandata), including regressors for odors.(${filedec}=odorVI)

## deconvolve_rating_odor_va.tcsh
Add odor_va to regressors.(${filedec}=odorVIva)

# Generate results

## generate_statas.tcsh
Generate activation masks and statistics for each ROI. Try to extract time course from TENT deconvolution

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