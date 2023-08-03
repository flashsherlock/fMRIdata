#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
# roi
roi=Amy
nvox=40
# for each pvalue
for p in 0.001 #0.05  
do
    for brick in fointer_inv #face_inv odor_inv
    do
    mask=${datafolder}/group/mask/Cluster${nvox}_${p}_${brick}_${roi}+tlrc
    # indivisual masks
    for sub in S{03..29}
    do
        analysis=de
        subj=${sub}.${analysis}
        subdir=${sub}/${subj}.results
        # if subdir not exsist then continue
        if [ ! -d "${subdir}" ]; then
            echo "${subdir} not exsist"
            continue
        fi
        # cd to results folder
        cd "${subdir}" || exit    
        # map group level masks to individual space
        3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D  INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
             -source ${mask}  -interp NN -ainterp NN                   \
             -master anat_final.${subj}+orig    \
             -prefix ../mask/Indiv${nvox}_${p}_${brick}_${roi}
        # cd back
        cd "${datafolder}" || exit
    done
    done
done