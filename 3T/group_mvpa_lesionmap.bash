#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/

# roi
for roi in Amy OFC_AAL
do
if [ "$roi" = "OFC_AAL" ]; then
      mask=group/mask/OFC_AAL+tlrc
      imask=../mask/OFC_AAL+orig
elif [ "$roi" = "Amy" ]; then
      mask=group/mask/Amy8_align.freesurfer+tlrc
      imask=../mask/Amy8_align.freesurfer+orig
else
      mask=group/mask/$roi+tlrc
      imask=../mask/$roi+orig
fi

# if the first input exist and is sm
if [ -n "$3" ] && [ "$3" = "sm" ]; then
      pre="sm_"
else
      pre=""
fi

# for each rad
for rad in 8 10 12 14 16
do
      dia=$(echo "$rad*2" | bc)
      orad=${rad}mm
      for p in 0.001 #0.05  
      do
      for brick in face_vis face_inv odor_all
      do              
                  
                  # group level masks
                  cd "${datafolder}" || exit                            
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
                  # if data not exist
                  if [ ! -f group/mvpa/lesion/${pre}${roi}_${brick}_max${orad}+tlrc.HEAD ]; then
                        3dmaxima \
                        -input group/mvpa/lesion/${pre}${roi}_${brick}_t+tlrc \
                        -spheres_1toN -out_rad ${rad} -prefix group/mvpa/lesion/${pre}${roi}_${brick}_max${orad} \
                        -min_dist ${dia} -thresh 1.65 -coords_only
                  fi
                  # find the first two sphere
                  for i in 1 2
                  do
                        # sphere masks
                        # rm group/mvpa/lesion/${pre}${roi}_${brick}_p${i}*
                        # if data not exist
                        if [ ! -f group/mvpa/lesion/${pre}${roi}_${brick}_p${i}_${orad}+tlrc.HEAD ]; then
                              3dcalc \
                              -a group/mvpa/lesion/${pre}${roi}_${brick}_max${orad}+tlrc \
                              -expr "equals(a,$i)" \
                              -prefix group/mvpa/lesion/${pre}${roi}_${brick}_p${i}_${orad}
                        fi                        
                  done
                  # indivisual masks
                  for ub in $(count -dig 2 "$1" "$2")            
                  # for ub in {03..29}
                  do
                        sub=S${ub}
                        analysis=de
                        subj=${sub}.${analysis}
                        subdir=${sub}/${subj}.results
                        # if subdir not exsist then continue
                        if [ ! -d "${datafolder}/${subdir}" ]; then
                              echo "${datafolder}/${subdir} not exsist"
                              continue
                        fi
                        # cd to results folder
                        cd "${datafolder}/${subdir}" || exit 
                        rm ../mask/${roi}_${brick}_*ind${rad}+orig*
                        # create individual masks
                        for m in p1 p2
                        do
                              # define group mask
                              gmask=group/mvpa/lesion/${pre}${roi}_${brick}_${m}_${orad}+tlrc
                              indmask=${roi}_${brick}_${m}_map${rad}
                              # if mask exsist then remove it
                              if [ -e "../mask/${indmask}+orig.HEAD" ]; then                        
                                    rm ../mask/${indmask}+orig*
                              fi   
                              # map group level masks to individual space
                              if [ ! -e "../mask/${indmask}+orig.HEAD" ]; then
                                    3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D  INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
                                          -source ${datafolder}/${gmask}  -interp NN -ainterp NN                   \
                                          -master vr_base_min_outlier+orig    \
                                          -prefix ../mask/${indmask}
                              fi   
                              
                        done
                        # calculate intersection p1
                        rm ../mask/${roi}_${brick}_*inter${rad}+orig*
                        indmask=${roi}_${brick}_p1_inter${rad}
                        # if file not exist
                        if [ ! -f ../mask/${indmask}+orig.HEAD ]; then
                              3dcalc \
                              -a "${imask}" \
                              -b "../mask/${roi}_${brick}_p1_map${rad}+orig" \
                              -expr "a*b" \
                              -prefix ../mask/${indmask}
                        fi
                        # calculate intersection p2
                        indmask=${roi}_${brick}_p2_inter${rad}
                        # if file not exist
                        if [ ! -f ../mask/${indmask}+orig.HEAD ]; then
                              3dcalc \
                              -a "${imask}" \
                              -b "../mask/${roi}_${brick}_p2_map${rad}+orig" \
                              -expr "a*b" \
                              -prefix ../mask/${indmask}
                        fi            
                  done

            done    
      done

      done
done