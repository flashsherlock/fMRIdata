#! /bin/csh
foreach sub (S04 S05 S06 S07 S08)
# set sub=S01_yyt
set analysis=pabiode

set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}/
cd "${datafolder}"
cd mask
# cd ${sub}.${analysis}.results
# rm BoxROI*

# combine Piriform and Amygdala
3dcalc -a Amy8_align.freesurfer+orig -b Pir_new.draw+orig \
-prefix allROI \
-expr "or(a,b)"

# compute box coordinates and store ijk in an array
set ijk=(`3dAutobox -extent_ijk -noclust allROI+orig`)

# generate box ROI
3dcalc -a allROI+orig \
-prefix BoxROI \
-expr "or(a,within(i,${ijk[1]},${ijk[2]})*within(j,${ijk[3]},${ijk[4]})*within(k,${ijk[5]},${ijk[6]}))"

end
