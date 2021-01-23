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

# create files for suma
# -fs_setup might me useful on macOS according to the help page
@SUMA_Make_Spec_FS -fs_setup -NIFTI -fspath ${sub}_surf -sid ${sub}

# Amygdala segmentation
# use multipal threads
setenv ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS 12
# the second input is subject_dir, error will occur when using ./
segmentHA_T1.sh ${sub}_surf ${datafolder}
# save amygdala mask
set masks = `ls ${sub}_surf/mri/?h.hippoAmygLabels-T1.v21.HBT.mgz`
# echo ${masks}
foreach mask (${masks})
    # echo ${mask}
    # change name
    set name = `echo ${mask} | cut -d '/' -f 3 | sed 's/.mgz/.nii/'`
    # echo ${name}
    mri_convert -ot nii ${mask} ${sub}_surf/SUMA/${name}
end
# check alignment in SUMA folder
afni -niml
suma -spec ${sub}_surf/SUMA/${sub}_both.spec -sv ${sub}_surf/SUMA/${sub}_SurfVol.nii

# set results directory
set analysis=pabiode
set subj = ${sub}.${analysis}
cd ${subj}.results

# align exp anatomy to suma surfvolume
# use wd to apply 12 parameters affine transform
# surf_anat is in different grids and has skull
@SUMA_AlignToExperiment                                                 \
    -exp_anat anat_final.${subj}+orig.HEAD                              \
    -surf_anat ../${sub}_surf/SUMA/${sub}_SurfVol.nii                   \
    -prefix surf_align.${subj}                                          \
    -strip_skull surf_anat                                              \
    -wd                                                                 \
    -align_centers

# show results on surface
afni -niml
suma -spec ../${sub}_surf/SUMA/${sub}_both.spec -sv surf_align.${subj}+orig.HEAD

# project results in piriform to surface
3dVol2Surf                                                                                  \
    -spec         ../${sub}_surf/SUMA/${sub}_both.spec                                      \
    -surf_A       lh.smoothwm                                                               \
    -sv           surf_align.${subj}+orig.HEAD                                              \
    -grid_parent "stats.${subj}+orig.HEAD"                                                  \
    -cmask       "-a mvpamask/Piriform.${sub}+orig.HEAD -expr step(a)"                      \
    -map_func     mask                                                                      \
    -debug        2                                                                         \
    -out_niml     ${sub}_Piriform_lh.niml.dset

3dVol2Surf                                                                                  \
    -spec         ../${sub}_surf/SUMA/${sub}_both.spec                                      \
    -surf_A       rh.smoothwm                                                               \
    -sv           surf_align.${subj}+orig.HEAD                                              \
    -grid_parent "stats.${subj}+orig.HEAD"                                                  \
    -cmask       "-a mvpamask/Piriform.${sub}+orig.HEAD -expr step(a)"                      \
    -map_func     mask                                                                      \
    -debug        2                                                                         \
    -out_niml     ${sub}_Piriform_rh.niml.dset

# try other mapping functions
3dVol2Surf                                                                                  \
    -spec         ../${sub}_surf/SUMA/${sub}_both.spec                                      \
    -surf_A       lh.smoothwm                                                               \
    -surf_B       lh.pial                                                                   \
    -sv           surf_align.${subj}+orig.HEAD                                              \
    -grid_parent "stats.${subj}+orig.HEAD"                                                  \
    -cmask       "-a mvpamask/Piriform.${sub}+orig.HEAD -expr step(a)"                      \
    -f_steps      10                                                                        \
    -f_index      nodes                                                                     \
    -map_func     ave                                                                       \
    -debug        2                                                                         \
    -out_niml     ${sub}_Piriform_ave_lh.niml.dset

3dVol2Surf                                                                                  \
    -spec         ../${sub}_surf/SUMA/${sub}_both.spec                                      \
    -surf_A       rh.smoothwm                                                               \
    -surf_B       rh.pial                                                                   \
    -sv           surf_align.${subj}+orig.HEAD                                              \
    -grid_parent "stats.${subj}+orig.HEAD"                                                  \
    -cmask       "-a mvpamask/Piriform.${sub}+orig.HEAD -expr step(a)"                      \
    -f_steps      10                                                                        \
    -f_index      nodes                                                                     \
    -map_func     ave                                                                       \
    -debug        2                                                                         \
    -out_niml     ${sub}_Piriform_ave_rh.niml.dset