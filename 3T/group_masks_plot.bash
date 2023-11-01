#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
# searchlight tmap for each roi
# for roi in Amy OFC_AAL
# do
#       # for each pvalue
#       for p in 0.001
#       do
#             for brick in face_vis face_inv odor_all
#             do      
#                   3dcalc \
#                   -a group/mvpa/${brick}_whole4r+tlrc[1] \
#                   -b group/mvpa/${roi}_${brick}_${p}+tlrc \
#                   -expr 'bool(a)*b'\
#                   -prefix group/plotmask/${roi}_${brick}_t
#             done      
#       done
# done

p=0.001
# convert to nii
# for cluster in Amy_face_vis Amy_face_inv Amy_odor_all OFC_AAL_face_vis OFC_AAL_face_inv OFC_AAL_odor_all
# do
#       3dcalc \
#       -a group/mvpa/${cluster}_${p}+tlrc \
#       -expr 'bool(a)'\
#       -prefix group/plotmask/${cluster}_${p}.nii
# done
# 3dcalc \
#       -a group/findmask/Cluster11_0.001_fointer_inv_Amy+tlrc \
#       -expr 'bool(a)'\
#       -prefix group/plotmask/Amy_inter_inv+tlrc.nii
      
# show clusters
rm group/plotmask/all_mask*.nii
3dcalc \
      -a group/mvpa/Amy_face_vis_${p}+tlrc \
      -b group/mvpa/OFC_AAL_face_vis_${p}+tlrc \
      -c group/mvpa/Amy_face_inv_${p}+tlrc \
      -d group/mvpa/OFC_AAL_face_inv_${p}+tlrc \
      -e group/mvpa/Amy_odor_all_${p}+tlrc \
      -f group/mvpa/OFC_AAL_odor_all_${p}+tlrc \
      -expr '10*bool(a+b)+5*bool(c+d)+20*bool(e+f)'\
      -prefix group/plotmask/all_masks.nii

3dcalc \
      -a group/plotmask/all_masks.nii \
      -b group/findmask/Cluster11_0.001_fointer_inv_Amy+tlrc\
      -expr 'a+60*bool(b)'\
      -prefix group/plotmask/all_masks_inter.nii