#! /bin/csh

# use @SSwarper to process anatomy
set sub=S01_yyt
set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

# normalization
@SSwarper -input   S01_yyt.uniden15.nii             \
                   -subid ${sub}                    \
                   -odir  ${sub}_anat_warped        \
                   -base  MNI152_2009_template_SSW.nii.gz

# use freesurfer to reconstruct surfaces (1mm resolution)
# -sd pass working dir, the default is defined by env var 
recon-all                                           \
    -i ${sub}_anat_warped/anatU.${sub}.nii          \
    -s ${sub}_surf -sd ./                           \
    -all                                            \
    -parallel -threads 12

# high resolution reconstruction
recon-all                                                                                   \
-cm -i ${sub}_anat_warped/anatU.${sub}.nii                                                  \
-s ${sub}_surf_hires -sd ./                                                                       \
-all                                                                                        \
-parallel -threads 12                                                                       \
-expert /Users/mac/Documents/GitHub/fMRIdata/learning/mac_settings/freesurfer_expert.txt

# create files for suma
# -fs_setup might me useful on macOS according to the help page
@SUMA_Make_Spec_FS -fs_setup -NIFTI -fspath ${sub}_surf -sid ${sub}

# check alignment in SUMA folder
afni -niml
suma -spec ${sub}_surf/SUMA/${sub}_both.spec -sv ${sub}_surf/SUMA/${sub}_SurfVol.nii

# set results directory
set analysis=pabiode
set subj = ${sub}.${analysis}
cd ${subj}.results

# align exp anatomy to suma surfvolume
@SUMA_AlignToExperiment                                     \
-exp_anat anat_final.${subj}+orig.HEAD                      \
-surf_anat ../${sub}_surf/SUMA/${sub}_SurfVol.nii           \
-prefix surf_align.${subj}                                  \
-align_centers

# show results on surface
afni -niml
suma -spec ../${sub}_surf/SUMA/${sub}_both.spec -sv surf_align.${subj}+orig.HEAD