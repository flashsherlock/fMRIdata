#! /bin/bash

datafolder=/Volumes/WD_E/gufei/7T_odor/group
cd "${datafolder}" || exit
stats=stats

# make dir image if not exist
if [ ! -d image ]; then
    mkdir image
fi

# -com "OPEN_WINDOW A.coronalimage mont=3x2:3 geom=900x600" \

afni                                                  \
-com "OPEN_WINDOW A.coronalimage"                     \
-com "SET_XHAIRS A.OFF"                               \
-com "SWITCH_UNDERLAY MNI152_T1_2009c+tlrc"           \
-com "SWITCH_OVERLAY combine_car_cit+tlrc"            \
-com "SET_DICOM_XYZ A -30 2 -17"                      \
-com "SET_SUBBRICKS A -1 0 1"                         \
-com "SAVE_PNG A.coronalimage ./image/group_sig_coronal.png"     \
-com "SAVE_PNG A.axialimage ./image/group_sig_axial.png"         \
-com "SAVE_PNG A.sagittalimage ./image/group_sig_sagittal.png"   \
-com "SWITCH_OVERLAY ${stats}_carcit_percent+tlrc"                \
-com "SAVE_PNG A.coronalimage ./image/group_percent_coronal.png" \
-com "SAVE_PNG A.axialimage ./image/group_percent_axial.png"     \
-com "SAVE_PNG A.sagittalimage ./image/group_percent_sagittal.png"     \
-com "SWITCH_OVERLAY ${stats}_abs_car_lim+tlrc"                \
-com "SAVE_PNG A.coronalimage ./image/group_abs_car-lim_coronal.png" \
-com "SAVE_PNG A.axialimage ./image/group_abs_car-lim_axial.png"     \
-com "SAVE_PNG A.sagittalimage ./image/group_abs_car-lim_sagittal.png"     \
-com "SWITCH_OVERLAY ${stats}_abs_cit_lim+tlrc"                \
-com "SAVE_PNG A.coronalimage ./image/group_abs_cit-lim_coronal.png" \
-com "SAVE_PNG A.axialimage ./image/group_abs_cit-lim_axial.png"     \
-com "SAVE_PNG A.sagittalimage ./image/group_abs_cit-lim_sagittal.png"     \
-com "SWITCH_OVERLAY stats_cit-car_abs+tlrc"                            \
-com "SAVE_PNG A.coronalimage ./image/group_abs_coronal.png"           \
-com "SAVE_PNG A.axialimage ./image/group_abs_axial.png"               \
-com "SAVE_PNG A.sagittalimage ./image/group_abs_sagittal.png"         \
-com "QUIT"                                     \
./