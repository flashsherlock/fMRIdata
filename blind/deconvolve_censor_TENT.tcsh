#!/bin/tcsh
# set sub=S04
if ( $# > 0 ) then
set sub = $1
set analysis=pade
set datafolder=/Volumes/WD_F/gufei/blind/${sub}
cd "${datafolder}"

set subj = ${sub}.${analysis}
cd ${subj}.results
set pb=`ls pb0?.*.r01.scale+orig.HEAD | cut -d . -f1`
set filedec = odor_12

# run the regression analysis
3dDeconvolve -input ${pb}.${subj}.r*.scale+orig.HEAD           \
    -censor motion_${subj}_censor.1D                           \
    -ortvec mot_demean.r01.1D mot_demean_r01                   \
    -ortvec mot_demean.r02.1D mot_demean_r02                   \
    -ortvec mot_demean.r03.1D mot_demean_r03                   \
    -ortvec mot_demean.r04.1D mot_demean_r04                   \
    -ortvec mot_demean.r05.1D mot_demean_r05                   \
    -ortvec mot_demean.r06.1D mot_demean_r06                   \
    -polort 3                                                  \
    -num_stimts 8                                              \
    -stim_times 1 ../behavior/gas.txt 'TENT(0,12,13)'          \
    -stim_label 1 gas                                          \
    -stim_times 2 ../behavior/ind.txt 'TENT(0,12,13)'          \
    -stim_label 2 ind                                          \
    -stim_times 3 ../behavior/ros.txt 'TENT(0,12,13)'          \
    -stim_label 3 ros                                          \
    -stim_times 4 ../behavior/pin.txt 'TENT(0,12,13)'          \
    -stim_label 4 pin                                          \
    -stim_times 5 ../behavior/app.txt 'TENT(0,12,13)'          \
    -stim_label 5 app                                          \
    -stim_times 6 ../behavior/min.txt 'TENT(0,12,13)'          \
    -stim_label 6 min                                          \
    -stim_times 7 ../behavior/fru.txt 'TENT(0,12,13)'          \
    -stim_label 7 fru                                          \
    -stim_times 8 ../behavior/flo.txt 'TENT(0,12,13)'          \
    -stim_label 8 flo                                          \
    -jobs 12                                                   \
    -x1D X.xmat.tent.${filedec}.1D                             \
    -xjpeg X.tent.${filedec}.jpg                               \
    -noFDR                                                     \
    -bucket tent.${subj}.${filedec}

else
 echo "Usage: $0 <Subjname>"

endif
