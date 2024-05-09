#!/bin/tcsh
# set sub=S04
if ( $# > 0 ) then
set sub = $1
set analysis=pabiode
# set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_F/gufei/7T_odor/${sub}
set data=/Volumes/WD_F/gufei/7T_odor/${sub}
set datafolder=/Volumes/WD_F/gufei/7T_odor/${sub}
cd "${datafolder}"

# run the regression analysis
set subj = ${sub}.${analysis}
cd ${subj}.results
set pb=`ls pb0?.*.r01.volreg+orig.HEAD | cut -d . -f1`
set filedec = IM

# run the regression analysis
3dDeconvolve -input ${pb}.${subj}.r*.volreg+orig.HEAD          \
    -censor motion_${subj}_censor.1D                           \
    -ortvec mot_demean.r01.1D mot_demean_r01                   \
    -ortvec mot_demean.r02.1D mot_demean_r02                   \
    -ortvec mot_demean.r03.1D mot_demean_r03                   \
    -ortvec mot_demean.r04.1D mot_demean_r04                   \
    -ortvec mot_demean.r05.1D mot_demean_r05                   \
    -ortvec mot_demean.r06.1D mot_demean_r06                   \
    -polort 3                                                  \
    -num_stimts 7                                              \
    -stim_times_IM 1  ${data}/behavior/lim.txt 'BLOCK(2,1)'                 \
    -stim_label 1 lim                                          \
    -stim_times_IM 2  ${data}/behavior/tra.txt 'BLOCK(2,1)'                 \
    -stim_label 2 tra                                          \
    -stim_times_IM 3  ${data}/behavior/car.txt 'BLOCK(2,1)'                 \
    -stim_label 3 car                                          \
    -stim_times_IM 4  ${data}/behavior/cit.txt 'BLOCK(2,1)'                 \
    -stim_label 4 cit                                          \
    -stim_times_IM 5  ${data}/behavior/ind.txt 'BLOCK(2,1)'                 \
    -stim_label 5 ind                                          \
    -stim_times_AM1 6 ${data}/behavior/valence.txt 'dmBLOCK(1)'     \
    -stim_label 6 val                                          \
    -stim_times_AM1 7 ${data}/behavior/intensity.txt 'dmBLOCK(1)'   \
    -stim_label 7 int                                          \
    -jobs 24                                                   \
    -x1D X.xmat.${filedec}.1D -xjpeg X.${filedec}.jpg \
    -bucket stats.${subj}.${filedec}
else
 echo "Usage: $0 <Subjname>"

endif
