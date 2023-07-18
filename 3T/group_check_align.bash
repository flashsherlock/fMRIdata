#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw/group
cd "${datafolder}" || exit

# make dir image if not exist
if [ ! -d image/check ]; then
    mkdir -p image/check
fi

for sub in {03..29}
do
    subj=S${sub}.de
    # must use -all_dsets to read different folders
    afni                                                                                            \
    -all_dsets                                                                                      \
    -com "OPEN_WINDOW A.coronalimage"                                                               \
    -com "SET_XHAIRS A.OFF"                                                                         \
    -com "SWITCH_UNDERLAY MNI152_T1_2009c+tlrc"                                                     \
    -com "SWITCH_OVERLAY anatQQ.S${sub}+tlrc"                                                   \
    -com "SET_DICOM_XYZ A 0 0 0"                                                                    \
    -com "SAVE_PNG A.coronalimage ./image/check/S${sub}_coronal.png"                      \
    -com "SAVE_PNG A.axialimage ./image/check/S${sub}_axial.png"                          \
    -com "SAVE_PNG A.sagittalimage ./image/check/S${sub}_sagittal.png"                    \
    -com "QUIT"                                                                                     \
    ./ ../S${sub}/${subj}.results/
done

