#!/bin/tcsh
# set sub=S01_yyt
# use input as sub
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

# can be achieved by switch case stucture
# if ($2 == bio) then
#         set pb=pb05
#         set analysis=pabiode
#     else
#         if ($2 == phy) then
#         set pb=pb05
#         set analysis=paphde
#         else
#         set pb=pb04
#         set analysis=pade
#         endif
# endif

switch ($2)
    case bio:
        set pb=pb05
        set analysis=pabiode
        breaksw
    case phy:
        set pb=pb05
        set analysis=paphde
        breaksw
    case no:
        set pb=pb04
        set analysis=pade
        breaksw
    default:
        echo The second input must be bio, phy or no.
        echo ${analysis}
endsw

echo ${sub} ${analysis}

# run the regression analysis
set subj = ${sub}.${analysis}
cd ${subj}.results
set filedec = odorVI_noblur
3dDeconvolve -input ${pb}.${subj}.r*.volreg+orig.HEAD              \
    -ortvec mot_demean.r01.1D mot_demean_r01                   \
    -ortvec mot_demean.r02.1D mot_demean_r02                   \
    -ortvec mot_demean.r03.1D mot_demean_r03                   \
    -ortvec mot_demean.r04.1D mot_demean_r04                   \
    -ortvec mot_demean.r05.1D mot_demean_r05                   \
    -ortvec mot_demean.r06.1D mot_demean_r06                   \
    -polort 3                                                  \
    -num_stimts 6                                              \
    -stim_times 1 ../behavior/lim.txt 'BLOCK(2,1)'             \
    -stim_label 1 lim                                          \
    -stim_times 2 ../behavior/tra.txt 'BLOCK(2,1)'             \
    -stim_label 2 tra                                          \
    -stim_times 3 ../behavior/car.txt 'BLOCK(2,1)'             \
    -stim_label 3 car                                          \
    -stim_times 4 ../behavior/cit.txt 'BLOCK(2,1)'             \
    -stim_label 4 cit                                          \
    -stim_times_AM1 5 ../behavior/valence.txt 'dmBLOCK(1)'     \
    -stim_label 5 val                                          \
    -stim_times_AM1 6 ../behavior/intensity.txt 'dmBLOCK(1)'   \
    -stim_label 6 int                                          \
    -jobs 14                                                   \
    -x1D X.xmat.${filedec}.1D -xjpeg X.${filedec}.jpg          \
    -noFDR                                                     \
    -cbucket cbucket.${subj}.${filedec}

# cannot use -nobucket, otherwise cbucket will not be generated
# so, remove Decon*
rm Decon*

# cat all runs
3dTcat -prefix allrun.volreg.${subj} ${pb}.${subj}.r*.volreg+orig.HEAD
# synthesize fitts of no interests, use -dry for debug
3dSynthesize -cbucket cbucket.${subj}.${filedec}+orig -matrix X.xmat.${filedec}.1D -select baseline val int -prefix NIfitts.${subj}.${filedec}
# subtract fitts of no interests from all runs
3dcalc -a allrun.volreg.${subj}+orig -b NIfitts.${subj}.${filedec}+orig -expr 'a-b' -prefix NIerrts.${subj}.${filedec}

# visualize regressors in X.xmat
# 1dplot.py -infiles 'X.xmat.odorVI_noblur.1D[24..29]{0..129}' -xvals 1 130 1 -prefix run1.jpg  -ylabels lim tra car cit val int
# 1dplot -yaxis 0:1:5:5 -xaxis 0:30:5:10 '/Volumes/WD_D/gufei/7T_odor/S01_yyt/S01_yyt.pabiode.results/X.xmat.VI.1D[24, 25]'

# an easyway to check alignment
# @snapshot_volreg anat_final.S01_yyt.pabiode+orig pb05.S01_yyt.pabiode.r01.volreg+orig checkalign

else
 echo "Usage: $0 <Subjname> <analysis>"

endif
