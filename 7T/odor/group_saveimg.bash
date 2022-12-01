#! /bin/bash

# datafolder=/Volumes/WD_E/gufei/7T_odor/group
datafolder=/Volumes/WD_F/gufei/7T_odor/group
cd "${datafolder}" || exit
stats=stats

# make dir image if not exist
if [ ! -d image ]; then
    mkdir image
fi

# -com "OPEN_WINDOW A.coronalimage mont=3x2:3 geom=900x600" \

afni                                                                            \
-com "OPEN_WINDOW A.coronalimage"                                               \
-com "SET_XHAIRS A.OFF"                                                         \
-com "SWITCH_UNDERLAY MNI152_T1_2009c+tlrc"                                     \
-com "SWITCH_OVERLAY combine_car_cit+tlrc"                                      \
-com "SET_DICOM_XYZ A -30 2 -17"                                                \
-com "SET_SUBBRICKS A -1 0 1"                                                   \
-com "SAVE_PNG A.coronalimage ./image/group_sig_coronal.png"                    \
-com "SAVE_PNG A.axialimage ./image/group_sig_axial.png"                        \
-com "SAVE_PNG A.sagittalimage ./image/group_sig_sagittal.png"                  \
-com "SWITCH_OVERLAY ${stats}_carcit_percent+tlrc"                              \
-com "SAVE_PNG A.coronalimage ./image/group_percent_coronal.png"                \
-com "SAVE_PNG A.axialimage ./image/group_percent_axial.png"                    \
-com "SAVE_PNG A.sagittalimage ./image/group_percent_sagittal.png"              \
-com "SWITCH_OVERLAY ${stats}_carcit_pernorm+tlrc"                              \
-com "SAVE_PNG A.coronalimage ./image/group_pernorm_coronal.png"                \
-com "SAVE_PNG A.axialimage ./image/group_pernorm_axial.png"                    \
-com "SAVE_PNG A.sagittalimage ./image/group_pernorm_sagittal.png"              \
-com "SWITCH_OVERLAY ${stats}_abs_car_lim+tlrc"                                 \
-com "SAVE_PNG A.coronalimage ./image/group_abs_car-lim_coronal.png"            \
-com "SAVE_PNG A.axialimage ./image/group_abs_car-lim_axial.png"                \
-com "SAVE_PNG A.sagittalimage ./image/group_abs_car-lim_sagittal.png"          \
-com "SWITCH_OVERLAY ${stats}_abs_cit_lim+tlrc"                                 \
-com "SAVE_PNG A.coronalimage ./image/group_abs_cit-lim_coronal.png"            \
-com "SAVE_PNG A.axialimage ./image/group_abs_cit-lim_axial.png"                \
-com "SAVE_PNG A.sagittalimage ./image/group_abs_cit-lim_sagittal.png"          \
-com "SWITCH_OVERLAY stats_cit-car_abs+tlrc"                                    \
-com "SAVE_PNG A.coronalimage ./image/group_abs_coronal.png"                    \
-com "SAVE_PNG A.axialimage ./image/group_abs_axial.png"                        \
-com "SAVE_PNG A.sagittalimage ./image/group_abs_sagittal.png"                  \
-com "SWITCH_OVERLAY stats_cit-car_norm+tlrc"                                   \
-com "SAVE_PNG A.coronalimage ./image/group_norm_coronal.png"                   \
-com "SAVE_PNG A.axialimage ./image/group_norm_axial.png"                       \
-com "SAVE_PNG A.sagittalimage ./image/group_norm_sagittal.png"                 \
-com "SET_SUBBRICKS A -1 0 1"                                                   \
-com "SET_THRESHNEW A 0.05 *p"                                                  \
-com "SAVE_PNG A.coronalimage ./image/group_pabs_coronal.png"                   \
-com "SAVE_PNG A.axialimage ./image/group_pabs_axial.png"                       \
-com "SAVE_PNG A.sagittalimage ./image/group_pabs_sagittal.png"                 \
-com "QUIT"                                                                     \
./

