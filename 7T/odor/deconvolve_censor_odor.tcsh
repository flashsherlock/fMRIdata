#!/bin/tcsh
# set sub=S04
if ( $# > 0 ) then
set sub = $1
set analysis=pabiode
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

set subj = ${sub}.${analysis}
cd ${subj}.results

# rm errts*
# rm fitts*
# rm stats*
# rm X*

set filedec = odorVI
# # convert motion parameters for per-run regression
# 1d_tool.py -infile motion_demean.1D -set_nruns 6               \
#            -split_into_pad_runs mot_demean

# # create censor file motion_${subj}_censor.1D, for censoring motion
# 1d_tool.py -infile dfile_rall.1D -set_nruns 6                  \
#     -show_censor_count -censor_prev_TR                         \
#     -censor_motion 0.3 motion_${subj}                          \
#     -overwrite

# run the regression analysis
3dDeconvolve -input pb07.${subj}.r*.scale+orig.HEAD            \
    -censor motion_${subj}_censor.1D                           \
    -ortvec mot_demean.r01.1D mot_demean_r01                   \
    -ortvec mot_demean.r02.1D mot_demean_r02                   \
    -ortvec mot_demean.r03.1D mot_demean_r03                   \
    -ortvec mot_demean.r04.1D mot_demean_r04                   \
    -ortvec mot_demean.r05.1D mot_demean_r05                   \
    -ortvec mot_demean.r06.1D mot_demean_r06                   \
    -polort 3                                                  \
    -num_stimts 7                                              \
    -stim_times 1 ../behavior/lim.txt 'BLOCK(2,1)'             \
    -stim_label 1 lim                                          \
    -stim_times 2 ../behavior/tra.txt 'BLOCK(2,1)'             \
    -stim_label 2 tra                                          \
    -stim_times 3 ../behavior/car.txt 'BLOCK(2,1)'             \
    -stim_label 3 car                                          \
    -stim_times 4 ../behavior/cit.txt 'BLOCK(2,1)'             \
    -stim_label 4 cit                                          \
    -stim_times 5 ../behavior/ind.txt 'BLOCK(2,1)'             \
    -stim_label 5 ind                                          \
    -stim_times_AM1 6 ../behavior/valence.txt 'dmBLOCK(1)'     \
    -stim_label 6 val                                          \
    -stim_times_AM1 7 ../behavior/intensity.txt 'dmBLOCK(1)'   \
    -stim_label 7 int                                          \
    -jobs 12                                                   \
    -gltsym 'SYM: lim -tra'                                    \
    -glt_label 1 lim-tra                                       \
    -gltsym 'SYM: car -tra'                                    \
    -glt_label 2 car-tra                                       \
    -gltsym 'SYM: cit -tra'                                    \
    -glt_label 3 cit-tra                                       \
    -gltsym 'SYM: car -lim'                                    \
    -glt_label 4 car-lim                                       \
    -gltsym 'SYM: cit -lim'                                    \
    -glt_label 5 cit-lim                                       \
    -gltsym 'SYM: car -cit'                                    \
    -glt_label 6 car-cit                                       \
    -gltsym 'SYM: ind -lim'                                    \
    -glt_label 7 ind-lim                                       \
    -gltsym 'SYM: ind -tra'                                    \
    -glt_label 8 ind-tra                                       \
    -gltsym 'SYM: ind -car'                                    \
    -glt_label 9 ind-car                                       \
    -gltsym 'SYM: ind -cit'                                    \
    -glt_label 10 ind-cit                                      \
    -fout -tout -x1D X.xmat.${filedec}.1D -xjpeg X.${filedec}.jpg      \
    -x1D_uncensored X.nocensor.${filedec}.xmat.1D                      \
    -bucket stats.${subj}.${filedec}

else
 echo "Usage: $0 <Subjname>"

endif
