#! /bin/csh
foreach ub (`count -dig 2 4 8`)

set sub = S${ub}
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"
# make dir to save masks
set analysis=pabioe2a
set subj = ${sub}.${analysis}
cd ${subj}.results

rm all_runs*
rm NIfitts*

end
