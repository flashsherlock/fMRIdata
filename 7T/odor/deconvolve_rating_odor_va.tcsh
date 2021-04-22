#!/bin/tcsh
# set sub=S01_yyt
# use input as sub
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

switch ($2)
    case bio:
        set pb=pb07
        set analysis=pabiode
        breaksw
    case phy:
        set pb=pb07
        set analysis=paphde
        breaksw
    case no:
        set pb=pb06
        set analysis=pade
        breaksw
    default:
        set pb=pb07
        set analysis=pabiode
endsw

# run the regression analysis
set subj = ${sub}.${analysis}
cd ${subj}.results
set filedec = odorVIva
3dDeconvolve -input ${pb}.${subj}.r*.scale+orig.HEAD                    \
    -ortvec mot_demean.r01.1D mot_demean_r01                            \
    -ortvec mot_demean.r02.1D mot_demean_r02                            \
    -ortvec mot_demean.r03.1D mot_demean_r03                            \
    -ortvec mot_demean.r04.1D mot_demean_r04                            \
    -ortvec mot_demean.r05.1D mot_demean_r05                            \
    -ortvec mot_demean.r06.1D mot_demean_r06                            \
    -polort 3                                                           \
    -num_stimts 7                                                       \
    -stim_times 1 ../behavior/lim.txt 'BLOCK(2,1)'                      \
    -stim_label 1 lim                                                   \
    -stim_times 2 ../behavior/tra.txt 'BLOCK(2,1)'                      \
    -stim_label 2 tra                                                   \
    -stim_times 3 ../behavior/car.txt 'BLOCK(2,1)'                      \
    -stim_label 3 car                                                   \
    -stim_times 4 ../behavior/cit.txt 'BLOCK(2,1)'                      \
    -stim_label 4 cit                                                   \
    -stim_times_AM1 5 ../behavior/valence.txt 'dmBLOCK(1)'              \
    -stim_label 5 val                                                   \
    -stim_times_AM1 6 ../behavior/intensity.txt 'dmBLOCK(1)'            \
    -stim_label 6 int                                                   \
    -stim_times_AM1 7 ../behavior/odor_va.txt 'BLOCK(2,1)'              \
    -stim_label 7 odor_va                                               \
    -jobs 12                                                             \
    -gltsym 'SYM: lim -tra'                                             \
    -glt_label 1 lim-tra                                                \
    -gltsym 'SYM: car -tra'                                             \
    -glt_label 2 car-tra                                                \
    -gltsym 'SYM: cit -tra'                                             \
    -glt_label 3 cit-tra                                                \
    -gltsym 'SYM: car -lim'                                             \
    -glt_label 4 car-lim                                                \
    -gltsym 'SYM: cit -lim'                                             \
    -glt_label 5 cit-lim                                                \
    -gltsym 'SYM: car -cit'                                             \
    -glt_label 6 car-cit                                                \
    -fout -tout -x1D X.xmat.${filedec}.1D -xjpeg X.${filedec}.jpg       \
    -bucket stats.${subj}.${filedec}

else
 echo "Usage: $0 <Subjname> <analysis>"

endif
