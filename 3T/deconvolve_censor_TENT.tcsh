#!/bin/tcsh
# set sub=S04
if ( $# > 0 ) then
set sub = $1
set analysis=de
set datafolder=/Volumes/WD_F/gufei/3T_cw/${sub}
cd "${datafolder}"

set subj = ${sub}.${analysis}
cd ${subj}.results
set pb=`ls pb0?.*.r01.scale+orig.HEAD | cut -d . -f1`
set filedec = odorfixl_16

# run the regression analysis
3dDeconvolve -input ${pb}.${subj}.r*.scale+orig.HEAD           \
    -censor motion_${subj}_censor.1D                           \
    -ortvec mot_demean.r01.1D mot_demean_r01                   \
    -ortvec mot_demean.r02.1D mot_demean_r02                   \
    -ortvec mot_demean.r03.1D mot_demean_r03                   \
    -ortvec mot_demean.r04.1D mot_demean_r04                   \
    -ortvec mot_demean.r05.1D mot_demean_r05                   \
    -polort 3                                                  \
    -num_stimts 9                                              \
    -stim_times 1 ../behavior/FearPleaVis.txt 'TENT(0,16,9)'          \
    -stim_label 1 FearPleaVis                                          \
    -stim_times 2 ../behavior/FearPleaInv.txt 'TENT(0,16,9)'          \
    -stim_label 2 FearPleaInv                                          \
    -stim_times 3 ../behavior/FearUnpleaVis.txt 'TENT(0,16,9)'          \
    -stim_label 3 FearUnpleaVis                                          \
    -stim_times 4 ../behavior/FearUnpleaInv.txt 'TENT(0,16,9)'          \
    -stim_label 4 FearUnpleaInv                                          \
    -stim_times 5 ../behavior/HappPleaVis.txt 'TENT(0,16,9)'          \
    -stim_label 5 HappPleaVis                                          \
    -stim_times 6 ../behavior/HappPleaInv.txt 'TENT(0,16,9)'          \
    -stim_label 6 HappPleaInv                                          \
    -stim_times 7 ../behavior/HappUnpleaVis.txt 'TENT(0,16,9)'          \
    -stim_label 7 HappUnpleaVis                                          \
    -stim_times 8 ../behavior/HappUnpleaInv.txt 'TENT(0,16,9)'          \
    -stim_label 8 HappUnpleaInv                                          \
    -stim_times 9 ../behavior/fix.txt 'BLOCK(11,1)'      \
    -stim_label 9 fixation                                \
    -jobs 14                                                   \
    -x1D X.xmat.tent.${filedec}.1D                             \
    -xjpeg X.tent.${filedec}.jpg                               \
    -noFDR                                                     \
    -bucket tent.${subj}.${filedec}

else
 echo "Usage: $0 <Subjname>"

endif
