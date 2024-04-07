#! /bin/csh

# set sub=S01_yyt
# use input as sub
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/OlfDisk2/gf/7T_odor/${sub}
# make folder if not exisit
if ( ! -d "${datafolder}" ) then
        mkdir -p ${datafolder}
endif
set data=/Volumes/WD_F/gufei/7T_odor/${sub}
cd "${datafolder}"
# use resampled pa if it exist
if (-e ${data}/${sub}.par+orig.HEAD) then
        set pa=par
else
        set pa=pa
endif
set analysis=pabiode
# ==========================processing========================== # 
# run1 刺激完整 phase correction phy despike
        afni_proc.py                                                                            \
        -subj_id ${sub}.${analysis}                                                             \
        -dsets ${data}/${sub}.run?+orig.HEAD                                                            \
        -blip_reverse_dset ${data}/${sub}.${pa}+orig.HEAD                                                  \
        -copy_anat ${data}/${sub}_anat_warped/anatSS.${sub}.nii                                         \
        -anat_has_skull no                                                                      \
        -blocks despike tshift align tlrc volreg blur mask scale regress                        \
        -radial_correlate_blocks tcat volreg                                                    \
        -align_opts_aea -cost lpc+ZZ -giant_move                                                \
        -tlrc_base MNI152_2009_template_SSW.nii.gz                                              \
        -tlrc_NL_warp                                                                           \
        -tlrc_NL_warped_dsets                                                                   \
                ${data}/${sub}_anat_warped/anatQQ.${sub}.nii                                            \
                ${data}/${sub}_anat_warped/anatQQ.${sub}.aff12.1D                                       \
                ${data}/${sub}_anat_warped/anatQQ.${sub}_WARP.nii                                       \
        -volreg_align_to MIN_OUTLIER                                                            \
        # -volreg_align_e2a                                                                       \
        # -volreg_tlrc_warp                                                                       \
        -blur_size 2.2                                                                          \
        -regress_stim_times                                                                     \
                ${data}/behavior/lim.txt                                                                \
                ${data}/behavior/tra.txt                                                                \
                ${data}/behavior/car.txt                                                                \
                ${data}/behavior/cit.txt                                                                \
                ${data}/behavior/ind.txt                                                                \
                ${data}/behavior/valence.txt                                                            \
                ${data}/behavior/intensity.txt                                                          \
        -regress_stim_labels                                                                    \
                lim tra car cit ind val int                                                     \
        -regress_stim_types                                                                     \
                times times times times times AM1 AM1                                           \
        -regress_basis_multi                                                                    \
                'BLOCK(2,1)' 'BLOCK(2,1)' 'BLOCK(2,1)' 'BLOCK(2,1)' 'BLOCK(2,1)' 'dmBLOCK(1)' 'dmBLOCK(1)'   \
        -regress_opts_3dD                                                                       \
                -jobs 2                                                                        \
                -gltsym 'SYM: lim -tra'       -glt_label 1 lim-tra                              \
                -gltsym 'SYM: car -tra'       -glt_label 2 car-tra                              \
                -gltsym 'SYM: cit -tra'       -glt_label 3 cit-tra                              \
                -gltsym 'SYM: car -lim'       -glt_label 4 car-lim                              \
                -gltsym 'SYM: cit -lim'       -glt_label 5 cit-lim                              \
                -gltsym 'SYM: car -cit'       -glt_label 6 car-cit                              \
                -gltsym 'SYM: ind -lim'       -glt_label 7 ind-lim                              \
                -gltsym 'SYM: ind -tra'       -glt_label 8 ind-tra                              \
                -gltsym 'SYM: ind -car'       -glt_label 9 ind-car                              \
                -gltsym 'SYM: ind -cit'       -glt_label 10 ind-cit                             \
        -regress_motion_per_run                                                                 \
        -regress_censor_motion 0.3                                                              \
        -regress_run_clustsim no                                                                \
        -execute
else
 echo "Usage: $0 <Subjname> <analysis>"

endif  
