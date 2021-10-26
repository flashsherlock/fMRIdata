#! /bin/csh
foreach ub (`count -dig 2 4 8`)

set sub = S${ub}
# foreach sub (S01_yyt S01 S02 S03)
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"
# make dir to save masks
set analysis=pabiode
set subj = ${sub}.${analysis}
cd ${subj}.results

# move piriform roi to mask folder
mv Piriform.seg* ../mask
# mv ../${subj}.results.old/Piriform.seg* ../mask

# remove files
# rm allrun.volreg*
# rm pb0[0-4]*
# rm NIfitts*
# rm NIerrts*

end
