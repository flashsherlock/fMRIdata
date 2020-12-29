#!/bin/tcsh
set sub=S01_yyt
set analysis=pade

set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

# run the regression analysis
set subj = ${sub}.${analysis}
cd ${subj}.results
set filedec = VI
3dDeconvolve -input pb06.$subj.r*.scale+orig.HEAD              \
    -ortvec mot_demean.r01.1D mot_demean_r01                   \
    -ortvec mot_demean.r02.1D mot_demean_r02                   \
    -ortvec mot_demean.r03.1D mot_demean_r03                   \
    -ortvec mot_demean.r04.1D mot_demean_r04                   \
    -ortvec mot_demean.r05.1D mot_demean_r05                   \
    -ortvec mot_demean.r06.1D mot_demean_r06                   \
    -polort 3                                                  \
    -num_stimts 2                                              \
    -stim_times_AM1 1 ../behavior/valence.txt 'dmBLOCK(1)'                 \
    -stim_label 1 val                                          \
    -stim_times_AM1 2 ../behavior/intensity.txt 'dmBLOCK(1)'                 \
    -stim_label 2 int                                          \
    -jobs 12                                                   \
    -fout -tout -x1D X.xmat.${filedec}.1D -xjpeg X.${filedec}.jpg                    \
    -fitts fitts.$subj.${filedec}                                         \
    -errts errts.${subj}.${filedec}                                       \
    -bucket stats.$subj.${filedec}
