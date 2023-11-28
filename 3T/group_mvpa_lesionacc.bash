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

# indivisual masks from searchlight
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
      gvox=$(3dROIstats -nzvoxels -mask "${datafolder}/${mask}" "${datafolder}/${mask}" | tail -n 1 | awk '{print $NF}')
      ivox=$(3dROIstats -nzvoxels -mask "${imask}" "${imask}" | tail -n 1 | awk '{print $NF}')
      
      for brick in face_vis face_inv odor_all
      do
            sigvox=$(3dROIstats -nzvoxels -mask "${datafolder}/group/plotmask/sm_${roi}_${brick}_0.001.nii" "${datafolder}/group/plotmask/sm_${roi}_${brick}_0.001.nii" | tail -n 1 | awk '{print $NF}')
            # echo $sigvox $ivox $gvox
            # calculate and floor sigvox*ivox/gvox
            vox=$(echo "scale=0; $sigvox*$ivox/$gvox" | bc)
            echo $vox
            indmask=${roi}_${brick}_p1_interacc
            # rm ../mask/${indmask}+orig*
            if [ ! -f ../mask/${indmask}_GM+orig.HEAD ]; then
                  3dROIMaker                     \
                  -inset mvpa/searchlight_${brick:0:4}_shift6/${brick: -3}_epi_anat/res_accuracy_minus_chance+orig \
                  -thresh 0                 \
                  -prefix ../mask/${indmask}  \
                  -only_some_top ${vox}                \
                  -inflate 2                  \
                  -mask "${imask}"              \
                  -dump_no_labtab                  
            fi
            if [ ! -f ../mask/${indmask}+orig.HEAD ]; then
                  3dcalc                     \
                  -a ../mask/${indmask}_GM+orig \
                  -expr "bool(a)" \
                  -prefix ../mask/${indmask}            
            fi
            indmask=${roi}_${brick}_l1_interacc
            # rm ../mask/${indmask}+orig*
            if [ ! -f ../mask/${indmask}+orig.HEAD ]; then
                  3dcalc \
                  -a ../mask/${roi}_${brick}_p1_interacc_GM+orig \
                  -b ../mask/${imask} \
                  -expr "b-bool(a)" \
                  -prefix ../mask/${indmask}
            fi       
            # ensure connectivity     
            indmask=${roi}_${brick}_p2_interacc
            # rm ../mask/${indmask}+orig*
            if [ ! -f ../mask/${indmask}_GM+orig.HEAD ]; then
                  3dROIMaker                     \
                  -inset mvpa/searchlight_${brick:0:4}_shift6/${brick: -3}_epi_anat/res_accuracy_minus_chance+orig \
                  -thresh 0                 \
                  -prefix ../mask/${indmask}  \
                  -only_conn_top ${vox}                \
                  -inflate 2                  \
                  -mask "${imask}"              \
                  -dump_no_labtab                  
            fi
            if [ ! -f ../mask/${indmask}+orig.HEAD ]; then
                  3dcalc                     \
                  -a ../mask/${indmask}_GM+orig \
                  -expr "bool(a)" \
                  -prefix ../mask/${indmask}            
            fi
            indmask=${roi}_${brick}_l2_interacc
            # rm ../mask/${indmask}+orig*
            if [ ! -f ../mask/${indmask}+orig.HEAD ]; then
                  3dcalc \
                  -a ../mask/${roi}_${brick}_p2_interacc_GM+orig \
                  -b ../mask/${imask} \
                  -expr "b-bool(a)" \
                  -prefix ../mask/${indmask}
            fi            
      done
done

done