#! /bin/csh
foreach ub (01_yyt `count -dig 2 1 8`)

set sub = S${ub}
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"
# make dir to save masks
set analysis=pabiode
set subj = ${sub}.${analysis}
cd ${subj}.results

rm all_runs*
rm NIfitts*

end
