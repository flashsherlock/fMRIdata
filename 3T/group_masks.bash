#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
# roi
# roi=Amy
for roi in Amy Pir fusiform FFA
do
nvox=10
if [ "$roi" = "whole" ]; then
      mask=group/mask/bmask.nii
      nvox=295
elif [ "$roi" = "Pir" ]; then
      mask=group/mask/Pir_new.draw+tlrc
      nvox=10
elif [ "$roi" = "FFA" ]; then
      mask=group/mask/FFA+tlrc
      nvox=27
elif [ "$roi" = "fusiform" ]; then
      mask=group/mask/fusiform+tlrc
      nvox=40
elif [ "$roi" = "fusiformCA" ]; then
      mask=group/mask/fusiformCA+tlrc
      nvox=36
elif [ "$roi" = "A37mlv" ]; then
      mask=group/mask/A37mlv+tlrc
      nvox=37
elif [ "$roi" = "A37mv" ]; then
      mask=group/mask/A37mv+tlrc
      nvox=23
else
      mask=group/mask/Amy8_align.freesurfer+tlrc
      nvox=11
fi

# for each pvalue
for p in 0.001 #0.05  
do
    for brick in face_vis odor fointer_inv fointer_vis face_inv
    do
        3dClusterize -nosum -1Dformat \
        -inset group/ANOVA_results_wholenew+tlrc \
        -mask ${mask} \
        -idat "${brick}" -ithr "${brick} t" \
        -NN 2 -clust_nvox ${nvox} -bisided p=${p}\
        -pref_map group/findmask/Cluster${nvox}_${p}_${brick}_${roi}
    done
# combine maps
# 3dcalc -a group/mask/Cluster${nvox}_${p}_fointer_inv_${roi}+tlrc \
# -b group/mask/Cluster${nvox}_${p}_face_inv_${roi}+tlrc \
# -c group/mask/Cluster${nvox}_${p}_odor_inv_${roi}+tlrc \
# -expr '20*bool(a)+10*bool(b)+1*bool(c)' \
# -prefix group/Cluster${nvox}_${p}_${roi}
done

# combine main effects
# for each pvalue
# for p in 0.001 0.005 0.01 0.05
# do
    # for brick in face odor
    # do
    #     3dClusterize -nosum -1Dformat \
    #     -inset group/ANOVA_results_${roi}+tlrc \
    #     -idat "${brick}" -ithr "${brick} t" \
    #     -NN 2 -clust_nvox ${nvox} -bisided p=${p}\
    #     -pref_map group/mask/Cluster${nvox}_${p}_${brick}_${roi}
    # done
    # visible face main effect
    # 3dClusterize -nosum -1Dformat \
    #     -inset group/ttest_facevis_whole+tlrc \
    #     -idat "all_mean" -ithr "all_Tstat" \
    #     -NN 2 -clust_nvox ${nvox} -bisided p=${p}\
    #     -pref_map group/mask/Cluster${nvox}_${p}_visface_${roi}
# combine maps
# rm group/FvOCluster${nvox}_${p}_${roi}*
# 3dcalc \
# -a group/mask/Cluster${nvox}_${p}_face_${roi}+tlrc \
# -b group/mask/Cluster${nvox}_${p}_odor_${roi}+tlrc \
# -c group/ANOVA_results_${roi}+tlrc[23] \
# -d group/ANOVA_results_${roi}+tlrc[25] \
# -expr '20*bool(a)*(step(c)-0.5)+200*bool(b)*(step(d)-0.5)' \
# -prefix group/FOCluster${nvox}_${p}_${roi}
# visble face only
# 3dcalc \
# -a group/mask/Cluster${nvox}_${p}_visface_${roi}+tlrc \
# -b group/mask/Cluster${nvox}_${p}_odor_${roi}+tlrc \
# -c group/ttest_facevis_whole+tlrc[0] \
# -d group/ANOVA_results_${roi}+tlrc[25] \
# -expr '20*bool(a)*(step(c)-0.5)+200*bool(b)*(step(d)-0.5)' \
# -prefix group/FvOCluster${nvox}_${p}_${roi}

# modality independent
# 3dcalc \
# -a group/mask/Cluster${nvox}_${p}_face_${roi}+tlrc \
# -b group/mask/Cluster${nvox}_${p}_odor_${roi}+tlrc \
# -expr 'and(bool(a),bool(b))' \
# -prefix group/FOindCluster${nvox}_${p}_${roi}
# 3dcalc \
# -a group/mask/Cluster${nvox}_${p}_visface_${roi}+tlrc \
# -b group/mask/Cluster${nvox}_${p}_odor_${roi}+tlrc \
# -expr 'and(bool(a),bool(b))' \
# -prefix group/FvOindCluster${nvox}_${p}_${roi}
# done

# indivisual masks
# for sub in S{03..29}
# do
#     analysis=de
#     subj=${sub}.${analysis}
#     subdir=${sub}/${subj}.results
#     # if subdir not exsist then continue
#     if [ ! -d "${subdir}" ]; then
#         echo "${subdir} not exsist"
#         continue
#     fi
#     # cd to results folder
#     cd "${subdir}" || exit
#     # generate masks
#     filedec=new
#     for p in 0.001 0.05  
#     do
#         for brick in Inviscon_incon face_inv odor_inv
#         do
#             3dClusterize -nosum -1Dformat \
#             -mask ../mask/Amy8_align.freesurfer+orig \
#             -inset stats.$subj.${filedec}+orig \
#             -idat "${brick}_GLT#0_Coef" -ithr "${brick}_GLT#0_Tstat" \
#             -NN 2 -clust_nvox ${nvox} -bisided p=${p}\
#             -pref_map ../mask/Cluster${nvox}_${p}_${brick}_${roi}
#         done
#     # combine maps
#     3dcalc -a ../mask/Cluster${nvox}_${p}_Inviscon_incon_${roi}+orig \
#     -b ../mask/Cluster${nvox}_${p}_face_inv_${roi}+orig \
#     -c ../mask/Cluster${nvox}_${p}_odor_inv_${roi}+orig \
#     -expr '20*bool(a)+10*bool(b)+1*bool(c)' \
#     -prefix ../mask/Cluster${nvox}_${p}_${roi}
#     done
#     # cd back
#     cd "${datafolder}" || exit
#     # count voxel numbers
#     for p in 0.001 0.05
#     do
#         # 3dROIstats -nzvoxels -mask ${sub}/mask/Cluster${nvox}_${p}_Inviscon_incon_${roi}+orig ${sub}/mask/Cluster${nvox}_${p}_Inviscon_incon_${roi}+orig >> group/Invcon${nvox}_${p}_${roi}.txt
#         3dROIstats -nzvoxels -mask "3dcalc( -a ${sub}/mask/Cluster${nvox}_${p}_Inviscon_incon_${roi}+orig -expr bool(a) )" ${sub}/mask/Amy8_align.freesurfer+orig >> group/Invcon${nvox}_${p}_${roi}.txt
#     done
# done
done