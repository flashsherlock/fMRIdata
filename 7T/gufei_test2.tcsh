#! /bin/csh

set datafolder=/Volumes/WD_D/gufei/7T/20201030_S40_TEST03
# set datafolder=/Volumes/WD_D/share/20200811_S40_TEST02
cd "${datafolder}"

# to3d 结果是有问题的，Dimon比较好
# ==========================transform========================== #
@ n=1
foreach run (10 13 17 19 20 22)        
        Dimon -infile_pattern "*FMRI.00${run}.*" \
        -gert_create_dataset \
        -gert_to3d_prefix gufei.run${n} \
        -gert_outdir ../ \
        -no_wait
        @ n=$n + 1
end

# # pa
@ n=1
foreach run (12 14 18)        
        Dimon -infile_pattern "*FMRI.00${run}.*" \
        -gert_create_dataset \
        -gert_to3d_prefix gufei.run${n}.pa \
        -gert_outdir ../ \
        -no_wait
        @ n++
end

# ==========================nii format T1 weighted========================== #
# INV1
Dimon -infile_pattern '*FMRI.0003.*' \
-gert_create_dataset \
-gert_to3d_prefix gufei.inv1.nii \
-gert_outdir ../ \
-no_wait

# INV2
Dimon -infile_pattern '*FMRI.0008.*' \
-gert_create_dataset \
-gert_to3d_prefix gufei.inv2.nii \
-gert_outdir ../ \
-no_wait

# UNI
Dimon -infile_pattern '*FMRI.0006.*' \
-gert_create_dataset \
-gert_to3d_prefix gufei.uni.nii \
-gert_outdir ../ \
-no_wait

# denoise
LN_MP2RAGE_DNOISE -INV1 gufei.inv1.nii -INV2 gufei.inv2.nii -UNI gufei.uni.nii -beta 1.5 -output gufei.uniden15.nii

# test 3dretroicor
# 3dretroicor -card ../7Tdata/phy/test/puls01.1D -prefix gufei.run2.phy gufei.run2+orig
# 3dretroicor -card ../7Tdata/phy/puls01.1D -resp ../7Tdata/phy/resp01.1D -prefix gufei.run1.phy gufei.run1+orig
# ==========================processing========================== #
# # run1 刺激完整 phase correction phy despike
        # afni_proc.py                                                  \
        # -subj_id gufei.run1.pa                                         \
        # -dsets gufei.run1+orig.HEAD                        \
        # -blip_reverse_dset gufei.run1.pa+orig.HEAD \
        # -copy_anat gufei.uniden15_brain.nii.gz                      \
        # -anat_has_skull no                                       \
        # -blocks tshift align volreg blur mask scale regress \
        # -radial_correlate_blocks tcat volreg                     \
        # -align_opts_aea -cost lpc+ZZ -giant_move                 \
        # -volreg_align_to MIN_OUTLIER                             \
        # -blur_size 4.0                                           \
        # -regress_stim_times ../7Tdata/run1_fear.txt ../7Tdata/run1_neutral.txt        \
        # -regress_stim_labels fear neutral                             \
        # -regress_basis 'BLOCK(15,1)'                             \
        # -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
        #     -glt_label 1 F-N                                     \
        # -regress_motion_per_run                                  \
        # -regress_run_clustsim no  
# # run1 刺激完整 phase correction phy
        # afni_proc.py                                                  \
        # -subj_id gufei.run1.paph                                         \
        # -dsets gufei.run1+orig.HEAD                        \
        # -blip_reverse_dset gufei.run1.pa+orig.HEAD \
        # -copy_anat gufei.uniden15_brain.nii.gz                      \
        # -anat_has_skull no                                       \
        # -blocks ricor tshift align volreg blur mask scale regress \
        # -ricor_regs ../7Tdata/phy/gufei.run1.slibase.1D           \
        # -radial_correlate_blocks tcat volreg                     \
        # -align_opts_aea -cost lpc+ZZ -giant_move                 \
        # -volreg_align_to MIN_OUTLIER                             \
        # -blur_size 4.0                                           \
        # -regress_stim_times ../7Tdata/run1_fear.txt ../7Tdata/run1_neutral.txt        \
        # -regress_stim_labels fear neutral                             \
        # -regress_basis 'BLOCK(15,1)'                             \
        # -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
        #     -glt_label 1 F-N                                     \
        # -regress_motion_per_run                                  \
        # -regress_run_clustsim no   
