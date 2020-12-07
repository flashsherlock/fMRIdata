#!/bin/tcsh
set sub=S01_yyt
set analysis=pade

set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

# run the regression analysis
set subj = ${sub}.${analysis}
cd ${subj}.results
set filedec = IM
3dDeconvolve -input pb07.$subj.r*.scale+orig.HEAD              \
    -ortvec mot_demean.r01.1D mot_demean_r01                   \
    -ortvec mot_demean.r02.1D mot_demean_r02                   \
    -ortvec mot_demean.r03.1D mot_demean_r03                   \
    -ortvec mot_demean.r04.1D mot_demean_r04                   \
    -ortvec mot_demean.r05.1D mot_demean_r05                   \
    -ortvec mot_demean.r06.1D mot_demean_r06                   \
    -polort 3                                                  \
    -num_stimts 4                                              \
    -stim_times_IM 1 stimuli/lim.txt 'BLOCK(2,1)'                 \
    -stim_label 1 lim                                          \
    -stim_times_IM 2 stimuli/tra.txt 'BLOCK(2,1)'                 \
    -stim_label 2 tra                                          \
    -stim_times_IM 3 stimuli/car.txt 'BLOCK(2,1)'                 \
    -stim_label 3 car                                          \
    -stim_times_IM 4 stimuli/cit.txt 'BLOCK(2,1)'                 \
    -stim_label 4 cit                                          \
    -jobs 12                                                   \
    -fout -tout -x1D X.xmat.${filedec}.1D -xjpeg X.${filedec}.jpg                    \
    -fitts fitts.$subj.${filedec}                                         \
    -errts errts.${subj}.${filedec}                                       \
    -bucket stats.$subj.${filedec}
