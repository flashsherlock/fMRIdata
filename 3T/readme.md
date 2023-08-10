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

# Analysis

## group_cluster.bash
Group level cluster analysis. Run `3dClustSim` and add results to header.

## group_interaction.bash
Group level ANOVA.

## group_interaction_ppi.bash
Group level ANOVA for PPI analysis.

## group_ppi.bash
Group level ttest for PPI analysis.

## group_statas.bash
Dump betas from group level mask.

## group_masks.bash
Get level masks for main effects of face and odor.

## map_masks.bash
Get individual level interaction mask and dump tent data.

## findtrs3t.m
Find TRs for each condition.