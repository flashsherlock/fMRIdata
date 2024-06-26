#! /bin/csh

# use input as sub
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_F/gufei/3T_cw/${sub}
cd "${datafolder}"
set analysis=de

# ==========================processing========================== # 
        afni_proc.py                                                                            \
        -subj_id ${sub}.${analysis}                                                             \
        -dsets ${sub}.run?.nii                                                 \
        -copy_anat ${sub}_anat_warped/anatSS.${sub}.nii                                         \
        -anat_has_skull no                                                                      \
        -blocks despike tshift align tlrc volreg blur mask scale regress                        \
        -radial_correlate_blocks tcat volreg                                                    \
        -align_opts_aea -cost lpc+ZZ -giant_move                                                \
        -tlrc_base MNI152_2009_template_SSW.nii.gz                                              \
        -tlrc_NL_warp                                                                           \
        -tlrc_NL_warped_dsets                                                                   \
                ${sub}_anat_warped/anatQQ.${sub}.nii                                            \
                ${sub}_anat_warped/anatQQ.${sub}.aff12.1D                                       \
                ${sub}_anat_warped/anatQQ.${sub}_WARP.nii                                       \
        -volreg_align_to MIN_OUTLIER                                                            \
        # -volreg_method 3dAllineate                                                              \
        # -volreg_allin_cost lpa+zz                                                               \
        # -volreg_align_e2a                                                                       \
        # -volreg_tlrc_warp                                                                       \
        -blur_size 3.6                                                                          \
        -regress_stim_times                                                                     \
                behavior/FearPleaVis.txt                                                                \
                behavior/FearPleaInv.txt                                                                \
                behavior/FearUnpleaVis.txt                                                                \
                behavior/FearUnpleaInv.txt                                                                \
                behavior/HappPleaVis.txt                                                                \
                behavior/HappPleaInv.txt                                                                \
                behavior/HappUnpleaVis.txt                                                                \
                behavior/HappUnpleaInv.txt                                                                \
        -regress_stim_labels                                                                    \
                FearPleaVis FearPleaInv FearUnpleaVis FearUnpleaInv HappPleaVis HappPleaInv HappUnpleaVis HappUnpleaInv                                                 \
        -regress_stim_types                                                                     \
                times times times times times times times times                                 \
        -regress_basis_multi                                                                    \
                'BLOCK(10,1)' 'BLOCK(10,1)' 'BLOCK(10,1)' 'BLOCK(10,1)' 'BLOCK(10,1)' 'BLOCK(10,1)' 'BLOCK(10,1)' 'BLOCK(10,1)'   \
        -regress_motion_per_run                                                                 \
        -regress_censor_motion 0.3                                                              \
        -regress_run_clustsim no
        # -regress_make_cbucket yes                                                               
        # -execute
        # more options for 3dD can be added by -regress_opts_3dD
        # -volreg_align_e2a                                        \    
        # -volreg_tlrc_warp   

else
 echo "Usage: $0 <Subjname> <analysis>"

endif
