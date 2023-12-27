# Generating files

## gendata.m
Generate images and timing files.

## generate_img.tcsh
Generate images.

## timing_3t.m
Genrate timing files for each condition.

## rename.bash
rename file start with "s0" or "s10" to name start with s.

## clear_disk.tcsh
Remove useless files.

# Preprocessing

## check_grid_3t.bash
Check grid for each subject.

## group_check_align.bash
Check alignment for each subject.

## proc_2xsmooth_censor.tcsh
Preprocess data using `afni_proc.py`.

## proc_3tanat.tcsh
Parcellate anataomy data using `recon-all` and `segmentHA_T1.sh` in freesurfer.

## usefulcmd.bash
Useful commands for checking freesurfer results.

## deconvolve_censor_TENT.tcsh
Deconvolve data using `3dDeconvolve` and TENT function.

## deconvolve_censor_TENTcross.tcsh
Add fixation to regressors.

## deconvolve_nocross.tcsh
Deconvolve data without cross for betas.

## deconvolve_cross.tcsh
Deconvolve data with cross for betas.

## deconvolve_frame.tcsh
Deconvolve data with frame for betas.

## deconvolve_odors.tcsh
Deconvolve data with only odors condition.

## deconvolve_congruent.tcsh
Deconvolve data for congruent/incongruent conditions (old data).

## parallelproc.tcsh
Parallel processing.

## generate_PPI.tcsh
Generate PPI regressors using `make_ppi_regress.tcsh`.

## make_ppi_regress.tcsh
Make regressors for PPI analysis.

## deconvolve_PPI.tcsh
Deconvolve data for PPI analysis.

## deconvolve_3tnoblur.tcsh
Deconvolve data without blur.

## generate_3t_roi.tcsh
Generate individual roi.

## generate_3t_ffa.tcsh
Generate individual FFA mask.

## generate_3t_ofc.tcsh
Generate individual OFC mask.

## indiv_cluster.bash
Find individual level cluster threshold for each roi.

## indiv_masks.bash
Get individual level significant clusters in each roi.

## indiv_masks_count.bash
Count number of significant voxels in each roi.

# Analysis

## group_cluster.bash
Group level cluster analysis. Run `3dClustSim` and add results to header.

## group_mvpa_cluster.bash
Generate group level cluster thresholds for searchlight.

## group_mvpa_lesion.bash
Generate group level lesion masks for decoding.

## group_mvpa_indlesion.bash
Generate individual level lesion masks for decoding.

## group_mvpa_lesionmap.bash
Generate individual level lesion masks from group level masks and ensure they are located in the individual ROI.

## group_mvpa_lesionacc.bash
Generate individual level lesion masks according to the proportion of voxels of significant clusters in each ROI at group level.

## group_interaction.bash
Group level ANOVA.

## group_ttest.bash
Group level ttest for main effect of visible faces.

## group_interaction_ppi.bash
Group level ANOVA for PPI analysis.

## group_ppi.bash
Group level ttest for PPI analysis.

## group_statas.bash
Dump betas from group level mask and individual masks.

## group_masks.bash
Get masks for main effects of face and odor. Get masks for significant clusters using `3dClusterize`.

## group_masks_plot.bash
Combine and convert searchlight results for plotting.

## group_percent.bash
Get percent of significant subjects in each voxel.

## group_anysig.tcsh
Get group level masks of significant voxels for any condition.

## map_masks.bash
Get individual level interaction mask and dump tent data.

## findtrs3t.m
Find TRs for each condition.

## decoding_roi.m
Decoding analysis. Train on visible and test on invisible.

## decoding_roitrans.m
Decoding analysis. Train on one condition and test on another.

## decoding_searchtrans.m
Searchlight trans-decoding analysis.

## decoding_search.m
Searchlight decoding analysis.

## decoding_roilesion.m
Decoding analysis using lesion masks.

## decoding_roilesiontest.m
Decoding analysis using lesion masks. Only modify test data.

## decoding_roilesionperm.m
Decoding analysis using randomly lesioned masks.

## decoding_roiavgperm.m
Average permutated lesion results.

## check_3t_decoding.m
Check searchlight results for 3T and generate `result_avg3t.bash`.

## result_avg3t_odor.bash
Normalize and average searchlight results for decoding odors.

## result_avg3t_face.bash
Normalize and average searchlight results for decoding faces.

## result_avg3t_trans.bash
Normalize and average searchlight results for trans decoding.

## result_avg3t_transavg.bash
Normalize and average searchlight results for trans decoding. Average vis to inv and inv to vis.

## run_decoding.tcsh
Run decoding analysis for Amy.

## results_labels_mean.Rmd
Generate mvpa results.

## results_labels_render.R
Render mvpa results.

## roistatas3t.Rmd
Plot time courses for each roi.

# plots

## plot3t.r
Plot results for 3T betas data.

## plot_mask.py
Plot intersection area between significant clusters.

## plot_mask_peak.py
Plot each peak as a sphere.

## plot_mvpat.py
Plot t values for searchlight.

## plot_mvpat_top.py
Restrict t values for plotting.

## plot_roi.py
Plot ROI for mvpa.

## plot_roisub.py
Plot individual ROI.

## GenerateDynamicCFS_UMNVAL.m
Generate dynamic noise.

## exp_pics.m
Generate pictures for experiment.
