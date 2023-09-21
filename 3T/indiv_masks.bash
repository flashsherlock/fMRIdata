#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
cd "${datafolder}" || exit
maskdec_t=at165

for ub in $(count -dig 2 ${1} ${2})
do
      sub=S${ub}
      analysis=de
      subj=${sub}.${analysis}
      # for each mask
      for out in Amy Pir fusiformCA FFA_CA insulaCA OFC6mm aSTS_OR FFV_CA
      do
            # check $1, if is whole, use bmask.nii as mask
            if [ ${out} = "Amy" ]; then
                  mask=${sub}/mask/Amy8_align.freesurfer+orig                  
            elif [ ${out} = "Pir" ]; then
                  mask=${sub}/mask/Pir_new.draw+orig
            else
                  mask=${sub}/mask/${out}+orig
            fi
            
            # for each pvalue
            for p in 0.001 #0.05  
            do
                  
                  for sig in any anyvis anyinv
                  do
                        for con in face odor
                        do
                        nvox=2
                        if [ "${sig}" = "any" ]
                        then
                              brick=${con}_GLT#0
                        else
                              brick=${con}_${sig: -3}_GLT#0
                        fi
                        3dClusterize -nosum -1Dformat \
                        -inset ${sub}/${subj}.results/stats.${subj}.new+orig \
                        -mask "3dcalc( -a ${mask} -b ${sub}/threshold/whole_${sig}_${maskdec_t}+orig -expr a*b )"\
                        -idat "${brick}_Coef" -ithr "${brick}_Tstat" \
                        -NN 2 -clust_nvox ${nvox} -bisided p=${p}\
                        -pref_map ${sub}/threshold/Cluster${nvox}_${p}_${con}_${sig}_${out}
                        done
                  done
            done
      done
done