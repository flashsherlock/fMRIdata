#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit
# searchlight tmap for each roi
for roi in Amy OFC_AAL
do
      # for each pvalue
      for p in 0.001
      do
            for brick in face_vis face_inv odor_all
            do      
                  3dcalc \
                  -a group/mvpa/${brick}_whole4r+tlrc[1] \
                  -b group/mvpa/${roi}_${brick}_${p}+tlrc \
                  -expr 'bool(a)*b'\
                  -prefix group/plotmask/${roi}_${brick}_t
            done      
      done
done