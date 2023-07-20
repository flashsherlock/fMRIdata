#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
roi=Amy
nvox=1
# for each pvalue
for p in 0.001 0.05  
do
    for brick in fointer_inv face_inv odor_inv
    do
        3dClusterize -nosum -1Dformat \
        -inset group/ANOVA_results_${roi}+tlrc \
        -idat "${brick}" -ithr "${brick} t" \
        -NN 2 -clust_nvox ${nvox} -bisided p=${p}\
        -pref_map group/mask/Cluster${nvox}_${p}_${brick}_${roi}
    done
# combine maps
3dcalc -a group/mask/Cluster${nvox}_${p}_fointer_inv_${roi}+tlrc \
-b group/mask/Cluster${nvox}_${p}_face_inv_${roi}+tlrc \
-c group/mask/Cluster${nvox}_${p}_odor_inv_${roi}+tlrc \
-expr '20*bool(a)+10*bool(b)+1*bool(c)' \
-prefix group/Cluster${nvox}_${p}_${roi}
done
