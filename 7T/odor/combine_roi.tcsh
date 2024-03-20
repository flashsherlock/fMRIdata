#! /bin/csh

foreach ub (`count -dig 2 4 11` 13 14 `count -dig 2 16 29` 31 32 33 34)
# set sub=S01_yyt
set sub=S${ub}
set analysis=pabiode

# set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}/
set datafolder=/Volumes/WD_F/gufei/7T_odor/${sub}/
cd "${datafolder}"
cd mask

# all roi with labels (exclude AA)
3dcalc -a Piriform.seg+orig \
-b sAmy.freesurfer+orig \
-c Amy8_align.freesurfer+orig \
-expr 'a*iszero(b)+b*c' \
-prefix all.seg

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

# generate extended box ROI
set ijk=(`3dAutobox -npad 3 -extent_ijk -noclust allROI+orig`)
3dcalc -a allROI+orig \
-prefix BoxROIext \
-expr "or(a,within(i,${ijk[1]},${ijk[2]})*within(j,${ijk[3]},${ijk[4]})*within(k,${ijk[5]},${ijk[6]}))"

# generate box labels
# 100-do not belong to any position
# 101-115 Amy
# 121-129 Pir
# ifelse(a-10,a,0) removes AAA
3dcalc -a sAmy.freesurfer+orig  \
-b Piriform.seg+orig            \
-c BoxROI+orig                  \
-prefix Box_label               \
-expr "100*c+ifelse(a-10,a,0)+iszero(ifelse(a-10,a,0))*b"


end
