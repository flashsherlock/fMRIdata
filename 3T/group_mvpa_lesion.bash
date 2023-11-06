#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/

# roi
for roi in Amy OFC_AAL
do
if [ "$roi" = "whole" ]; then
      mask=group/mask/bmask.nii
      out=whole
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
    for brick in face_vis face_inv odor_all
    do              
            cd "${datafolder}" || exit
            # convert to short data first if not exist
            if [ ! -f group/mvpa/lesion/${pre}${roi}_${brick}_t+tlrc.HEAD ]; then
                  3dcalc \
                  -a group/plotmask/${pre}${roi}_${brick}_t+tlrc \
                  -prefix group/mvpa/lesion/${pre}${roi}_${brick}_t \
                  -expr 'a' \
                  -datum short
            fi
            # find maxima in RAI coordinate
            # use -dset_coords to convert to LPI      
            # rm group/mvpa/lesion/${pre}${roi}_${brick}_max*
            # 3dmaxima \
            # -input group/mvpa/lesion/${pre}${roi}_${brick}_t+tlrc \
            # -spheres_1toN -out_rad 4 -prefix group/mvpa/lesion/${pre}${roi}_${brick}_max \
            # -min_dist 8 -thresh 1.65 -coords_only > group/mvpa/lesion/${pre}${roi}_${brick}.txt
            # # find the first two sphere
            # for i in 1 2
            # do
            #       # sphere masks
            #       3dcalc \
            #       -a group/mvpa/lesion/${pre}${roi}_${brick}_max+tlrc \
            #       -expr "equals(a,$i)" \
            #       -prefix group/mvpa/lesion/${pre}${roi}_${brick}_p${i}
            #       # generate mask with out the cluster
            #       # rm group/mvpa/lesion/${pre}${roi}_${brick}_l${i}*
            #       3dcalc \
            #       -a group/mvpa/lesion/${pre}${roi}_${brick}_p${i}+tlrc \
            #       -b group/mvpa/${pre}${roi}_${brick}_${p}+tlrc \
            #       -expr "step(bool(b)-a)" \
            #       -prefix group/mvpa/lesion/${pre}${roi}_${brick}_l${i}
            # done
            # mask without lesion
            if [ ! -f group/mvpa/lesion/${pre}${roi}_${brick}_l0+tlrc.HEAD ]; then
                  3dcalc \
                  -a group/mvpa/${pre}${roi}_${brick}_${p}+tlrc \
                  -expr 'bool(a)'\
                  -prefix group/mvpa/lesion/${pre}${roi}_${brick}_l0
            fi
            # indivisual masks
            for sub in S{03..29}
            do
                  analysis=de
                  subj=${sub}.${analysis}
                  subdir=${sub}/${subj}.results
                  # if subdir not exsist then continue
                  if [ ! -d "${subdir}" ]; then
                        echo "${subdir} not exsist"
                        continue
                  fi
                  # cd to results folder
                  cd "${subdir}" || exit 
                  for m in p1 p2 l1 l2 l0
                  do
                        # define group mask
                        gmask=group/mvpa/lesion/${pre}${roi}_${brick}_${m}+tlrc
                        indmask=${roi}_${brick}_${m}
                        # if mask exsist then remove it
                        # if [ -e "../mask/${indmask}+orig.HEAD" ]; then
                        #       rm ../mask/${indmask}+orig*
                        # fi   
                        # map group level masks to individual space
                        if [ ! -e "../mask/${indmask}+orig.HEAD" ]; then
                              3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D  INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
                                    -source ${datafolder}/${gmask}  -interp NN -ainterp NN                   \
                                    -master vr_base_min_outlier+orig    \
                                    -prefix ../mask/${indmask}
                        fi   
                  done
            done
      done    
done

done