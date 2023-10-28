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
elif [ "$1" = "OFC" ]; then
      mask=group/mask/OFC6mm+tlrc
      out=OFC6mm
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

# if $2 esists and is sm
if [ -n "$2" ] && [ "$2" = "sm" ]; then
      # for each condition
      for brick in face_all face_vis face_inv odor_all
      do
            outsuffix=sm_${out}_${brick}
            # acf parameters
            zork=($(3dFWHMx -acf group/mvpa/threshold/3dFWHMx_${outsuffix} -mask ${mask} group/mvpa/errs_${brick}_whole_sm4r+tlrc))
            # cluster simulation
            3dClustSim -mask ${mask} -both \
            -acf ${zork[4]} ${zork[5]} ${zork[6]} \
            -athr 0.10 0.05 0.02 0.01 \
            -pthr 0.05 0.01 0.005 0.001 \
            -iter 10000 -nodec \
            -cmd group/mvpa/threshold/3dClustSim_${outsuffix}.cmd \
            -prefix group/mvpa/threshold/${outsuffix}
      done
else
      # for each condition
      for brick in face_all face_vis face_inv odor_all
      do
            outsuffix=${out}_${brick}
            # acf parameters
            zork=($(3dFWHMx -acf group/mvpa/threshold/3dFWHMx_${outsuffix} -mask ${mask} group/mvpa/errs_${brick}_whole4r+tlrc))
            # cluster simulation
            3dClustSim -mask ${mask} -both \
            -acf ${zork[4]} ${zork[5]} ${zork[6]} \
            -athr 0.10 0.05 0.02 0.01 \
            -pthr 0.05 0.01 0.005 0.001 \
            -iter 10000 -nodec \
            -cmd group/mvpa/threshold/3dClustSim_${outsuffix}.cmd \
            -prefix group/mvpa/threshold/${outsuffix}
      done
fi