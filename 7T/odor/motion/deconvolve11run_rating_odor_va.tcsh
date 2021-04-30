#!/bin/tcsh
# set sub=S01_yyt
# use input as sub
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

set pb=pb03
set analysis=pabio12run

echo ${sub} ${analysis}

# run the regression analysis
set subj = ${sub}.${analysis}
cd ${subj}.results
set filedec = odorVIva11run
3dDeconvolve -input ${pb}.${subj}.r{01,02,03,04,05,06,07,08,09,10,12}.scale+orig.HEAD              \
    -ortvec ../behavior_11run/mot_demean.r01.1D mot_demean_r01                   \
    -ortvec ../behavior_11run/mot_demean.r02.1D mot_demean_r02                   \
    -ortvec ../behavior_11run/mot_demean.r03.1D mot_demean_r03                   \
    -ortvec ../behavior_11run/mot_demean.r04.1D mot_demean_r04                   \
    -ortvec ../behavior_11run/mot_demean.r05.1D mot_demean_r05                   \
    -ortvec ../behavior_11run/mot_demean.r06.1D mot_demean_r06                   \
    -ortvec ../behavior_11run/mot_demean.r07.1D mot_demean_r07                   \
    -ortvec ../behavior_11run/mot_demean.r08.1D mot_demean_r08                   \
    -ortvec ../behavior_11run/mot_demean.r09.1D mot_demean_r09                   \
    -ortvec ../behavior_11run/mot_demean.r10.1D mot_demean_r10                   \
    -ortvec ../behavior_11run/mot_demean.r12.1D mot_demean_r12                   \
    -polort 3                                                  \
    -num_stimts 7                                              \
    -stim_times 1 ../behavior_11run/lim.txt 'BLOCK(2,1)'             \
    -stim_label 1 lim                                          \
    -stim_times 2 ../behavior_11run/tra.txt 'BLOCK(2,1)'             \
    -stim_label 2 tra                                          \
    -stim_times 3 ../behavior_11run/car.txt 'BLOCK(2,1)'             \
    -stim_label 3 car                                          \
    -stim_times 4 ../behavior_11run/cit.txt 'BLOCK(2,1)'             \
    -stim_label 4 cit                                          \
    -stim_times_AM1 5 ../behavior_11run/valence.txt 'dmBLOCK(1)'     \
    -stim_label 5 val                                          \
    -stim_times_AM1 6 ../behavior_11run/intensity.txt 'dmBLOCK(1)'   \
    -stim_label 6 int                                          \
    -stim_times_AM1 7 ../behavior_11run/odor_va.txt 'BLOCK(2,1)'     \
    -stim_label 7 odor_va                                      \
    -jobs 28                                                   \
    -fout -tout -x1D X.xmat.${filedec}.1D -xjpeg X.${filedec}.jpg       \
    -bucket stats.${subj}.${filedec}

else
 echo "Usage: $0 <Subjname> <analysis>"

endif
