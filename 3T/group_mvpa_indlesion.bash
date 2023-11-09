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

for p in 0.001 #0.05  
do
    for brick in face_vis face_inv odor_all
    do              
            # group level masks
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
            3dmaxima \
            -input group/mvpa/lesion/${pre}${roi}_${brick}_t+tlrc \
            -min_dist 16 -thresh 1.65 -coords_only | head -2 > group/mvpa/lesion/${pre}${roi}_${brick}.1d
            
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
                  rm -r ../mask/lesion8mm
                  # create individual masks                  
                  # warp coord to orig space                  
                  cords=$(3dNwarpXYZ -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D  INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
                                    -iwarp ${datafolder}/group/mvpa/lesion/${pre}${roi}_${brick}.1d)
                  # echo the elements of cords
                  x1=$(echo $cords | awk '{print $1}')
                  y1=$(echo $cords | awk '{print $2}')
                  z1=$(echo $cords | awk '{print $3}')
                  x2=$(echo $cords | awk '{print $4}')
                  y2=$(echo $cords | awk '{print $5}')
                  z2=$(echo $cords | awk '{print $6}')
                  # echo "${x1} ${y1} ${z1} ${x2} ${y2} ${z2}"
                  # printf "%s %s %s\n%s %s %s\n" "${x1}" "${y1}" "${z1}" "${x2}" "${y2}" "${z2}"

                  # for each rad
                  for rad in 8 10
                  do
                        # calculate rad*rad
                        rad2=$(echo "$rad*$rad" | bc)
                        # draw spheres                  
                        # remove old data
                        # rm ../mask/${roi}_${brick}_*ind${rad}+orig*
                        
                        # check if the first charactor of the variable is - or not
                        # if true then change - to +
                        # if not the add - to the front
                        for i in x1 y1 z1 x2 y2 z2
                        do
                              if [ "${!i:0:1}" = "-" ]; then
                                    eval "${i}=+${!i:1}"
                              else
                                    eval "${i}=-${!i}"
                              fi
                        done
                        echo "${x1} ${y1} ${z1} ${x2} ${y2} ${z2}"
                        
                        indmask=${roi}_${brick}_p1_ind${rad}
                        # if file not exist
                        if [ ! -f ../mask/${indmask}+orig.HEAD ]; then
                              3dcalc \
                              -a "${imask}" \
                              -expr "step(${rad2}-(x${x1})*(x${x1})-(y${y1})*(y${y1})-(z${z1})*(z${z1}))" \
                              -prefix ../mask/${indmask}
                        fi
                        # the seconde sphere
                        indmask=${roi}_${brick}_p2_ind${rad}
                        if [ ! -f ../mask/${indmask}+orig.HEAD ]; then
                              3dcalc \
                              -a "${imask}" \
                              -expr "step(${rad2}-(x${x2})*(x${x2})-(y${y2})*(y${y2})-(z${z2})*(z${z2}))" \
                              -prefix ../mask/${indmask}
                        fi
                        # the lesion mask
                        indmask=${roi}_${brick}_l1_ind${rad}
                        if [ ! -f ../mask/${indmask}+orig.HEAD ]; then
                              3dcalc \
                              -a "${imask}" \
                              -b ../mask/${roi}_${brick}_p1_ind${rad}+orig \
                              -expr "step(a-b)" \
                              -prefix ../mask/${indmask}
                        fi
                        # the lesion mask
                        indmask=${roi}_${brick}_l2_ind${rad}
                        if [ ! -f ../mask/${indmask}+orig.HEAD ]; then
                              3dcalc \
                              -a "${imask}" \
                              -b ../mask/${roi}_${brick}_p2_ind${rad}+orig \
                              -expr "step(a-b)" \
                              -prefix ../mask/${indmask}
                        fi
                  done
            done
      done    
done

done