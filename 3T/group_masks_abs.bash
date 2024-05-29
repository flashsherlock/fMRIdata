#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
# open new file
printf "odorall faceinv facevis faceall\n" > group/absweight_results.txt
# for each maskdec_t
for maskdec_t in 3.3011 2.5812 1.9625 1.6465
do
# for each pvalue
for p in 0.001 0.005 0.01 0.05
do
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
      name=group/findmask/${out}.NN2_bisided.1D
      nvox=$(sed -n "/^ $p/p" ${name})
      nvox=$(echo ${nvox} | awk '{print $3}')
      #     echo ${nvox}
      #     nvox=10
      results=${roi}_${p}_${maskdec_t}
      #     for brick in face face_vis face_inv odor
      for brick in faceall facevis faceinv odorall
      do
            #   3dClusterize -nosum -1Dformat \
            #   -inset group/ANOVA_results_wholenew+tlrc \
            #   -mask ${mask} \
            #   -idat "${brick}" -ithr "${brick} t" \
            #   -NN 2 -clust_nvox ${nvox} -bisided p=${p}
            string=$(3dClusterize -nosum -1Dformat \
            -inset group/ttest_absweight_${brick}_${maskdec_t}+tlrc \
            -mask ${mask} \
            -idat "all_mean" -ithr "all_Tstat" \
            -NN 2 -clust_nvox ${nvox} -bisided p=${p})
            if [[ $string == *"NO CLUSTERS FOUND"* ]]; then
                  results=0_${results}
            else
                  results=1_${results}
            fi
      done
      printf "%s\n" ${results} >> group/absweight_results.txt
    done
done
done