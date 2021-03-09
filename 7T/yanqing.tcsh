#! /bin/csh
set datafolder=/Volumes/WD_D/share/yanqing
# # set datafolder=/Volumes/WD_D/share/20200708_S0_WZHOU
cd "${datafolder}"

# 3dcopy ch2better.nii ch2better

# @SUMA_AlignToExperiment                                                 \
#     -exp_anat ch2better+orig                              \
#     -surf_anat suma_MNI_N27/MNI_N27_SurfVol.nii             \
#     -prefix ch2better_align                                   \
#     -wd                                                                 \
#     -align_centers

3dVol2Surf                                                                                  \
    -spec         suma_MNI_N27/MNI_N27_both.spec                               \
    -surf_A       suma_MNI_N27/lh.smoothwm                                                               \
    -sv           ch2better_align+orig                                        \
    -grid_parent  left+tlrc                                                  \
    -map_func     mask                                                                      \
    -debug        2                                                                         \
    -out_niml     PPA_T.lh.niml.dset

3dVol2Surf                                                                                  \
    -spec         suma_MNI_N27/MNI_N27_both.spec                               \
    -surf_A       suma_MNI_N27/rh.smoothwm                                                               \
    -sv           ch2better_align+orig                                        \
    -grid_parent  right+tlrc                                                  \
    -map_func     mask                                                                      \
    -debug        2                                                                         \
    -out_niml     PPA_T.rh.niml.dset
# foreach subj (`echo $*`)
# # foreach subj (`ls -d S*`)

# cd ${subj}

# 3dSkullStrip -input *.nii


# cd ..
# end

# whereami -mask_atlas_region Brainnetome_1.0::A35_36r_l -prefix "A35_36r_l.nii"
# whereami -mask_atlas_region Brainnetome_1.0::A35_36r_right -prefix "A35_36r_r.nii"
# whereami -mask_atlas_region Brainnetome_1.0::A35_36c_l -prefix "A35_36c_l.nii"
# whereami -mask_atlas_region Brainnetome_1.0::A35_36c_r -prefix "A35_36c_r.nii"
# whereami -mask_atlas_region Brainnetome_1.0::TL_l -prefix "TL_l.nii"
# whereami -mask_atlas_region Brainnetome_1.0::TL_r -prefix "TL_r.nii"
# whereami -mask_atlas_region Brainnetome_1.0::TI_l -prefix "TI_l.nii"
# whereami -mask_atlas_region Brainnetome_1.0::TI_r -prefix "Tight_r.nii"
# whereami -mask_atlas_region Brainnetome_1.0::TH_l -prefix "TH_l.nii"
# whereami -mask_atlas_region Brainnetome_1.0::TH_r -prefix "TH_r.nii"
# whereami -mask_atlas_region Brainnetome_1.0::A28_34_r -prefix "A28_34_r.nii"
# whereami -mask_atlas_region Brainnetome_1.0::A28_34_l -prefix "A28_34_l.nii"
