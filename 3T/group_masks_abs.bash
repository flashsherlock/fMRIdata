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
    for roi in OFC_AAL Amy fusiformCA #FFV01
    do
      if [ "$roi" = "fusiformCA" ]; then
            mask=group/mask/fusiformCA+tlrc
            out=fusiformCA
      elif [ "$roi" = "OFC_AAL" ]; then
            mask=group/mask/OFC_AAL+tlrc
            out=OFC_AAL
      elif [ "$roi" = "FFV" ]; then
            mask=group/mask/FFV+tlrc
            out=FFV
      elif [ "$roi" = "FFV01" ]; then
            mask=group/mask/FFV01+tlrc
            out=FFV01
      elif [ "$roi" = "FFV005" ]; then
            mask=group/mask/FFV005+tlrc
            out=FFV005
      elif [ "$roi" = "FFA_CA" ]; then
            mask=group/mask/FFA_CA+tlrc
            out=FFA_CA
      elif [ "$roi" = "FFA" ]; then
            mask=group/mask/FFA+tlrc
            out=FFA
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
      # for brick in face face_vis face_inv odor
      for brick in faceall facevis faceinv odorall #odorvis odorinv
      do
            # string=$(3dClusterize -nosum -1Dformat \
            #   -inset group/ANOVA_results_wholenew+tlrc \
            #   -mask ${mask} \
            #   -idat "${brick}" -ithr "${brick} t" \
            #   -NN 2 -clust_nvox ${nvox} -bisided p=${p})
            # string=$(3dClusterize -nosum -1Dformat \
            # -inset group/ttest_${prefix}_${brick}_${maskdec_t}+tlrc \
            # -mask ${mask} \
            # -idat "all_mean" -ithr "all_Tstat" \
            # -NN 2 -clust_nvox ${nvox} -bisided p=${p})
            # masks and save the results
            string=$(3dClusterize -nosum -1Dformat \
            -inset group/ttest_${prefix}_${brick}_${maskdec_t}+tlrc \
            -mask ${mask} \
            -idat "all_mean" -ithr "all_Tstat" \
            -NN 2 -clust_nvox ${nvox} -bisided p=${p}\
            -pref_map group/absmask/${roi}_${brick}_${p}_${maskdec_t})
            if [[ $string == *"NO CLUSTERS FOUND"* ]]; then
                  results=0_${results}
            else
                  results=1_${results}
            fi
      done
      printf "%s\n" ${results} >> group/${prefix}_results.txt
    done
done
done