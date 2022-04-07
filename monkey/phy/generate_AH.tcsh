#!/bin/tcsh

foreach subj (RM033 RM035)

# subject directories
set sdir_anat      = /Volumes/WD_D/gufei/monkey_data/IMG
set sdir_aw        = ${sdir_anat}/${subj}_NMT

# if subj equals RM035, set x to -x
# in AFNI standard (RAI), -x=Right
if (${subj} == "RM035") then
    set x = -x
else
    set x = x
endif

# signify that the value at each voxel is an index into some set of labels
# nifti_tool -overwrite -mod_hdr -mod_field intent_code 1002 -infiles SARM_in_RM035_anat.nii

# generate Amygdala ROI (all level)
# 3dcalc -a SARM_in_RM033_anat.nii.gz -expr 'a*within(a,16,41)' -prefix SARM_in_RM033_anat_amy.nii

cd ${sdir_aw}

foreach level (5)

    # the level of the atlas equal to level-1
    set a_level=`expr $level - 1`
    # remove existing files
    # rm SARM_in_${subj}_AH_level${level}.nii
    # rm SARM_NMT_${subj}_AH_level${level}.nii
    # AFNI can not load data correctly if .nii and .nii.gz with the same name occur in the same folder
    # in individual space
    3dcalc                                                      \
    -a "SARM_in_${subj}_anat.nii.gz[${a_level}]"                \
    -expr "a*step(${x})*or(within(a,16,41),within(a,11,14))"    \
    -prefix SARM_in_${subj}_AH_level${level}.nii
    # in standard space
    3dcalc                                                      \
    -a "SARM_in_NMT_v2.0_sym_05mm.nii.gz[${a_level}]"           \
    -expr "a*step(${x})*or(within(a,16,41),within(a,11,14))"    \
    -prefix SARM_NMT_${subj}_AH_level${level}.nii   

end

end
