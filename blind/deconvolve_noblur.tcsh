#!/bin/tcsh
if ( $# > 0 ) then
set sub = $1
set analysis=pade
set datafolder=/Volumes/WD_F/gufei/blind/${sub}/
cd "${datafolder}"
echo ${sub} ${analysis}
# run the regression analysis
set subj = ${sub}.${analysis}
cd ${subj}.results
set filedec = odor_noblur
set pb = `ls pb0?.${subj}.r01.volreg+orig.HEAD | cut -d . -f1`
# deconvolve
3dDeconvolve -input ${pb}.${subj}.r*.volreg+orig.HEAD               \
    -censor motion_${subj}_censor.1D                                \
    -ortvec mot_demean.r01.1D mot_demean_r01                        \
    -ortvec mot_demean.r02.1D mot_demean_r02                        \
    -ortvec mot_demean.r03.1D mot_demean_r03                        \
    -ortvec mot_demean.r04.1D mot_demean_r04                        \
    -ortvec mot_demean.r05.1D mot_demean_r05                        \
    -ortvec mot_demean.r06.1D mot_demean_r06                        \
    -polort 3                                                       \
    -num_stimts 8                                                   \
    -stim_times 1 stimuli/gas.txt 'BLOCK(2,1)'                      \
    -stim_label 1 gas                                               \
    -stim_times 2 stimuli/ind.txt 'BLOCK(2,1)'                      \
    -stim_label 2 ind                                               \
    -stim_times 3 stimuli/ros.txt 'BLOCK(2,1)'                      \
    -stim_label 3 ros                                               \
    -stim_times 4 stimuli/pin.txt 'BLOCK(2,1)'                      \
    -stim_label 4 pin                                               \
    -stim_times 5 stimuli/app.txt 'BLOCK(2,1)'                      \
    -stim_label 5 app                                               \
    -stim_times 6 stimuli/min.txt 'BLOCK(2,1)'                      \
    -stim_label 6 min                                               \
    -stim_times 7 stimuli/fru.txt 'BLOCK(2,1)'                      \
    -stim_label 7 fru                                               \
    -stim_times 8 stimuli/flo.txt 'BLOCK(2,1)'                      \
    -stim_label 8 flo                                               \
    -jobs 12                                                        \
    -x1D_uncensored X.nocensor.${filedec}.xmat.1D                   \
    -x1D X.xmat.${filedec}.1D -xjpeg X.${filedec}.jpg               \
    -noFDR                                                          \
    -cbucket cbucket.${subj}.${filedec}

# cannot use -nobucket, otherwise cbucket will not be generated
# so, remove Decon*
rm Decon*

# cat all runs
if (! -e allrun.volreg.${subj}+orig.HEAD) then
    # echo nodata
    3dTcat -prefix allrun.volreg.${subj} ${pb}.${subj}.r*.volreg+orig.HEAD
endif

# synthesize fitts of no interests, use -dry for debug
3dSynthesize -cbucket cbucket.${subj}.${filedec}+orig -matrix X.nocensor.${filedec}.xmat.1D -select baseline -prefix NIfitts.${subj}.${filedec}

# subtract fitts of no interests from all runs
3dcalc -a allrun.volreg.${subj}+orig -b NIfitts.${subj}.${filedec}+orig -expr 'a-b' -prefix NIerrts.${subj}.${filedec}

else
 echo "Usage: $0 <Subjname>"

endif
