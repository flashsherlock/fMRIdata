#!/bin/tcsh

set scriptdir=`pwd`
# for subs from 01 to 04
foreach ub (`count -dig 2 $1 $2`)
set sub=S${ub}
set datafolder=/Volumes/WD_F/gufei/3T_cw/${sub}
# if sub folder not exsist then continue
if (! -e ${datafolder}) then
    echo ${datafolder} not exsist
    continue
endif
cd "${datafolder}"
set analysis=de
echo ${sub} ${analysis}
# cd to the folder
set subj = ${sub}.${analysis}
set subjva = ${subj}
cd ${subj}.results
# ----------------------------------------
# align data to standard space
# foreach data (errts)
#     set name = ${data}.${subj}.new
#     3dNwarpApply -nwarp "anatQQ.${sub}_WARP.nii anatQQ.${sub}.aff12.1D INV(anatSS.${sub}_al_keep_mat.aff12.1D)"   \
#                 -source ${name}+orig                                                 \
#                 -master anatQQ.${sub}+tlrc    \
#                 -prefix ${name}
#     # refit type
#     3drefit -fbuc ${name}+tlrc
# end
# ----------------------------------------
# if folder ppi not exsist then make it
if (! -e ppi) then
    mkdir ppi
endif
cd ppi
# generate seed time series, ppi.seed.1D
set seed = ${subj}.new
# if seed not esist then make it
# if (! -e ppi.seed.$seed.1D) then
    3dmaskave -quiet -mask ${datafolder}/../group/mask/Amy8_align.freesurfer+tlrc ../errts.$seed+tlrc >! ppi.seed.$seed.1D
# endif
# generate ppi regressors
mv ppi.seed.$seed.1D ../
rm *.1D
mv ../ppi.seed.$seed.1D ./
tcsh $scriptdir/make_ppi_regress.tcsh $seed

end