# # run1 刺激完整 phase correction 试验3dretroicor
        # afni_proc.py                                                  \
        # -subj_id gufei.run1.paphret                                         \
        # -dsets gufei.run1.phy+orig.HEAD                        \
        # -blip_reverse_dset gufei.run1.pa+orig.HEAD \
        # -copy_anat gufei.uniden15_brain.nii.gz                      \
        # -anat_has_skull no                                       \
        # -blocks tshift align volreg blur mask scale regress \
        # -radial_correlate_blocks tcat volreg                     \
        # -align_opts_aea -cost lpc+ZZ -giant_move                 \
        # -volreg_align_to MIN_OUTLIER                             \
        # -blur_size 4.0                                           \
        # -regress_stim_times ../7Tdata/run1_fear.txt ../7Tdata/run1_neutral.txt        \
        # -regress_stim_labels fear neutral                             \
        # -regress_basis 'BLOCK(15,1)'                             \
        # -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
        #     -glt_label 1 F-N                                     \
        # -regress_motion_per_run                                  \
        # -regress_run_clustsim no  
# # run1 刺激完整 phase correction phy despike
        # afni_proc.py                                                  \
        # -subj_id gufei.run1.paphde                                         \
        # -dsets gufei.run1+orig.HEAD                        \
        # -blip_reverse_dset gufei.run1.pa+orig.HEAD \
        # -copy_anat gufei.uniden15_brain.nii.gz                      \
        # -anat_has_skull no                                       \
        # -blocks despike ricor tshift align volreg blur mask scale regress \
        # -ricor_regs ../7Tdata/phy/gufei.run1.slibase.1D           \
        # -radial_correlate_blocks tcat volreg                     \
        # -align_opts_aea -cost lpc+ZZ -giant_move                 \
        # -volreg_align_to MIN_OUTLIER                             \
        # -blur_size 4.0                                           \
        # -regress_stim_times ../7Tdata/run1_fear.txt ../7Tdata/run1_neutral.txt        \
        # -regress_stim_labels fear neutral                             \
        # -regress_basis 'BLOCK(15,1)'                             \
        # -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
        #     -glt_label 1 F-N                                     \
        # -regress_motion_per_run                                  \
        # -regress_run_clustsim no                                 

# =========================run2====================================
# run2 stopped unexpectly, and has broken resp file
# # run2 刺激完整 phase correction
        # afni_proc.py                                                  \
        # -subj_id gufei.run2.pa                                         \
        # -dsets gufei.run2+orig.HEAD                              \
        # -blip_reverse_dset gufei.run2.pa+orig.HEAD              \
        # -copy_anat  gufei.uniden15_brain.nii.gz                  \
        # -anat_has_skull no                                       \
        # -blocks tshift align volreg blur mask scale regress \
        # -radial_correlate_blocks tcat volreg                     \
        # -align_opts_aea -cost lpc+ZZ -giant_move                 \
        # -volreg_align_to MIN_OUTLIER                             \
        # -blur_size 4.0                                           \
        # -regress_stim_times ../7Tdata/run2_fear.txt ../7Tdata/run2_neutral.txt        \
        # -regress_stim_labels fear neutral                             \
        # -regress_basis 'BLOCK(15,1)'                             \
        # -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
        #     -glt_label 1 F-N                                     \
        # -regress_motion_per_run                                  \
        # -regress_run_clustsim no   
# # run2 刺激完整 phase correction 3dretroicor
        afni_proc.py                                                  \
        -subj_id gufei.run2.paphret                                         \
        -dsets gufei.run2.phy+orig.HEAD                              \
        -blip_reverse_dset gufei.run2.pa+orig.HEAD              \
        -copy_anat  gufei.uniden15_brain.nii.gz                  \
        -anat_has_skull no                                       \
        -blocks tshift align volreg blur mask scale regress \
        -radial_correlate_blocks tcat volreg                     \
        -align_opts_aea -cost lpc+ZZ -giant_move                 \
        -volreg_align_to MIN_OUTLIER                             \
        -blur_size 4.0                                           \
        -regress_stim_times ../7Tdata/run2_fear.txt ../7Tdata/run2_neutral.txt        \
        -regress_stim_labels fear neutral                             \
        -regress_basis 'BLOCK(15,1)'                             \
        -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
            -glt_label 1 F-N                                     \
        -regress_motion_per_run                                  \
        -regress_run_clustsim no  
# =========================run3====================================
# # run3 刺激完整 phase correction 
        # afni_proc.py                                                  \
        # -subj_id gufei.run3.pa                                         \
        # -dsets gufei.run3+orig.HEAD                        \
        # -blip_reverse_dset gufei.run3.pa+orig.HEAD \
        # -copy_anat gufei.uniden15_brain.nii.gz                    \
        # -anat_has_skull no                                       \
        # -blocks tshift align volreg blur mask scale regress \
        # -radial_correlate_blocks tcat volreg                     \
        # -align_opts_aea -cost lpc+ZZ -giant_move                 \
        # -volreg_align_to MIN_OUTLIER                             \
        # -blur_size 4.0                                           \
        # -regress_stim_times ../7Tdata/run1_fear.txt ../7Tdata/run1_neutral.txt        \
        # -regress_stim_labels fear neutral                             \
        # -regress_basis 'BLOCK(15,1)'                             \
        # -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
        #     -glt_label 1 F-N                                     \
        # -regress_motion_per_run                                  \
        # -regress_run_clustsim no   
