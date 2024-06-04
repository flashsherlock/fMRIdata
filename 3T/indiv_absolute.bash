#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw/
cd "${datafolder}" || exit
# p=0.001 t=3.3011
# p=0.01 t=2.5812
# p=0.05 t=1.9625
# p=0.1 t=1.6465
for maskdec_t in 1.9625 1.6465
do
# for each sub
for ub in $(count -dig 2 ${1} ${2})
do
      sub=S${ub}
      analysis=de
      subj=${sub}.${analysis}
      # absolute value of betas
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[34]" \
      #       -expr 'abs(a)' \
      #       -prefix ${sub}/${subj}.results/absolute_faceall
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[37]" \
      #       -expr 'abs(a)' \
      #       -prefix ${sub}/${subj}.results/absolute_facevis
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[40]" \
      #       -expr 'abs(a)' \
      #       -prefix ${sub}/${subj}.results/absolute_faceinv
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[43]" \
      #       -expr 'abs(a)' \
      #       -prefix ${sub}/${subj}.results/absolute_odorall
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[46]" \
      #       -expr 'abs(a)' \
      #       -prefix ${sub}/${subj}.results/absolute_odorvis
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[49]" \
      #       -expr 'abs(a)' \
      #       -prefix ${sub}/${subj}.results/absolute_odorinv
      # # sig map for absolute value
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[35]" \
      #       -expr "astep(a,${maskdec_t})" \
      #       -prefix ${sub}/mask/absmap_faceall_${maskdec_t}
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[38]" \
      #       -expr "astep(a,${maskdec_t})" \
      #       -prefix ${sub}/mask/absmap_facevis_${maskdec_t}
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[41]" \
      #       -expr "astep(a,${maskdec_t})" \
      #       -prefix ${sub}/mask/absmap_faceinv_${maskdec_t}
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[44]" \
      #       -expr "astep(a,${maskdec_t})" \
      #       -prefix ${sub}/mask/absmap_odorall_${maskdec_t}
      3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[47]" \
            -expr "astep(a,${maskdec_t})" \
            -prefix ${sub}/mask/absmap_odorvis_${maskdec_t}
      3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[50]" \
            -expr "astep(a,${maskdec_t})" \
            -prefix ${sub}/mask/absmap_odorinv_${maskdec_t}
      # rm ${sub}/${subj}.results/absweight_*[lsv]+tlrc*
      # rm ${sub}/${subj}.results/absweight_*_${maskdec_t}+tlrc*
      # sig map weighted absolute value
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[34]" \
      #       -b ${sub}/mask/absmap_faceall_${maskdec_t}+tlrc \
      #       -expr 'abs(a)*notzero(b)-a*iszero(b)' \
      #       -prefix ${sub}/${subj}.results/absweight_faceall_${maskdec_t}
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[37]" \
      #       -b ${sub}/mask/absmap_facevis_${maskdec_t}+tlrc \
      #       -expr 'abs(a)*notzero(b)-a*iszero(b)' \
      #       -prefix ${sub}/${subj}.results/absweight_facevis_${maskdec_t}
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[40]" \
      #       -b ${sub}/mask/absmap_faceinv_${maskdec_t}+tlrc \
      #       -expr 'abs(a)*notzero(b)-a*iszero(b)' \
      #       -prefix ${sub}/${subj}.results/absweight_faceinv_${maskdec_t}
      # 3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[43]" \
      #       -b ${sub}/mask/absmap_odorall_${maskdec_t}+tlrc \
      #       -expr 'abs(a)*notzero(b)-a*iszero(b)' \
      #       -prefix ${sub}/${subj}.results/absweight_odorall_${maskdec_t}
      3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[46]" \
            -b ${sub}/mask/absmap_odorvis_${maskdec_t}+tlrc \
            -expr 'abs(a)*notzero(b)-a*iszero(b)' \
            -prefix ${sub}/${subj}.results/absweight_odorvis_${maskdec_t}
      3dcalc  -a "${sub}/${subj}.results/stats.${subj}.new+tlrc[49]" \
            -b ${sub}/mask/absmap_odorinv_${maskdec_t}+tlrc \
            -expr 'abs(a)*notzero(b)-a*iszero(b)' \
            -prefix ${sub}/${subj}.results/absweight_odorinv_${maskdec_t}
done
done