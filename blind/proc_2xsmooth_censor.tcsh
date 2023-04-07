#! /bin/csh

# use input as sub
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_F/gufei/blind/${sub}
cd "${datafolder}"
set analysis=pade

# echo ${pa} ${analysis}
# ==========================processing========================== # 
        afni_proc.py                                                                            \
        -subj_id ${sub}.${analysis}                                                             \
        -dsets ${sub}.run?.nii                                                                  \
        -blip_reverse_dset ${sub}.pa.nii                                                        \
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
        # -volreg_align_e2a                                                                       \
        # -volreg_tlrc_warp                                                                       \
        -blur_size 3                                                                          \
        -regress_stim_times                                                                     \
                behavior/gas.txt                                                                \
                behavior/ind.txt                                                                \
                behavior/ros.txt                                                                \
                behavior/pin.txt                                                                \
                behavior/app.txt                                                                \
                behavior/min.txt                                                                \
                behavior/fru.txt                                                                \
                behavior/flo.txt                                                                \
        -regress_stim_labels                                                                    \
                gas ind ros pin app min fru flo                                                 \
        -regress_stim_types                                                                     \
                times times times times times times times times                                 \
        -regress_basis_multi                                                                    \
                'BLOCK(2,1)' 'BLOCK(2,1)' 'BLOCK(2,1)' 'BLOCK(2,1)' 'BLOCK(2,1)' 'BLOCK(2,1)' 'BLOCK(2,1)' 'BLOCK(2,1)'   \
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
