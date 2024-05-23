#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
# roi
# roi=Amy
for roi in OFC_AAL Amy fusiformCA
do
if [ "$roi" = "fusiformCA" ]; then
      mask=group/mask/fusiformCA+tlrc
      out=fusiformCA
elif [ "$roi" = "OFC_AAL" ]; then
      mask=group/mask/OFC_AAL+tlrc
      out=OFC_AAL
else
      mask=group/mask/Amy8_align.freesurfer+tlrc
      out=Amy
fi

# for each pvalue
for p in 0.001 #0.05  
do
    maskdec_t=1.9625
    name=group/findmask/${out}.NN2_bisided.1D
    nvox=$(sed -n "/^ $p/p" ${name})
    nvox=$(echo ${nvox} | awk '{print $2}')
#     echo ${nvox}
#     nvox=10
#     for brick in face face_vis face_inv odor
    for brick in faceall facevis faceinv odorall
    do
      #   3dClusterize -nosum -1Dformat \
      #   -inset group/ANOVA_results_wholenew+tlrc \
      #   -mask ${mask} \
      #   -idat "${brick}" -ithr "${brick} t" \
      #   -NN 2 -clust_nvox ${nvox} -bisided p=${p}
        3dClusterize -nosum -1Dformat \
        -inset group/ttest_absweight_${brick}_${maskdec_t}+tlrc \
        -mask ${mask} \
        -idat "all_mean" -ithr "all_Tstat" \
        -NN 2 -clust_nvox ${nvox} -bisided p=${p}
    done
done
done