#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
# roi
roi=wholenew
nvox=1
# for each pvalue
# for p in 0.001 0.05  
# do
#     for brick in fointer_inv face_inv odor_inv
#     do
#         3dClusterize -nosum -1Dformat \
#         -inset group/ANOVA_results_${roi}+tlrc \
#         -idat "${brick}" -ithr "${brick} t" \
#         -NN 2 -clust_nvox ${nvox} -bisided p=${p}\
#         -pref_map group/mask/Cluster${nvox}_${p}_${brick}_${roi}
#     done
# # combine maps
# 3dcalc -a group/mask/Cluster${nvox}_${p}_fointer_inv_${roi}+tlrc \
# -b group/mask/Cluster${nvox}_${p}_face_inv_${roi}+tlrc \
# -c group/mask/Cluster${nvox}_${p}_odor_inv_${roi}+tlrc \
# -expr '20*bool(a)+10*bool(b)+1*bool(c)' \
# -prefix group/Cluster${nvox}_${p}_${roi}
# done

# for each pvalue
for p in 0.001 0.005 0.01 0.05
do
    # for brick in face odor
    # do
    #     3dClusterize -nosum -1Dformat \
    #     -inset group/ANOVA_results_${roi}+tlrc \
    #     -idat "${brick}" -ithr "${brick} t" \
    #     -NN 2 -clust_nvox ${nvox} -bisided p=${p}\
    #     -pref_map group/mask/Cluster${nvox}_${p}_${brick}_${roi}
    # done
    # visible face main effect
    3dClusterize -nosum -1Dformat \
        -inset group/ttest_facevis_whole+tlrc \
        -idat "all_mean" -ithr "all_Tstat" \
        -NN 2 -clust_nvox ${nvox} -bisided p=${p}\
        -pref_map group/mask/Cluster${nvox}_${p}_visface_${roi}
# combine maps
rm group/FvOCluster${nvox}_${p}_${roi}*
# 3dcalc \
# -a group/mask/Cluster${nvox}_${p}_face_${roi}+tlrc \
# -b group/mask/Cluster${nvox}_${p}_odor_${roi}+tlrc \
# -c group/ANOVA_results_${roi}+tlrc[23] \
# -d group/ANOVA_results_${roi}+tlrc[25] \
# -expr '20*bool(a)*(step(c)-0.5)+200*bool(b)*(step(d)-0.5)' \
# -prefix group/FOCluster${nvox}_${p}_${roi}
# visble face only
3dcalc \
-a group/mask/Cluster${nvox}_${p}_visface_${roi}+tlrc \
-b group/mask/Cluster${nvox}_${p}_odor_${roi}+tlrc \
-c group/ttest_facevis_whole+tlrc[0] \
-d group/ANOVA_results_${roi}+tlrc[25] \
-expr '20*bool(a)*(step(c)-0.5)+200*bool(b)*(step(d)-0.5)' \
-prefix group/FvOCluster${nvox}_${p}_${roi}
done

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
