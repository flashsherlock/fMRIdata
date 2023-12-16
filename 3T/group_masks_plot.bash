#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit

# if the first input exist and is sm
if [ -n "$1" ] && [ "$1" = "sm" ]; then
      pre="sm_"
else
      pre=""
fi

# searchlight tmap for each roi
for roi in Amy OFC_AAL
do
      # for each pvalue
      for p in 0.001
      do
            for brick in face_vis face_inv odor_all
            do      
                  rm group/plotmask/${pre}${roi}_${brick}_t*
                  3dcalc \
                  -a group/mvpa/${brick}_whole${pre:2}${pre:0:2}4r+tlrc[1] \
                  -b group/mvpa/${pre}${roi}_${brick}_${p}+tlrc \
                  -expr 'bool(b)*a'\
                  -prefix group/plotmask/${pre}${roi}_${brick}_t
            done      
      done
done

p=0.001
# convert to nii
for cluster in Amy_face_vis Amy_face_inv Amy_odor_all OFC_AAL_face_vis OFC_AAL_face_inv OFC_AAL_odor_all
do
      3dcalc \
      -a group/mvpa/${pre}${cluster}_${p}+tlrc \
      -expr 'bool(a)'\
      -prefix group/plotmask/${pre}${cluster}_${p}.nii
done
# 3dcalc \
#       -a group/findmask/Cluster11_0.001_fointer_inv_Amy+tlrc \
#       -expr 'bool(a)'\
#       -prefix group/plotmask/Amy_inter_inv+tlrc.nii
      
# show clusters
# rm group/plotmask/${pre}all_mask*.nii
3dcalc \
      -a group/mvpa/${pre}Amy_face_vis_${p}+tlrc \
      -b group/mvpa/${pre}OFC_AAL_face_vis_${p}+tlrc \
      -c group/mvpa/${pre}Amy_face_inv_${p}+tlrc \
      -d group/mvpa/${pre}OFC_AAL_face_inv_${p}+tlrc \
      -e group/mvpa/${pre}Amy_odor_all_${p}+tlrc \
      -f group/mvpa/${pre}OFC_AAL_odor_all_${p}+tlrc \
      -expr '10*bool(a+b)+5*bool(c+d)+20*bool(e+f)'\
      -prefix group/plotmask/${pre}all_masks.nii

3dcalc \
      -a group/plotmask/${pre}all_masks.nii \
      -b group/findmask/Cluster11_0.001_fointer_inv_Amy+tlrc\
      -expr 'a+60*bool(b)'\
      -prefix group/plotmask/${pre}all_masks_inter.nii
# show the intersection of 3 conditions in Amy and OFC
for roi in Amy OFC_AAL
do
      3dcalc \
            -a group/mvpa/${pre}${roi}_face_vis_${p}+tlrc \
            -b group/mvpa/${pre}${roi}_face_inv_${p}+tlrc \
            -c group/mvpa/${pre}${roi}_odor_all_${p}+tlrc \
            -expr 'bool(a*b*c)'\
            -prefix group/plotmask/${pre}${roi}_inter3.nii
      3dcalc \
            -a group/mvpa/${pre}${roi}_face_vis_${p}+tlrc \
            -b group/mvpa/${pre}${roi}_face_inv_${p}+tlrc \
            -expr 'bool(a*b)'\
            -prefix group/plotmask/${pre}${roi}_visinv.nii
      3dcalc \
            -a group/mvpa/${pre}${roi}_face_vis_${p}+tlrc \
            -b group/mvpa/${pre}${roi}_odor_all_${p}+tlrc \
            -expr 'bool(a*b)'\
            -prefix group/plotmask/${pre}${roi}_visodo.nii
      3dcalc \
            -a group/mvpa/${pre}${roi}_face_inv_${p}+tlrc \
            -b group/mvpa/${pre}${roi}_odor_all_${p}+tlrc \
            -expr 'bool(a*b)'\
            -prefix group/plotmask/${pre}${roi}_invodo.nii
done