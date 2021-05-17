#!/bin/tcsh
# set sub=S01_yyt
# use input as sub
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

set pb=pb01
set analysis=pabio12run

echo ${sub} ${analysis}

# run the regression analysis
set subj = ${sub}.${analysis}
cd ${subj}.results
set filedec = odorVIva11run_noblurAM2
3dDeconvolve -input ${pb}.${subj}.r{01,02,03,04,05,06,07,08,09,10,12}.volreg+orig.HEAD              \
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
    -stim_times_AM2 7 ../behavior_11run/odor_va.txt 'BLOCK(2,1)'     \
    -stim_label 7 odor_va                                      \
    -jobs 24                                                   \
    -x1D X.xmat.${filedec}.1D -xjpeg X.${filedec}.jpg          \
    -noFDR                                                     \
    -cbucket cbucket.${subj}.${filedec}

# cannot use -nobucket, otherwise cbucket will not be generated
# so, remove Decon*
# rm Decon*

# # cat all runs
# if (! -e all11run.volreg.${subj}+orig.HEAD) then
#     # echo nodata
#     3dTcat -prefix all11run.volreg.${subj} ${pb}.${subj}.r{01,02,03,04,05,06,07,08,09,10,12}.volreg+orig.HEAD
# endif

# # synthesize fitts of no interests, use -dry for debug
# 3dSynthesize -cbucket cbucket.${subj}.${filedec}+orig -matrix X.xmat.${filedec}.1D -select baseline val int odor_va -prefix NIfitts.${subj}.${filedec}

# # cbucket generated by afni_proc.py ( this is blurred! )
# # 3dSynthesize -cbucket all_betas.${subj}+orig -matrix X.xmat.1D -select baseline val int odor_va -prefix NIfitts.${subj}.${filedec}

# # subtract fitts of no interests from all runs
# 3dcalc -a all11run.volreg.${subj}+orig -b NIfitts.${subj}.${filedec}+orig -expr 'a-b' -prefix NIerrts.${subj}.${filedec}

# visualize regressors in X.xmat
# 1dplot.py -infiles 'X.xmat.odorVI_noblur.1D[24..29]{0..129}' -xvals 1 130 1 -prefix run1.jpg  -ylabels lim tra car cit val int
# 1dplot -yaxis 0:1:5:5 -xaxis 0:30:5:10 '/Volumes/WD_D/gufei/7T_odor/S01_yyt/S01_yyt.pabiode.results/X.xmat.VI.1D[24, 25]'

# an easyway to check alignment
# @snapshot_volreg anat_final.S01_yyt.pabiode+orig pb05.S01_yyt.pabiode.r01.volreg+orig checkalign

else
 echo "Usage: $0 <Subjname> <analysis>"

endif
