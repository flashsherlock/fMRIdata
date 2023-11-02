#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
# roi
for roi in Amy OFC_AAL #FFV01 aSTS Pir 
do
if [ "$roi" = "whole" ]; then
      mask=group/mask/bmask.nii
      out=whole
elif [ "$roi" = "Pir" ]; then
      mask=group/mask/Pir_new.draw+tlrc
      out=Pir
elif [ "$roi" = "OFC" ]; then
      mask=group/mask/OFC6mm+tlrc
      out=OFC6mm
elif [ "$roi" = "aSTS" ]; then
      mask=group/mask/aSTS_OR+tlrc
      out=aSTS_OR
elif [ "$roi" = "OFC_AAL" ]; then
      mask=group/mask/OFC_AAL+tlrc
      out=OFC_AAL
elif [ "$roi" = "Amy" ]; then
      mask=group/mask/Amy8_align.freesurfer+tlrc
      out=Amy
else
      mask=group/mask/$roi+tlrc
      out=$roi
fi

# if the first input exist and is sm
if [ -n "$1" ] && [ "$1" = "sm" ]; then
      pre="sm_"
else
      pre=""
fi

# for each pvalue
for p in 0.001 #0.05  
do
#     name=group/mvpa/threshold/${out}.NN2_bisided.1D
#     # get the last line of the file
# #     nvox=$(tail -n 3 ${name})
#     # get the line related to voxel pvalue
#     nvox=$(sed -n "/^ $p/p" ${name})
# #     echo $nvox
#     # get the third field p=0.05 of nvox by awk
#     nvox=$(echo ${nvox} | awk '{print $3}')
#     echo $nvox
    for brick in face_all face_vis face_inv odor_all
    do        

      name=group/mvpa/threshold/${pre}${out}_${brick}.NN2_bisided.1D
      nvox=$(sed -n "/^ $p/p" ${name})
      nvox=$(echo ${nvox} | awk '{print $3}')
      # rm group/mvpa/${roi}_${brick}_${p}*
        3dClusterize -nosum -1Dformat \
        -inset group/mvpa/${brick}_whole${pre:2}${pre:0:2}4r+tlrc \
        -mask ${mask} \
        -idat 0 -ithr 1 \
        -NN 2 -clust_nvox ${nvox} -bisided p=${p}\
        -pref_map group/mvpa/${pre}${roi}_${brick}_${p}
      # Amy only
      # # rm group/mvpa/${roi}3r_${brick}_${p}*
      #   3dClusterize -nosum -1Dformat \
      #   -inset group/mvpa/${brick}+tlrc \
      #   -mask ${mask} \
      #   -idat 0 -ithr 1 \
      #   -NN 2 -clust_nvox ${nvox} -bisided p=${p}\
      #   -pref_map group/mvpa/${roi}3r_${brick}_${p}
    done
    
done

done