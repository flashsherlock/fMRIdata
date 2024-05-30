#! /bin/bash

# datafolder=/Volumes/WD_D/allsub/
datafolder=/Volumes/WD_F/gufei/3T_cw/
cd "${datafolder}" || exit
# check $1, if is whole, use bmask.nii as mask
if [ "$1" = "whole" ]; then
      mask=group/mask/bmask.nii
      out=whole
elif [ "$1" = "Pir" ]; then
      mask=group/mask/Pir_new.draw+tlrc
      out=Pir
elif [ "$1" = "FFA" ]; then
      mask=group/mask/FFA+tlrc
      out=FFA
elif [ "$1" = "FFA_CA" ]; then
      mask=group/mask/FFA_CA+tlrc
      out=FFA_CA
elif [ "$1" = "fusiform" ]; then
      mask=group/mask/fusiform+tlrc
      out=fusiform
elif [ "$1" = "fusiformCA" ]; then
      mask=group/mask/fusiformCA+tlrc
      out=fusiformCA
elif [ "$1" = "A37mlv" ]; then
      mask=group/mask/A37mlv+tlrc
      out=A37mlv
elif [ "$1" = "A37mv" ]; then
      mask=group/mask/A37mv+tlrc
      out=A37mv
elif [ "$1" = "insulaCA" ]; then
      mask=group/mask/insulaCA+tlrc
      out=insulaCA
elif [ "$1" = "OFC" ]; then
      mask=group/mask/OFC6mm+tlrc
      out=OFC6mm
elif [ "$1" = "FFV" ]; then
      mask=group/mask/FFV+tlrc
      out=FFV
elif [ "$1" = "FFV01" ]; then
      mask=group/mask/FFV01+tlrc
      out=FFV01
elif [ "$1" = "FFV005" ]; then
      mask=group/mask/FFV005+tlrc
      out=FFV005
elif [ "$1" = "aSTS" ]; then
      mask=group/mask/aSTS_OR+tlrc
      out=aSTS_OR
elif [ "$1" = "OFC_AAL" ]; then
      mask=group/mask/OFC_AAL+tlrc
      out=OFC_AAL
elif [ "$1" = "Amy" ]; then
      mask=group/mask/Amy8_align.freesurfer+tlrc
      out=Amy
else
      mask=group/mask/$1+tlrc
      out=$1
fi
# if $2 esists, use it as suffix
if [ -n "$2" ]; then
      suffix=de.$2
      outsuffix=${out}$2
else
      suffix=de
      outsuffix=${out}
fi
# acf parameters
zork=($(3dFWHMx -acf group/3dFWHMx_${outsuffix} -mask ${mask} group/errs.wholenew+tlrc))
# echo the 5-7 elements of $zork
# acf=${echo ${zork} | awk '{print $5,$6,$7}'}
# echo ${zork[4]} ${zork[5]} ${zork[6]}
# cluster simulation
3dClustSim -mask ${mask} -both \
-acf ${zork[4]} ${zork[5]} ${zork[6]} \
-athr 0.10 0.05 0.02 0.01 \
-pthr 0.05 0.01 0.005 0.001 \
-iter 10000 -nodec \
-cmd group/findmask/3dClustSim_${outsuffix}.cmd \
-prefix group/findmask/${outsuffix}

# add anysig mask
# for sig in anyvis any anyinv
# do
# zork=($(3dFWHMx -acf group/3dFWHMx_${outsuffix} -mask "3dcalc( -a ${mask} -b group/mask/whole_${sig}_at165+tlrc -expr a*b )" group/errs.wholenew+tlrc))
# 3dClustSim -mask "3dcalc( -a ${mask} -b group/mask/whole_${sig}_at165+tlrc -expr a*b )" -both \
# -acf ${zork[4]} ${zork[5]} ${zork[6]} \
# -athr 0.10 0.05 0.01 0.001 \
# -pthr 0.05 0.01 0.005 0.001 \
# -iter 10000 -nodec \
# -cmd group/findmask/3dClustSim_${sig}_${outsuffix}.cmd \
# -prefix group/findmask/${outsuffix}_${sig}
# done
# add to header
# $(cat group/3dClustSim_${outsuffix}.cmd) group/ANOVA_results_${outsuffix}+tlrc