# results for 1st and 2nd half of subjects
afni                                                                            \
-com "OPEN_WINDOW A.coronalimage"                                               \
-com "SET_XHAIRS A.OFF"                                                         \
-com "SET_DICOM_XYZ A -30 2 -17"                                                \
-com "SET_SUBBRICKS A -1 0 1"                                                   \
-com "SWITCH_UNDERLAY MNI152_T1_2009c+tlrc"                                     \
-com "SWITCH_OVERLAY ${stats}_carcit_per_half1+tlrc"                            \
-com "SAVE_PNG A.coronalimage ./image/group_per_half1_coronal.png"              \
-com "SAVE_PNG A.axialimage ./image/group_per_half1_axial.png"                  \
-com "SAVE_PNG A.sagittalimage ./image/group_per_half1_sagittal.png"            \
-com "SWITCH_OVERLAY ${stats}_carcit_per_half2+tlrc"                            \
-com "SAVE_PNG A.coronalimage ./image/group_per_half2_coronal.png"              \
-com "SAVE_PNG A.axialimage ./image/group_per_half2_axial.png"                  \
-com "SAVE_PNG A.sagittalimage ./image/group_per_half2_sagittal.png"            \
-com "SWITCH_OVERLAY stats_cit-car_abs_half1+tlrc"                              \
-com "SAVE_PNG A.coronalimage ./image/group_abs_half1_coronal.png"              \
-com "SAVE_PNG A.axialimage ./image/group_abs_half1_axial.png"                  \
-com "SAVE_PNG A.sagittalimage ./image/group_abs_half1_sagittal.png"            \
-com "SWITCH_OVERLAY stats_cit-car_abs_half2+tlrc"                              \
-com "SAVE_PNG A.coronalimage ./image/group_abs_half2_coronal.png"              \
-com "SAVE_PNG A.axialimage ./image/group_abs_half2_axial.png"                  \
-com "SAVE_PNG A.sagittalimage ./image/group_abs_half2_sagittal.png"            \
-com "SWITCH_OVERLAY ${stats}_carcit_pernorm_half1+tlrc"                        \
-com "SAVE_PNG A.coronalimage ./image/group_pernorm_half1_coronal.png"          \
-com "SAVE_PNG A.axialimage ./image/group_pernorm_half1_axial.png"              \
-com "SAVE_PNG A.sagittalimage ./image/group_pernorm_half1_sagittal.png"        \
-com "SWITCH_OVERLAY ${stats}_carcit_pernorm_half2+tlrc"                        \
-com "SAVE_PNG A.coronalimage ./image/group_pernorm_half2_coronal.png"          \
-com "SAVE_PNG A.axialimage ./image/group_pernorm_half2_axial.png"              \
-com "SAVE_PNG A.sagittalimage ./image/group_pernorm_half2_sagittal.png"        \
-com "SWITCH_OVERLAY stats_cit-car_norm_half1+tlrc"                             \
-com "SAVE_PNG A.coronalimage ./image/group_norm_half1_coronal.png"             \
-com "SAVE_PNG A.axialimage ./image/group_norm_half1_axial.png"                 \
-com "SAVE_PNG A.sagittalimage ./image/group_norm_half1_sagittal.png"           \
-com "SWITCH_OVERLAY stats_cit-car_norm_half2+tlrc"                             \
-com "SAVE_PNG A.coronalimage ./image/group_norm_half2_coronal.png"             \
-com "SAVE_PNG A.axialimage ./image/group_norm_half2_axial.png"                 \
-com "SAVE_PNG A.sagittalimage ./image/group_norm_half2_sagittal.png"           \
-com "QUIT"                                                                     \
./

