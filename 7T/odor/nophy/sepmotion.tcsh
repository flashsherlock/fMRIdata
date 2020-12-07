#!/bin/tcsh        
set sub=S01_yyt
set analysis=pade

set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

# separate motion file for each run without zero padding
set subj = ${sub}.${analysis}
cd ${subj}.results
set runnum=6

foreach run(`seq -s ' ' 1 ${runnum}`)
    awk '$1!=0' mot_demean.r0${run}.1D > mot_demean.r${run}.1D
end
# separate motion parameters with zero padding
# 1d_tool.py -infile motion_demean.1D                   \
#            -set_nruns 6                               \
#            -split_into_pad_runs mot.padded
# or set length of each run separately
# -set_run_lengths  64 64
