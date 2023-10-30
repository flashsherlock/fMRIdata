#!/bin/tcsh
# set sub=S01_yyt
if ( $# > 0 ) then
set sub = $1
set analysis=de
set datafolder=/Volumes/WD_F/gufei/3T_cw/${sub}
cd "${datafolder}"

# run the regression analysis
set subj = ${sub}.${analysis}
cd ${subj}.results
set filedec = odors
set pb = `ls pb0?.*.r01.scale+orig.HEAD | cut -d . -f1`
3dDeconvolve -input ${pb}.$subj.r*.scale+orig.HEAD             \
    -censor motion_${subj}_censor.1D                           \
    -ortvec mot_demean.r01.1D mot_demean_r01                   \
    -ortvec mot_demean.r02.1D mot_demean_r02                   \
    -ortvec mot_demean.r03.1D mot_demean_r03                   \
    -ortvec mot_demean.r04.1D mot_demean_r04                   \
    -ortvec mot_demean.r05.1D mot_demean_r05                   \
    -polort 3 -float -jobs 2                                   \
    -num_stimts 1                                              \
    -stim_times 1 ../behavior/odors.txt 'BLOCK(10,1)'        \
    -stim_label 1 odors                                  \
    -fout -tout -x1D X.xmat.${filedec}.1D -xjpeg X.${filedec}.jpg        \
    -x1D_uncensored X.nocensor.xmat.${filedec}.1D                        \
    -bucket stats.$subj.${filedec}

# align data to standard space
set name = stats.$subj.${filedec}
3dNwarpApply -nwarp "anatQQ.${sub}_WARP.nii anatQQ.${sub}.aff12.1D INV(anatSS.${sub}_al_keep_mat.aff12.1D)"   \
            -source ${name}+orig                                                 \
            -master anatQQ.${sub}+tlrc    \
            -prefix ${name}
# refit type
3drefit -fbuc ${name}+tlrc

else
 echo "Usage: $0 <Subjname>"

endif
