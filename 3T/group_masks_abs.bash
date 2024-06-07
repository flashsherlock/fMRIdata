#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
prefix=absweight0
# open new file
printf "odorinv odorvis odorall faceinv facevis faceall\n" > group/${prefix}_results.txt
# for each maskdec_t
for maskdec_t in 1.6465 #1.9625 #2.5812 3.3011
do
# for each pvalue
for p in 0.005 #0.001 0.005 0.01 0.05
do
    for roi in OFC_AAL Amy fusiformCA FFV01 whole #fusiformAAL FFVAAL FFVAAL05 FFVAAL01 FFVAAL001 FFV FFV01 FFV005 
    do
      if [ "$roi" = "Amy" ]; then
            mask=group/mask/Amy8_align.freesurfer+tlrc
            out=Amy
      elif [ "$roi" = "whole" ]; then
            mask=group/mask/bmask.nii
            out=whole
      else
            mask=group/mask/$roi+tlrc
            out=$roi
      fi
      name=group/findmask/${out}.NN2_bisided.1D
      nvox=$(sed -n "/^ $p/p" ${name})
      nvox=$(echo ${nvox} | awk '{print $3}')
      #     echo ${nvox}
      #     nvox=10
      results=${roi}_${p}_${maskdec_t}
      # for brick in face face_vis face_inv odor
      # for brick in faceall facevis faceinv odorall #odorvis odorinv
      # do
      #       # string=$(3dClusterize -nosum -1Dformat \
      #       #   -inset group/ANOVA_results_wholenew+tlrc \
      #       #   -mask ${mask} \
      #       #   -idat "${brick}" -ithr "${brick} t" \
      #       #   -NN 2 -clust_nvox ${nvox} -bisided p=${p})
      #       # string=$(3dClusterize -nosum -1Dformat \
      #       # -inset group/ttest_${prefix}_${brick}_${maskdec_t}+tlrc \
      #       # -mask ${mask} \
      #       # -idat "all_mean" -ithr "all_Tstat" \
      #       # -NN 2 -clust_nvox ${nvox} -bisided p=${p})
      #       # masks and save the results
      #       string=$(3dClusterize -nosum -1Dformat \
      #       -inset group/ttest_${prefix}_${brick}_${maskdec_t}+tlrc \
      #       -mask ${mask} \
      #       -idat "all_mean" -ithr "all_Tstat" \
      #       -NN 2 -clust_nvox ${nvox} -bisided p=${p}\
      #       -pref_map group/absmask/${roi}_${brick}_${p}_${maskdec_t})
      #       if [[ $string == *"NO CLUSTERS FOUND"* ]]; then
      #             results=0_${results}
      #       else
      #             results=1_${results}
      #       fi
      # done
      # printf "%s\n" ${results} >> group/${prefix}_results.txt

      # visibility
      name=group/findmask/${out}.NN2_2sided.1D
      nvox=$(sed -n "/^ $p/p" ${name})
      nvox=$(echo ${nvox} | awk '{print $3}')
      3dClusterize -nosum -1Dformat \
            -inset group/consep/ttest_vis_whole+tlrc \
            -mask ${mask} \
            -idat "all_mean" -ithr "all_Tstat" \
            -NN 2 -clust_nvox ${nvox} -2sided p=${p} \
            -pref_map group/absmask/${roi}_visinv_${p}
      # same with 2sided
      # name=group/findmask/${out}.NN2_bisided.1D
      # nvox=$(sed -n "/^ $p/p" ${name})
      # nvox=$(echo ${nvox} | awk '{print $3}')
      # 3dClusterize -nosum -1Dformat \
      #       -inset group/consep/ttest_vis_whole+tlrc \
      #       -mask ${mask} \
      #       -idat "all_mean" -ithr "all_Tstat" \
      #       -NN 2 -clust_nvox ${nvox} -bisided p=${p}
      # name=group/findmask/${out}.NN2_1sided.1D
      # nvox=$(sed -n "/^ $p/p" ${name})
      # nvox=$(echo ${nvox} | awk '{print $3}')
      # 3dClusterize -nosum -1Dformat \
      #       -inset group/consep/ttest_vis_whole+tlrc \
      #       -mask ${mask} \
      #       -idat "all_mean" -ithr "all_Tstat" \
      #       -NN 2 -clust_nvox ${nvox} -1sided LEFT p=${p}
      # 3dClusterize -nosum -1Dformat \
      #       -inset group/consep/ttest_vis_whole+tlrc \
      #       -mask ${mask} \
      #       -idat "all_mean" -ithr "all_Tstat" \
      #       -NN 2 -clust_nvox ${nvox} -1sided RIGHT p=${p}
    done
done
done