# # run3 刺激完整 phase correction phy
        # afni_proc.py                                                  \
        # -subj_id gufei.run3.paph                                         \
        # -dsets gufei.run3+orig.HEAD                        \
        # -blip_reverse_dset gufei.run3.pa+orig.HEAD \
        # -copy_anat gufei.uniden15_brain.nii.gz                    \
        # -anat_has_skull no                                       \
        # -blocks ricor tshift align volreg blur mask scale regress \
        # -radial_correlate_blocks tcat volreg                     \
        # -ricor_regs ../7Tdata/phy/gufei.run3.slibase.1D           \
        # -align_opts_aea -cost lpc+ZZ -giant_move                 \
        # -volreg_align_to MIN_OUTLIER                             \
        # -blur_size 4.0                                           \
        # -regress_stim_times ../7Tdata/run1_fear.txt ../7Tdata/run1_neutral.txt        \
        # -regress_stim_labels fear neutral                             \
        # -regress_basis 'BLOCK(15,1)'                             \
        # -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
        #     -glt_label 1 F-N                                     \
        # -regress_motion_per_run                                  \
        # -regress_run_clustsim no   
# # run3 刺激完整 phase correction phy despike
        # afni_proc.py                                                  \
        # -subj_id gufei.run3.paphde2                                         \
        # -dsets gufei.run3+orig.HEAD                        \
        # -blip_reverse_dset gufei.run3.pa+orig.HEAD \
        # -copy_anat gufei.uniden15_brain.nii.gz                    \
        # -anat_has_skull no                                       \
        # -blocks despike ricor tshift align volreg blur mask scale regress \
        # -radial_correlate_blocks tcat volreg                     \
        # -ricor_regs ../7Tdata/phy/gufei.run3.slibase.1D           \
        # -align_opts_aea -cost lpc+ZZ -giant_move                 \
        # -volreg_align_to MIN_OUTLIER                             \
        # -blur_size 4.0                                           \
        # -regress_stim_times ../7Tdata/run1_fear.txt ../7Tdata/run1_neutral.txt        \
        # -regress_stim_labels fear neutral                             \
        # -regress_basis 'BLOCK(15,1)'                             \
        # -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
        #     -glt_label 1 F-N                                     \
        # -regress_motion_per_run                                  \
        # -regress_run_clustsim no   

# =========================run4====================================
# # run4 刺激完整 phase correction phy despike
        # afni_proc.py                                                  \
        # -subj_id gufei.run4.paphde                                         \
        # -dsets gufei.run4+orig.HEAD                        \
        # -blip_reverse_dset gufei.run4.pa+orig.HEAD \
        # -copy_anat gufei.uniden15_brain.nii.gz                    \
        # -anat_has_skull no                                       \
        # -blocks despike ricor tshift align volreg blur mask scale regress \
        # -radial_correlate_blocks tcat volreg                     \
        # -ricor_regs ../7Tdata/phy/gufei.run4.slibase.1D           \
        # -align_opts_aea -cost lpc+ZZ -giant_move                 \
        # -volreg_align_to MIN_OUTLIER                             \
        # -blur_size 3.0                                           \
        # -regress_stim_times ../7Tdata/run2_fear.txt ../7Tdata/run2_neutral.txt        \
        # -regress_stim_labels fear neutral                             \
        # -regress_basis 'BLOCK(15,1)'                             \
        # -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
        #     -glt_label 1 F-N                                     \
        # -regress_motion_per_run                                  \
        # -regress_run_clustsim no 
# =========================run5====================================
# # run5 刺激完整 phase correction phy despike
        # afni_proc.py                                                  \
        # -subj_id gufei.run5.paphde                                         \
        # -dsets gufei.run5+orig.HEAD                        \
        # -blip_reverse_dset gufei.run5.pa+orig.HEAD \
        # -copy_anat gufei.uniden15_brain.nii.gz                    \
        # -anat_has_skull no                                       \
        # -blocks despike ricor tshift align volreg blur mask scale regress \
        # -radial_correlate_blocks tcat volreg                     \
        # -ricor_regs ../7Tdata/phy/gufei.run5.slibase.1D           \
        # -align_opts_aea -cost lpc+ZZ -giant_move                 \
        # -volreg_align_to MIN_OUTLIER                             \
        # -blur_size 4.0                                           \
        # -regress_stim_times ../7Tdata/run1_fear.txt ../7Tdata/run1_neutral.txt        \
        # -regress_stim_labels fear neutral                             \
        # -regress_basis 'BLOCK(15,1)'                             \
        # -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
        #     -glt_label 1 F-N                                     \
        # -regress_motion_per_run                                  \
        # -regress_run_clustsim no 