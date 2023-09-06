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
    for brick in odor # face_vis #fointer_inv #face_inv odor_inv
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
        # if mask exsist then remove it
        if [ -e "../mask/Indiv${nvox}_${p}_${brick}_${roi}+orig.HEAD" ]; then
            rm ../mask/Indiv${nvox}_${p}_${brick}_${roi}+orig*
        fi   
        # map group level masks to individual space
        3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D  INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
             -source ${mask}  -interp NN -ainterp NN                   \
             -master vr_base_min_outlier+orig    \
             -prefix ../mask/Indiv${nvox}_${p}_${brick}_${roi}
        # get tent values
        data_tent=tent.${subj}.odor_14+orig
        # rm ../../stats/${sub}/Indiv${nvox}_${p}_${brick}_${roi}_tent_12.txt
        3dROIstats -mask ../mask/Indiv${nvox}_${p}_${brick}_${roi}+orig \
            -nzmean ${data_tent}"[$(seq -s , 1 63)64]" >| ../../stats/${sub}/Indiv${nvox}_${p}_${brick}_${roi}_p_tent_14.txt    
        # cd back
        cd "${datafolder}" || exit
    done
    done
done