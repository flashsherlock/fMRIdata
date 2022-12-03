#! /bin/bash

# datafolder=/Volumes/WD_E/gufei/7T_odor/group
datafolder=/Volumes/WD_F/gufei/7T_odor/group
cd "${datafolder}" || exit

# make dir image if not exist
if [ ! -d image/individual ]; then
    mkdir image/individual
fi

# for 28 subs {04..11} {13..14} {16..29} {31..34}
for sub in {04..11} {13..14} {16..29} {31..34}
do
    subj=S${sub}.pabiode
    # must use -all_dsets to read different folders
    afni                                                                                            \
    -all_dsets                                                                                      \
    -com "OPEN_WINDOW A.coronalimage"                                                               \
    -com "SET_XHAIRS A.OFF"                                                                         \
    -com "SWITCH_UNDERLAY MNI152_T1_2009c+tlrc"                                                     \
    -com "SWITCH_OVERLAY allroi_citcar.${subj}+tlrc"                                                \
    -com "SET_DICOM_XYZ A -30 2 -17"                                                                \
    -com "SET_SUBBRICKS A -1 0 0"                                                                   \
    -com "SAVE_PNG A.coronalimage ./image/individual/S${sub}_tlrc_coronal.png"                      \
    -com "SAVE_PNG A.axialimage ./image/individual/S${sub}_tlrc_axial.png"                          \
    -com "SAVE_PNG A.sagittalimage ./image/individual/S${sub}_tlrc_sagittal.png"                    \
    -com "SWITCH_OVERLAY allroi_citcar_norm.${subj}+tlrc"                                           \
    -com "SAVE_PNG A.coronalimage ./image/individual/S${sub}_tlrc_norm_coronal.png"                 \
    -com "SAVE_PNG A.axialimage ./image/individual/S${sub}_tlrc_norm_axial.png"                     \
    -com "SAVE_PNG A.sagittalimage ./image/individual/S${sub}_tlrc_norm_sagittal.png"               \
    -com "QUIT"                                                                                     \
    ./ ../S${sub}/${subj}.results/
done