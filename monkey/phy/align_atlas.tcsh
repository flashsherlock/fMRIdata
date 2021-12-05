#!/bin/tcsh

# labels
set subj           = RM033
# upper directories
set dir_inroot     = /Volumes/System_C/Users/mac
set dir_ref        = ${dir_inroot}/NMT_v2.0_sym/NMT_v2.0_sym_05mm
# subject directories
set sdir_anat      = /Volumes/WD_D/gufei/monkey_data/IMG
set sdir_aw        = ${sdir_anat}/${subj}_NMT
# dataset inputs, with abbreviations for each 
set anat_orig    = ${sdir_anat}/${subj}_MRI_acpc.nii
set anat_orig_ab = ${subj}_anat

set ref_base     = ${dir_ref}/NMT_v2.0_sym_05mm_SS.nii.gz
set ref_base_ab  = NMT2

set ref_atl      = ( ${dir_ref}/SARM_in_NMT_v2.0_sym_05mm.nii.gz     \
                     ${dir_ref}/D99_atlas_in_NMT_v2.0_sym_05mm.nii.gz )
set ref_atl_ab   = ( SARM D99 )

set ref_seg      = ${dir_ref}/NMT_v2.0_sym_05mm_segmentation.nii.gz
set ref_seg_ab   = SEG

set ref_mask     = ${dir_ref}/NMT_v2.0_sym_05mm_brainmask.nii.gz 
set ref_mask_ab  = MASK

# ---------------------------------------------------------------------------
# run programs
# ---------------------------------------------------------------------------

time @animal_warper                                 \
    -echo                                           \
    -input            ${anat_orig}                  \
    -input_abbrev     ${anat_orig_ab}               \
    -base             ${ref_base}                   \
    -base_abbrev      ${ref_base_ab}                \
    -atlas_followers  ${ref_atl}                    \
    -atlas_abbrevs    ${ref_atl_ab}                 \
    -seg_followers    ${ref_seg}                    \
    -seg_abbrevs      ${ref_seg_ab}                 \
    -skullstrip       ${ref_mask}                   \
    -outdir           ${sdir_aw}                    \
    -ok_to_exist

