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

# use freesurfer to reconstruct surfaces
# -sd pass working dir, the default is defined by env var 
# high resolution reconstruction
recon-all                                                                                   \
-cm -i ${sub}_anat_warped/anatU.${sub}.nii                                                  \
-s ${sub}_surf_hires -sd ./                                                                 \
-all                                                                                        \
-parallel -threads 12                                                                       \
-expert /Users/mac/Documents/GitHub/fMRIdata/learning/mac_settings/freesurfer_expert.txt

# create files for suma
# -fs_setup might me useful on macOS according to the help page
@SUMA_Make_Spec_FS -fs_setup -NIFTI -fspath ${sub}_surf_hires -sid ${sub}

# Amygdala segmentation
# use multipal threads
setenv ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS 12
# the second input is subject_dir, error will occur when using ./
segmentHA_T1.sh ${sub}_surf_hires ${datafolder}
# save amygdala mask
set masks = `ls ${sub}_surf_hires/mri/?h.hippoAmygLabels-T1.v21.HBT.mgz`
# echo ${masks}
foreach mask (${masks})
    # echo ${mask}
    # change name
    set name = `echo ${mask} | cut -d '/' -f 3 | sed 's/.mgz/.nii/'`
    # echo ${name}
    mri_convert -ot nii ${mask} ${sub}_surf_hires/SUMA/${name}
end

# check alignment in SUMA folder
afni -niml
suma -spec ${sub}_surf_hires/SUMA/${sub}_both.spec -sv ${sub}_surf/SUMA/${sub}_SurfVol.nii

# set results directory
set analysis=pabiode
set subj = ${sub}.${analysis}
cd ${subj}.results

# align exp anatomy to suma surfvolume
# use wd to apply 12 parameters affine transform
# surf_anat is in different grids and has skull
# an error will occur if set prefix in -skull_strip_opt
@SUMA_AlignToExperiment                                                 \
    -exp_anat anat_final.${subj}+orig.HEAD                              \
    -surf_anat ../${sub}_surf_hires/SUMA/${sub}_SurfVol.nii             \
    -prefix surf_hires_align.${subj}                                    \
    -strip_skull surf_anat                                              \
    -wd                                                                 \
    -align_centers
# change segmentation masks to experiment space
# can also use -surf_anat_followers option in @SUMA_AlignToExperiment 
foreach mask (${masks})
    set input = `echo ${mask} | sed 's/mri/SUMA/' | sed 's/.mgz/.nii/'`
    set output = `echo ${input} | cut -d '/' -f 3 | sed 's/.nii/+orig/'`
    # resample to the EPI grid
    3dAllineate                                                             \
        -master stats.${subj}+orig                                          \
        -1Dmatrix_apply surf_hires_align.${subj}.A2E.1D                     \
        -input ../${input}                                                  \
        -prefix ${output}                                                   \
        -final NN
    # resample to the anatomy grid (similar)
    # 3dAllineate                                                             \
    #     -master anat_final.${subj}+orig                                     \
    #     -1Dmatrix_apply surf_hires_align.${subj}.A2E.1D                     \
    #     -input ../${input}                                                  \
    #     -prefix ant.${output}                                               \
    #     -final NN
    # lr can be l left or r right
    set lr=`echo ${output} | cut -c1`
    3dcalc -a "${output}<7001..7015>" -expr 'step(a-7000)' -prefix ${lr}Amy.freesurfer+orig   
    3dcalc -a "${output}" -expr 'ispositive(a-7000)*(a-7000)' -prefix ${lr}Amy.seg.freesurfer+orig   
    # 3dcalc -a "ant.${output}<7001..7015>" -expr 'step(a-7000)' -prefix ant.${lr}Amy.freesurfer+orig   
    # 3dcalc -a "ant.${output}" -expr 'ispositive(a-7000)*(a-7000)' -prefix ant.${lr}Amy.seg.freesurfer+orig   
end

3dcalc -a lAmy.freesurfer+orig -b rAmy.freesurfer+orig -expr 'a+b' -prefix Amy.freesurfer+orig
3dcalc -a lAmy.seg.freesurfer+orig -b rAmy.seg.freesurfer+orig -expr 'a+b' -prefix Amy.seg.freesurfer+orig
# 3dcalc -a ant.lAmy.freesurfer+orig -b ant.rAmy.freesurfer+orig -expr 'a+b' -prefix ant.Amy.freesurfer+orig
# 3dcalc -a ant.lAmy.seg.freesurfer+orig -b ant.rAmy.seg.freesurfer+orig -expr 'a+b' -prefix ant.Amy.seg.freesurfer+orig

# show results on surface
afni -niml
suma -spec ../${sub}_surf_hires/SUMA/${sub}_both.spec -sv surf_hires_align.${subj}+orig.HEAD

# project results in piriform to surface
3dVol2Surf                                                                                  \
    -spec         ../${sub}_surf_hires/SUMA/${sub}_both.spec                                \
    -surf_A       lh.smoothwm                                                               \
    -sv           surf_hires_align.${subj}+orig.HEAD                                        \
    -grid_parent "stats.${subj}+orig.HEAD"                                                  \
    -cmask       "-a mvpamask/Piriform.${sub}+orig.HEAD -expr step(a)"                      \
    -map_func     mask                                                                      \
    -debug        2                                                                         \
    -out_niml     ${sub}_Piriform_hires_lh.niml.dset

3dVol2Surf                                                                                  \
    -spec         ../${sub}_surf_hires/SUMA/${sub}_both.spec                                \
    -surf_A       rh.smoothwm                                                               \
    -sv           surf_hires_align.${subj}+orig.HEAD                                        \
    -grid_parent "stats.${subj}+orig.HEAD"                                                  \
    -cmask       "-a mvpamask/Piriform.${sub}+orig.HEAD -expr step(a)"                      \
    -map_func     mask                                                                      \
    -debug        2                                                                         \
    -out_niml     ${sub}_Piriform_hires_rh.niml.dset

