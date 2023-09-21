#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw/
cd "${datafolder}" || exit
maskdec_t=at165

for ub in $(count -dig 2 ${1} ${2})
do
      sub=S${ub}
      analysis=de
      subj=${sub}.${analysis}
      # any sig
      3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+orig[2]" \
            -b "${sub}/${subj}.results/stats.${subj}.new+orig[5]" \
            -c "${sub}/${subj}.results/stats.${subj}.new+orig[8]" \
            -d "${sub}/${subj}.results/stats.${subj}.new+orig[11]" \
            -e "${sub}/${subj}.results/stats.${subj}.new+orig[14]" \
            -f "${sub}/${subj}.results/stats.${subj}.new+orig[17]" \
            -g "${sub}/${subj}.results/stats.${subj}.new+orig[20]" \
            -h "${sub}/${subj}.results/stats.${subj}.new+orig[23]" \
            -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65),astep(e,1.65),astep(f,1.65),astep(g,1.65),astep(h,1.65))' \
            -prefix ${sub}/threshold/whole_any_${maskdec_t}
      3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+orig[2]" \
            -b "${sub}/${subj}.results/stats.${subj}.new+orig[8]" \
            -c "${sub}/${subj}.results/stats.${subj}.new+orig[14]" \
            -d "${sub}/${subj}.results/stats.${subj}.new+orig[20]" \
            -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65))' \
            -prefix ${sub}/threshold/whole_anyvis_${maskdec_t}
      3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+orig[5]" \
            -b "${sub}/${subj}.results/stats.${subj}.new+orig[11]" \
            -c "${sub}/${subj}.results/stats.${subj}.new+orig[17]" \
            -d "${sub}/${subj}.results/stats.${subj}.new+orig[23]" \
            -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65))' \
            -prefix ${sub}/threshold/whole_anyinv_${maskdec_t}

      # for each mask
      for mask in Amy Pir fusiformCA FFA_CA insulaCA OFC6mm aSTS_OR FFV_CA
      do
            # check $1, if is whole, use bmask.nii as mask
            if [ ${mask} = "Amy" ]; then
                  mask=${sub}/mask/Amy8_align.freesurfer+orig
                  out=Amy
            elif [ ${mask} = "Pir" ]; then
                  mask=${sub}/mask/Pir_new.draw+orig
                  out=Pir
            else
                  mask=${sub}/mask/${mask}+orig
                  out=${mask}
            fi
            # add anysig mask
            for sig in anyvis any anyinv
            do
            zork=($(3dFWHMx -acf ${sub}/threshold/3dFWHMx_${out}_${sig} -mask "3dcalc( -a ${mask} -b ${sub}/threshold/whole_${sig}_${maskdec_t}+orig -expr a*b )" ${sub}/${subj}.results/errts.${subj}.new+orig))
            3dClustSim -mask "3dcalc( -a ${mask} -b ${sub}/threshold/whole_${sig}_${maskdec_t}+orig -expr a*b )" \
            -acf ${zork[4]} ${zork[5]} ${zork[6]} \
            -athr 0.05 \
            -pthr 0.001 \
            -iter 10000 -nodec \
            -prefix ${sub}/threshold/${out}_${sig}
            done
      done
done