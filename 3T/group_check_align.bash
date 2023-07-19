#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw/group
cd "${datafolder}" || exit

# make dir image if not exist
mkdir -p image/check
mkdir -p image/checkamy
mkdir -p image/checkt2amy
mkdir -p image/checkt2


for sub in {03..29}
do
    subj=S${sub}.de
    name=vr_base_min_outlier
    # cd ../S${sub}/${subj}.results/ || exit
    # 3dNwarpApply -nwarp "anatQQ.S${sub}_WARP.nii anatQQ.S${sub}.aff12.1D INV(anatSS.S${sub}_al_keep_mat.aff12.1D)"   \
    #          -source ${name}+orig                                                 \
    #          -master anatQQ.S${sub}+tlrc    \
    #          -prefix ${name}
    # cd "${datafolder}" || exit
    # must use -all_dsets to read different folders
    # anatomy
    # afni                                                                                            \
    # -all_dsets                                                                                      \
    # -com "OPEN_WINDOW A.coronalimage"                                                               \
    # -com "SET_XHAIRS A.OFF"                                                                         \
    # -com "SWITCH_UNDERLAY MNI152_T1_2009c+tlrc"                                                     \
    # -com "SWITCH_OVERLAY anatQQ.S${sub}+tlrc"                                                   \
    # -com "SET_DICOM_XYZ A 0 0 0"                                                                    \
    # -com "SAVE_PNG A.coronalimage ./image/check/S${sub}_coronal.png"                      \
    # -com "SAVE_PNG A.axialimage ./image/check/S${sub}_axial.png"                          \
    # -com "SAVE_PNG A.sagittalimage ./image/check/S${sub}_sagittal.png"                    \
    # -com "QUIT"                                                                                     \
    # ./ ../S${sub}/${subj}.results/
    # anatomy and Amy8
    # afni                                                                                            \
    # -all_dsets                                                                                      \
    # -com "OPEN_WINDOW A.coronalimage"                                                               \
    # -com "SET_XHAIRS A.OFF"                                                                         \
    # -com "SWITCH_UNDERLAY anatQQ.S${sub}+tlrc"                                                     \
    # -com "SWITCH_OVERLAY Amy8_align.freesurfer+tlrc"                                                   \
    # -com "SET_DICOM_XYZ A 26 2 -18"                                                                    \
    # -com "SAVE_PNG A.coronalimage ./image/checkamy/S${sub}_coronal.png"                      \
    # -com "SAVE_PNG A.axialimage ./image/checkamy/S${sub}_axial.png"                          \
    # -com "SAVE_PNG A.sagittalimage ./image/checkamy/S${sub}_sagittal.png"                    \
    # -com "QUIT"                                                                                     \
    # ./mask ../S${sub}/${subj}.results/
    # statas and anatomy
    # afni                                                                                            \
    # -all_dsets                                                                                      \
    # -com "OPEN_WINDOW A.coronalimage"                                                               \
    # -com "SET_XHAIRS A.OFF"                                                                         \
    # -com "SWITCH_UNDERLAY stats.S${sub}.de+tlrc"                                                     \
    # -com "SWITCH_OVERLAY Amy8_align.freesurfer+tlrc"                                                   \
    # -com "SET_DICOM_XYZ A 26 2 -18"                                                                    \
    # -com "SAVE_PNG A.coronalimage ./image/checkt2amy/S${sub}_coronal.png"                      \
    # -com "SAVE_PNG A.axialimage ./image/checkt2amy/S${sub}_axial.png"                          \
    # -com "SAVE_PNG A.sagittalimage ./image/checkt2amy/S${sub}_sagittal.png"                    \
    # -com "QUIT"                                                                                     \
    # ./mask ../S${sub}/${subj}.results/
    # t2 and anatomy
    afni                                                                                            \
    -all_dsets                                                                                      \
    -com "OPEN_WINDOW A.coronalimage keypress=e keypress=6"                                        \
    -com "OPEN_WINDOW A.sagitalimage keypress=e keypress=6"                                        \
    -com "OPEN_WINDOW A.axialimage keypress=e keypress=6"                                        \
    -com "SET_XHAIRS A.OFF"                                                                         \
    -com "SWITCH_UNDERLAY anatQQ.S${sub}+tlrc"                                                     \
    -com "SWITCH_OVERLAY ${name}+tlrc"                                                   \
    -com "SET_DICOM_XYZ A 26 2 -18"                                                        \
    -com "SAVE_PNG A.coronalimage ./image/checkt2/S${sub}_coronal.png"                      \
    -com "SAVE_PNG A.axialimage ./image/checkt2/S${sub}_axial.png"                          \
    -com "SAVE_PNG A.sagittalimage ./image/checkt2/S${sub}_sagittal.png"                    \
    -com "QUIT"                                                                                     \
    ./mask ../S${sub}/${subj}.results/
done

