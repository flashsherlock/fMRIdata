#! /bin/csh

set datafolder=/Volumes/WD_D/share/7T
# set datafolder=/Volumes/WD_D/share/20200708_S0_WZHOU
cd "${datafolder}"

# to3d -prefix yuli.str *FMRI.0002.*.IMA
# to3d -prefix yuli.run1 *FMRI.0006.*.IMA
# to3d -prefix yuli.run2 *FMRI.0008.*.IMA
# to3d -prefix yuli.run3 *FMRI.0012.*.IMA
# to3d -prefix yuli.run4 *FMRI.0013.*.IMA
# mv *.BRIK ../7T
# mv *.HEAD ../7T

# to3d 结果是有问题的，Dimon比较好

# Dimon -infile_pattern '*FMRI.0006.*' \
# -gert_create_dataset \
# -gert_to3d_prefix yuli.run1 \
# -gert_outdir ../7T \
# -no_wait

# Dimon -infile_pattern '*FMRI.0008.*' \
# -gert_create_dataset \
# -gert_to3d_prefix yuli.run2 \
# -gert_outdir ../7T \
# -no_wait
#
# Dimon -infile_pattern '*FMRI.0012.*' \
# -gert_create_dataset \
# -gert_to3d_prefix yuli.run3 \
# -gert_outdir ../7T \
# -no_wait
#
# Dimon -infile_pattern '*FMRI.0013.*' \
# -gert_create_dataset \
# -gert_to3d_prefix yuli.run4 \
# -gert_outdir ../7T \
# -no_wait

# # reverse phase encoding images for pahse correction
# Dimon -infile_pattern '*FMRI.0017.*' \
# -gert_create_dataset \
# -gert_to3d_prefix yuli.run2.pa \
# -gert_outdir ../7T \
# -no_wait

# run4 完整但是没有刺激
# afni_proc.py                                                  \
#    -subj_id Yuli                                              \
#    -dsets yuli.run4+orig.HEAD                        \
#    -copy_anat yuli.str+orig                                   \
#    -anat_has_skull yes                                       \
#    -blocks tshift align volreg blur mask scale \
#    -radial_correlate_blocks tcat volreg                     \
#    -align_opts_aea -cost lpc+ZZ -giant_move -check_flip     \
#    -volreg_align_to MIN_OUTLIER                             \
#    -blur_size 4.0

# run3 不完整同时刺激不全
      # afni_proc.py                                                  \
      # -subj_id Yuli.run3                                              \
      # -dsets yuli.run3+orig.HEAD                        \
      # -copy_anat yuli.str+orig                                   \
      # -anat_has_skull yes                                       \
      # -blocks tshift align volreg blur mask scale regress \
      # -radial_correlate_blocks tcat volreg                     \
      # -align_opts_aea -cost lpc+ZZ -giant_move -check_flip     \
      # -volreg_align_to MIN_OUTLIER                             \
      # -blur_size 4.0                                           \
      # -regress_stim_times ../7Tdata/run3_fear.txt ../7Tdata/run3_neutral.txt        \
      # -regress_stim_labels fear neutral                             \
      # -regress_basis 'BLOCK(15,1)'                             \
      # -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
      #     -glt_label 1 H-N                                     \
      # -regress_motion_per_run                                  \
      # -regress_run_clustsim no                                 \
      # -html_review_style pythonic
      # -execute

# # run2 都是完整的 不check-flip
#       afni_proc.py                                                  \
#       -subj_id Yuli.run2                                              \
#       -dsets yuli.run2+orig.HEAD                        \
#       -copy_anat yuli.str+orig                                   \
#       -anat_has_skull yes                                       \
#       -blocks tshift align volreg blur mask scale regress \
#       -radial_correlate_blocks tcat volreg                     \
#       -align_opts_aea -cost lpc+ZZ -giant_move                 \
#       -volreg_align_to MIN_OUTLIER                             \
#       -blur_size 4.0                                           \
#       -regress_stim_times ../7Tdata/run2_fear.txt ../7Tdata/run2_neutral.txt        \
#       -regress_stim_labels fear neutral                             \
#       -regress_basis 'BLOCK(15,1)'                             \
#       -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
#           -glt_label 1 H-N                                     \
#       -regress_motion_per_run                                  \
#       -regress_run_clustsim no                                 \
#       -html_review_style pythonic

# run2 都是完整的 增加 phase correction-blip_reverse_dset
      afni_proc.py                                                  \
      -subj_id Yuli.run2.pa                                         \
      -dsets yuli.run2+orig.HEAD                        \
      -blip_reverse_dset yuli.run2.pa+orig.HEAD \
      -copy_anat yuli.str+orig                                   \
      -anat_has_skull yes                                       \
      -blocks tshift align volreg blur mask scale regress \
      -radial_correlate_blocks tcat volreg                     \
      -align_opts_aea -cost lpc+ZZ -giant_move                 \
      -volreg_align_to MIN_OUTLIER                             \
      -blur_size 4.0                                           \
      -regress_stim_times ../7Tdata/run2_fear.txt ../7Tdata/run2_neutral.txt        \
      -regress_stim_labels fear neutral                             \
      -regress_basis 'BLOCK(15,1)'                             \
      -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
          -glt_label 1 H-N                                     \
      -regress_motion_per_run                                  \
      -regress_run_clustsim no                                 \
      -html_review_style pythonic

# # run1 刺激完整但没有跑全
#       afni_proc.py                                                  \
#       -subj_id Yuli.run1                                              \
#       -dsets yuli.run1+orig.HEAD                        \
#       -copy_anat yuli.str+orig                                   \
#       -anat_has_skull yes                                       \
#       -blocks tshift align volreg blur mask scale regress \
#       -radial_correlate_blocks tcat volreg                     \
#       -align_opts_aea -cost lpc+ZZ -giant_move                 \
#       -volreg_align_to MIN_OUTLIER                             \
#       -blur_size 4.0                                           \
#       -regress_stim_times ../7Tdata/run1_fear.txt ../7Tdata/run1_neutral.txt        \
#       -regress_stim_labels fear neutral                             \
#       -regress_basis 'BLOCK(15,1)'                             \
#       -regress_opts_3dD -jobs 12 -gltsym 'SYM: fear -neutral'        \
#           -glt_label 1 H-N                                     \
#       -regress_motion_per_run                                  \
#       -regress_run_clustsim no                                 \
#       -html_review_style pythonic
