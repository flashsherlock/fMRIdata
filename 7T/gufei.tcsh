#! /bin/csh

set datafolder=/Volumes/WD_D/share/7T
# set datafolder=/Volumes/WD_D/share/20200811_S40_TEST02
cd "${datafolder}"

# to3d 结果是有问题的，Dimon比较好
# ==========================transform========================== #
# Dimon -infile_pattern '*FMRI.0010.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.run1 \
# -gert_outdir ../7T \
# -no_wait

# Dimon -infile_pattern '*FMRI.0012.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.run2 \
# -gert_outdir ../7T \
# -no_wait

# Dimon -infile_pattern '*FMRI.0013.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.run3 \
# -gert_outdir ../7T \
# -no_wait

# Dimon -infile_pattern '*FMRI.0015.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.run4 \
# -gert_outdir ../7T \
# -no_wait

# Dimon -infile_pattern '*FMRI.0017.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.run5 \
# -gert_outdir ../7T \
# -no_wait
# # reverse phase encoding images for pahse correction
# # run1
# Dimon -infile_pattern '*FMRI.0019.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.run1.pa \
# -gert_outdir ../7T \
# -no_wait

# # run2
# Dimon -infile_pattern '*FMRI.0021.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.run2.pa \
# -gert_outdir ../7T \
# -no_wait

# # run3
# Dimon -infile_pattern '*FMRI.0022.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.run3.pa \
# -gert_outdir ../7T \
# -no_wait

# # run4
# Dimon -infile_pattern '*FMRI.0023.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.run4.pa \
# -gert_outdir ../7T \
# -no_wait

# # run5
# Dimon -infile_pattern '*FMRI.0025.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.run5.pa \
# -gert_outdir ../7T \
# -no_wait

# # T1 weighted
# # INV1
# Dimon -infile_pattern '*FMRI.0003.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.inv1 \
# -gert_outdir ../7T \
# -no_wait

# # INV2
# Dimon -infile_pattern '*FMRI.0005.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.inv2 \
# -gert_outdir ../7T \
# -no_wait

# # UNI
# Dimon -infile_pattern '*FMRI.0008.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.uni \
# -gert_outdir ../7T \
# -no_wait

# ==========================nii format========================== #
# INV1
# Dimon -infile_pattern '*FMRI.0003.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.inv1.nii \
# -gert_outdir ../7T \
# -no_wait

# # INV2
# Dimon -infile_pattern '*FMRI.0005.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.inv2.nii \
# -gert_outdir ../7T \
# -no_wait

# # UNI
# Dimon -infile_pattern '*FMRI.0008.*' \
# -gert_create_dataset \
# -gert_to3d_prefix gufei.uni.nii \
# -gert_outdir ../7T \
# -no_wait

# denoise
# LN_MP2RAGE_DNOISE -INV1 gufei.inv1.nii -INV2 gufei.inv2.nii -UNI gufei.uni.nii -beta 0.6 -output gufei.uniden6.nii


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
# # run1 刺激完整 phase correction phy despike
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

# # run2 刺激完整 phase correction
        # afni_proc.py                                                  \
        # -subj_id gufei.run2.pa                                         \
        # -dsets gufei.run2+orig.HEAD                        \
        # -blip_reverse_dset gufei.run2.pa+orig.HEAD \
        # -copy_anat gufei.uniden15_brain.nii.gz                    \
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
        # -subj_id gufei.run3.paphde                                         \
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