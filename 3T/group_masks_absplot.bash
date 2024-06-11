#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit

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
                  for brick in facevis faceinv odorall
                  do
                  # t map
                  rm group/absplot/${roi}_${brick}_t*
                  3dcalc \
                  -a group/ttest_absweight0_${brick}_${maskdec_t}+tlrc[1] \
                  -b group/absmask/${roi}_${brick}_${p}_${maskdec_t}+tlrc \
                  -expr 'bool(b)*a'\
                  -prefix group/absplot/${roi}_${brick}_t
                  # 01 mask
                  rm group/absplot/${roi}_${brick}_mask*
                  3dcalc \
                  -a group/absmask/${roi}_${brick}_${p}_${maskdec_t}+tlrc \
                  -expr 'bool(a)'\
                  -prefix group/absplot/${roi}_${brick}_mask
                  # prob map
                  rm group/absplot/${roi}_${brick}_prob*
                  3dcalc \
                  -a group/absmapb_${brick}_${maskdec_t}+tlrc \
                  -b ${mask} \
                  -expr 'a*b'\
                  -prefix group/absplot/${roi}_${brick}_prob
                  done
            done      
      done
done