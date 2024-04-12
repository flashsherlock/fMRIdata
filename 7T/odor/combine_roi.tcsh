#! /bin/csh

foreach ub (`count -dig 2 4 11` 13 14 `count -dig 2 16 29` 31 32 33 34)
# set sub=S01_yyt
set sub=S${ub}
set analysis=pabiode

# set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}/
set datafolder=/Volumes/WD_F/gufei/7T_odor/${sub}/
cd "${datafolder}"

# generate sig masks
# foreach filedec (orig tlrc)
#     # set mask
#     if ($filedec == orig) then
#         set mask = mask/allROI+orig
#     else
#         set mask = ../group/mask/allROI+tlrc
#     endif
#     # set sig
#     foreach sig (165 196)
#     # set the threshold according to sig
#     if ($sig == 165) then
#             set t = 1.65
#     else if ($sig == 196) then
#             set t = 1.96
#     endif
#     # set the data file
#     set data_beta = ${sub}.${analysis}.results/stats.${sub}.${analysis}.odorVI+${filedec}
#     3dcalc  -a ${data_beta}'[2]' \
#             -b ${data_beta}'[5]' \
#             -c ${data_beta}'[8]' \
#             -d ${data_beta}'[11]' \
#             -e ${data_beta}'[14]' \
#             -f ${mask} \
#             -expr "or(astep(a,${t}),astep(b,${t}),astep(c,${t}),astep(d,${t}),astep(e,${t}))*f" \
#             -prefix mask/allsig${sig}
#     end
# end

cd mask

# superfical amygdala
foreach sig (align at165 at196 at165_p at196_p)
    3dcalc -a CeMeAmy_${sig}.freesurfer+orig \
    -b corticalAmy_${sig}.freesurfer+orig \
    -expr 'a+b' \
    -prefix superAmy_${sig}.freesurfer+orig
end
# # all roi with labels (exclude AA)
# 3dcalc -a Piriform.seg+orig \
# -b sAmy.freesurfer+orig \
# -c Amy8_align.freesurfer+orig \
# -expr 'a*iszero(b)+b*c' \
# -prefix all.seg

# # cd ${sub}.${analysis}.results
# # rm BoxROI*

# # combine Piriform and Amygdala
# 3dcalc -a Amy8_align.freesurfer+orig -b Pir_new.draw+orig \
# -prefix allROI \
# -expr "or(a,b)"

# # compute box coordinates and store ijk in an array
# set ijk=(`3dAutobox -extent_ijk -noclust allROI+orig`)

# # generate box ROI
# 3dcalc -a allROI+orig \
# -prefix BoxROI \
# -expr "or(a,within(i,${ijk[1]},${ijk[2]})*within(j,${ijk[3]},${ijk[4]})*within(k,${ijk[5]},${ijk[6]}))"

# # generate extended box ROI
# set ijk=(`3dAutobox -npad 3 -extent_ijk -noclust allROI+orig`)
# 3dcalc -a allROI+orig \
# -prefix BoxROIext \
# -expr "or(a,within(i,${ijk[1]},${ijk[2]})*within(j,${ijk[3]},${ijk[4]})*within(k,${ijk[5]},${ijk[6]}))"

# # generate box labels
# # 100-do not belong to any position
# # 101-115 Amy
# # 121-129 Pir
# # ifelse(a-10,a,0) removes AAA
# 3dcalc -a sAmy.freesurfer+orig  \
# -b Piriform.seg+orig            \
# -c BoxROI+orig                  \
# -prefix Box_label               \
# -expr "100*c+ifelse(a-10,a,0)+iszero(ifelse(a-10,a,0))*b"


end
