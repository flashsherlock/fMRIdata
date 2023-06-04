#! /bin/csh
foreach ub (`count -dig 2 14 16`)

set sub = S${ub}
set datafolder=/Volumes/WD_F/gufei/blind/${sub}/
cd "${datafolder}"
# make dir to save masks
set analysis=pade
set subj = ${sub}.${analysis}
cd ${subj}.results

# find volreg number
@ pbvol = `ls pb0?.*.r01.volreg+orig.HEAD | cut -d . -f1 | cut -c3-4` - 1

# remove files
rm all_runs*
rm pb0[0-${pbvol}]*

end
