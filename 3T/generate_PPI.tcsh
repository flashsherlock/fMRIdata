#!/bin/tcsh

# for subs from 01 to 04
foreach ub (`count -dig 2 $2 $3`)
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

# align data to standard space
foreach data ($1)
    set name = ${data}.${subj}.new
    3dNwarpApply -nwarp "anatQQ.${sub}_WARP.nii anatQQ.${sub}.aff12.1D INV(anatSS.${sub}_al_keep_mat.aff12.1D)"   \
                -source ${name}+orig                                                 \
                -master anatQQ.${sub}+tlrc    \
                -prefix ${name}
    # refit type
    3drefit -fbuc ${name}+tlrc
end

end