# results for 1st and 2nd half of subjects (on a montage of 3x3) 
afni                                                                                            \
-com "OPEN_WINDOW A.coronalimage mont=3x3:3 geom=900x600"                                       \
-com "SET_XHAIRS A.OFF"                                                                         \
-com "SET_DICOM_XYZ A -30 2 -17"                                                                \
-com "SET_SUBBRICKS A -1 0 1"                                                                   \
-com "SWITCH_UNDERLAY MNI152_T1_2009c+tlrc"                                                     \
-com "SWITCH_OVERLAY ${stats}_carcit_percent+tlrc"                                              \
-com "SAVE_PNG A.coronalimage ./image/mont-30_2_-17/group_percent_coronal.png"                  \
-com "SAVE_PNG A.axialimage ./image/mont-30_2_-17/group_percent_axial.png"                      \
-com "SAVE_PNG A.sagittalimage ./image/mont-30_2_-17/group_percent_sagittal.png"                \
-com "SWITCH_OVERLAY stats_cit-car_abs+tlrc"                                                    \
-com "SAVE_PNG A.coronalimage ./image/mont-30_2_-17/group_abs_coronal.png"                      \
-com "SAVE_PNG A.axialimage ./image/mont-30_2_-17/group_abs_axial.png"                          \
-com "SAVE_PNG A.sagittalimage ./image/mont-30_2_-17/group_abs_sagittal.png"                    \
-com "SWITCH_OVERLAY ${stats}_carcit_pernorm+tlrc"                                              \
-com "SAVE_PNG A.coronalimage ./image/mont-30_2_-17/group_pernorm_coronal.png"                  \
-com "SAVE_PNG A.axialimage ./image/mont-30_2_-17/group_pernorm_axial.png"                      \
-com "SAVE_PNG A.sagittalimage ./image/mont-30_2_-17/group_pernorm_sagittal.png"                \
-com "SWITCH_OVERLAY stats_cit-car_norm+tlrc"                                                   \
-com "SAVE_PNG A.coronalimage ./image/mont-30_2_-17/group_norm_coronal.png"                     \
-com "SAVE_PNG A.axialimage ./image/mont-30_2_-17/group_norm_axial.png"                         \
-com "SAVE_PNG A.sagittalimage ./image/mont-30_2_-17/group_norm_sagittal.png"                   \
-com "SWITCH_OVERLAY ${stats}_carcit_per_half1+tlrc"                                            \
-com "SAVE_PNG A.coronalimage ./image/mont-30_2_-17/group_per_half1_coronal.png"                \
-com "SAVE_PNG A.axialimage ./image/mont-30_2_-17/group_per_half1_axial.png"                    \
-com "SAVE_PNG A.sagittalimage ./image/mont-30_2_-17/group_per_half1_sagittal.png"              \
-com "SWITCH_OVERLAY ${stats}_carcit_per_half2+tlrc"                                            \
-com "SAVE_PNG A.coronalimage ./image/mont-30_2_-17/group_per_half2_coronal.png"                \
-com "SAVE_PNG A.axialimage ./image/mont-30_2_-17/group_per_half2_axial.png"                    \
-com "SAVE_PNG A.sagittalimage ./image/mont-30_2_-17/group_per_half2_sagittal.png"              \
-com "SWITCH_OVERLAY stats_cit-car_abs_half1+tlrc"                                              \
-com "SAVE_PNG A.coronalimage ./image/mont-30_2_-17/group_abs_half1_coronal.png"                \
-com "SAVE_PNG A.axialimage ./image/mont-30_2_-17/group_abs_half1_axial.png"                    \
-com "SAVE_PNG A.sagittalimage ./image/mont-30_2_-17/group_abs_half1_sagittal.png"              \
-com "SWITCH_OVERLAY stats_cit-car_abs_half2+tlrc"                                              \
-com "SAVE_PNG A.coronalimage ./image/mont-30_2_-17/group_abs_half2_coronal.png"                \
-com "SAVE_PNG A.axialimage ./image/mont-30_2_-17/group_abs_half2_axial.png"                    \
-com "SAVE_PNG A.sagittalimage ./image/mont-30_2_-17/group_abs_half2_sagittal.png"              \
-com "SWITCH_OVERLAY ${stats}_carcit_pernorm_half1+tlrc"                                        \
-com "SAVE_PNG A.coronalimage ./image/mont-30_2_-17/group_pernorm_half1_coronal.png"            \
-com "SAVE_PNG A.axialimage ./image/mont-30_2_-17/group_pernorm_half1_axial.png"                \
-com "SAVE_PNG A.sagittalimage ./image/mont-30_2_-17/group_pernorm_half1_sagittal.png"          \
-com "SWITCH_OVERLAY ${stats}_carcit_pernorm_half2+tlrc"                                        \
-com "SAVE_PNG A.coronalimage ./image/mont-30_2_-17/group_pernorm_half2_coronal.png"            \
-com "SAVE_PNG A.axialimage ./image/mont-30_2_-17/group_pernorm_half2_axial.png"                \
-com "SAVE_PNG A.sagittalimage ./image/mont-30_2_-17/group_pernorm_half2_sagittal.png"          \
-com "SWITCH_OVERLAY stats_cit-car_norm_half1+tlrc"                                             \
-com "SAVE_PNG A.coronalimage ./image/mont-30_2_-17/group_norm_half1_coronal.png"               \
-com "SAVE_PNG A.axialimage ./image/mont-30_2_-17/group_norm_half1_axial.png"                   \
-com "SAVE_PNG A.sagittalimage ./image/mont-30_2_-17/group_norm_half1_sagittal.png"             \
-com "SWITCH_OVERLAY stats_cit-car_norm_half2+tlrc"                                             \
-com "SAVE_PNG A.coronalimage ./image/mont-30_2_-17/group_norm_half2_coronal.png"               \
-com "SAVE_PNG A.axialimage ./image/mont-30_2_-17/group_norm_half2_axial.png"                   \
-com "SAVE_PNG A.sagittalimage ./image/mont-30_2_-17/group_norm_half2_sagittal.png"             \
-com "QUIT"                                                                                     \
./