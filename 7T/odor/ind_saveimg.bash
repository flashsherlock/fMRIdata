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

for sub in {04..11} {13..14} {16..29} {31..34}
do
    subj=S${sub}.pabiode
    threshold=0.05
    # get coordinates of allroi cit-lim max cluster max voxel
    coord=$(3dClusterize -nosum -orient RAI \
    -mask ../S${sub}/mask/allROI+orig \
    -inset ../S${sub}/${subj}.results/stats.${subj}.odorVI+orig \
    -idat 34 -ithr 35 -NN 2 -clust_nvox 10 -bisided p=${threshold} \
    | awk 'BEGIN {
            plus=1
            OFS = " "
        }             
            !/^#/ {
            if (plus>0){
                plus-=1
                print $(NF-2),$(NF-1),$NF
            }
        }')
    # must use -all_dsets to read different folders
    afni                                                                                            \
    -all_dsets                                                                                      \
    -com "OPEN_WINDOW A.coronalimage"                                                               \
    -com "SET_XHAIRS A.OFF"                                                                         \
    -com "SWITCH_UNDERLAY anat_final.S${sub}.pabiode+orig"                                          \
    -com "SWITCH_OVERLAY allroi_citcar.${subj}+orig"                                                \
    -com "SET_DICOM_XYZ A ${coord}"                                                                 \
    -com "SET_SUBBRICKS A -1 0 0"                                                                   \
    -com "SAVE_PNG A.coronalimage ./image/individual/S${sub}_orig_coronal.png"                      \
    -com "SAVE_PNG A.axialimage ./image/individual/S${sub}_orig_axial.png"                          \
    -com "SAVE_PNG A.sagittalimage ./image/individual/S${sub}_orig_sagittal.png"                    \
    -com "SWITCH_OVERLAY allroi_citcar_norm.${subj}+orig"                                           \
    -com "SAVE_PNG A.coronalimage ./image/individual/S${sub}_orig_norm_coronal.png"                 \
    -com "SAVE_PNG A.axialimage ./image/individual/S${sub}_orig_norm_axial.png"                     \
    -com "SAVE_PNG A.sagittalimage ./image/individual/S${sub}_orig_norm_sagittal.png"               \
    -com "QUIT"                                                                                     \
    ./ ../S${sub}/${subj}.results/
done

# make folders like orig_coronal and move png files to folder according to suffix
for suffix in orig_coronal orig_axial orig_sagittal orig_norm_coronal orig_norm_axial orig_norm_sagittal tlrc_coronal tlrc_axial tlrc_sagittal tlrc_norm_coronal tlrc_norm_axial tlrc_norm_sagittal
do
    if [ ! -d image/individual/${suffix} ]; then
        mkdir image/individual/${suffix}
    fi
    mv image/individual/*${suffix}.png image/individual/${suffix}
done
