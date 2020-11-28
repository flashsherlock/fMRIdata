#! /bin/csh

set sub=S01_yyt
set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"
# ==========================processing========================== # 
# run1 刺激完整 phase correction phy despike
        afni_proc.py                                                      \
        -subj_id ${sub}.paphde                                            \
        -dsets ${sub}.run?+orig.HEAD                                      \
        -blip_reverse_dset ${sub}.pa+orig.HEAD                            \
        -copy_anat ${sub}.uniden15_brain.nii.gz                           \
        -anat_has_skull no                                                \
        -blocks despike ricor tshift align volreg blur mask scale regress \
        -ricor_regs ./phy/${sub}.run?.slibase.1D                          \
        -radial_correlate_blocks tcat volreg                              \
        -align_opts_aea -cost lpc+ZZ -giant_move                          \
        -volreg_align_to MIN_OUTLIER                                      \
        -blur_size 3.0                                                    \
        -regress_stim_times behavior/lim.txt behavior/tra.txt behavior/car.txt behavior/cit.txt\
        -regress_stim_labels lim tra car cit                              \
        -regress_basis 'BLOCK(2,1)'                                       \
        -regress_opts_3dD -jobs 12                                        \
        -gltsym 'SYM: lim -tra'       -glt_label 1 lim-tra                \
        -gltsym 'SYM: car -tra'       -glt_label 2 car-tra                \
        -gltsym 'SYM: cit -tra'       -glt_label 3 cit-tra                \
        -gltsym 'SYM: car -lim'       -glt_label 4 car-lim                \
        -gltsym 'SYM: cit -lim'       -glt_label 5 car-lim                \
        -gltsym 'SYM: car -cit'       -glt_label 6 car-cit                \
        -regress_motion_per_run                                           \
        -regress_run_clustsim no                                 

