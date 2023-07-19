#! /bin/bash

# datafolder=/Volumes/WD_D/allsub/
datafolder=/Volumes/WD_F/gufei/3T_cw/
cd "${datafolder}" || exit
# check $1, if is whole, use bmask.nii as mask
if [ "$1" = "whole" ]; then
      mask=group/mask/bmask.nii
      out=whole
else
      mask=group/mask/Amy8_align.freesurfer+tlrc
      out=Amy
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
zork=($(3dFWHMx -acf group/3dFWHMx_${outsuffix} -mask ${mask} group/errs.${outsuffix}+tlrc))
# echo the 5-7 elements of $zork
# acf=${echo ${zork} | awk '{print $5,$6,$7}'}
echo ${zork[4]} ${zork[5]} ${zork[6]}
# cluster simulation
3dClustSim -mask ${mask} -both \
-acf ${zork[4]} ${zork[5]} ${zork[6]} \
-athr 0.10 0.05 0.02 0.01 \
-pthr 0.05 0.01 0.005 0.001 \
-iter 10000 -nodec \
-cmd group/3dClustSim_${outsuffix}.cmd \
-prefix group/${outsuffix}
# add to header
$(cat group/3dClustSim_${outsuffix}.cmd) group/ANOVA_results_${outsuffix}+tlrc