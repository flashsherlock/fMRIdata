#!/bin/tcsh

# use input as sub
# if ( $# > 0 ) then
# set sub = $1

# for subs from 04 to 11 and 19 to 20
foreach ub (`count -dig 2 4 11` 13 14 `count -dig 2 16 34`)
# set sub=S01_yyt
set sub=S${ub}
# set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
set datafolder=/Volumes/WD_F/gufei/7T_odor/${sub}
cd "${datafolder}"
set analysis=pabiode

echo ${sub} ${analysis}

# run the regression analysis
set subj = ${sub}.${analysis}
# file names have been unified
set subjva = ${subj}.odorVI
# if (${ub} =~ 0[45678]) then
#     set subjva = ${subj}.odorVI
# else
#     set subjva = ${subj}
# endif
cd ${subj}.results

# normalize Anatomical img to mni space (linear warp)
# @auto_tlrc -no_ss -init_xform AUTO_CENTER -maxite 500 -base ~/abin/MNI152_T1_2009c+tlrc. -input anat_final.${sub}.${analysis}+orig
# if (! -e stats.${subj}.odorVI+orig.HEAD) then
#     # rename
#     mv  stats.${subj}+orig.HEAD stats.${subj}.odorVI+orig.HEAD
#     mv  stats.${subj}+orig.BRIK stats.${subj}.odorVI+orig.BRIK
# endif
# # align to nomalized Anatomical img
# @auto_tlrc -apar anat_final.${sub}.${analysis}+tlrc -input stats.${subj}.odorVI+orig

# # normalize Anatomical img to mni space (nonlinear warp)
# 3dNwarpApply                                            \
# -master anatQQ.${sub}+tlrc                              \
# -source stats.${subj}.odorVI+orig                       \
# -nwarp "anatQQ.${sub}_WARP.nii anatQQ.${sub}.aff12.1D INV(anatSS.${sub}_al_keep_mat.aff12.1D)"   \
# -prefix stats_WARP.${subj}.odorVI

# # calculate abs(cit-lim)-abs(car-lim)
# 3dcalc -prefix citcar.${subj}       \
# -a stats.${subj}.odorVI+tlrc"[34]"  \
# -b stats.${subj}.odorVI+tlrc"[31]"  \
# -expr "abs(a)-abs(b)"

# calculate abs(cit-lim)-abs(car-lim) and normalized by abs(cit-lim)+abs(car-lim)
# 3dcalc -prefix citcar_norm.${subj}       \
# -a stats.${subj}.odorVI+tlrc"[34]"       \
# -b stats.${subj}.odorVI+tlrc"[31]"       \
# -expr "(abs(a)-abs(b))/(abs(a)+abs(b))"

# for individual plots
3dcalc -prefix allroi_citcar.${subj}        \
-a stats.${subj}.odorVI+orig"[34]"          \
-b stats.${subj}.odorVI+orig"[31]"          \
-c ../mask/allROI+orig                      \
-expr "c*(abs(a)-abs(b))"

3dcalc -prefix allroi_citcar.${subj}        \
-a stats.${subj}.odorVI+tlrc"[34]"          \
-b stats.${subj}.odorVI+tlrc"[31]"          \
-c ../../group/mask/allROI+tlrc             \
-expr "c*(abs(a)-abs(b))"

3dcalc -prefix allroi_citcar_norm.${subj}       \
-a stats.${subj}.odorVI+orig"[34]"              \
-b stats.${subj}.odorVI+orig"[31]"              \
-c ../mask/allROI+orig                          \
-expr "c*(abs(a)-abs(b))/(abs(a)+abs(b))"

3dcalc -prefix allroi_citcar_norm.${subj}       \
-a stats.${subj}.odorVI+tlrc"[34]"              \
-b stats.${subj}.odorVI+tlrc"[31]"              \
-c ../../group/mask/allROI+tlrc                 \
-expr "c*(abs(a)-abs(b))/(abs(a)+abs(b))"

# rm *t165.freesurfer*
# rm ../mask/*at165*

# Print number of voxels for each ROI
# 3dROIstats -nzvoxels -mask Amy.seg_t165.freesurfer+orig.HEAD Amy.seg_t165.freesurfer+orig.HEAD >! ../mask/voxels_act.txt

# # create mask for each region
# foreach region (1 3 5 6 7 8 9 10 15)
#     3dcalc -a Amy.seg_t165.freesurfer+orig -expr "equals(a,${region})" -prefix ../mask/Amy_at165${region}seg.freesurfer+orig
# end

# extract tent and beta values
# set filedec = odorVI_12
# set maskdec = align # at165 or align
# set maskdec_t2 = at165
# set maskdec_t = ${maskdec_t2}_p # positive only for tent
# set data_tent=tent.${subj}.${filedec}+orig
# set data_beta=stats.${subjva}+orig

# # make dir
# if (! -e ../../stats) then
#     mkdir ../../stats
# endif
# if (! -e ../../stats/${sub}) then
#     mkdir ../../stats/${sub}
# endif

# foreach region (Pir_new Pir_old APC_new APC_old PPC)
#     # generate t threshold masks
#     # different regions of amygdala
#     3dcalc  -a ${data_beta}'[2]' \
#             -b ${data_beta}'[5]' \
#             -c ${data_beta}'[8]' \
#             -d ${data_beta}'[11]' \
#             -e ${data_beta}'[14]' \
#             -f ../mask/${region}.draw+orig \
#             -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65),astep(e,1.65))*f' \
#             -prefix ../mask/${region}_${maskdec_t2}.draw

#     3dcalc  -a ${data_beta}'[2]' \
#             -b ${data_beta}'[5]' \
#             -c ${data_beta}'[8]' \
#             -d ${data_beta}'[11]' \
#             -e ${data_beta}'[14]' \
#             -f ../mask/${region}.draw+orig \
#             -expr 'or(step(a-1.65),step(b-1.65),step(c-1.65),step(d-1.65),step(e-1.65))*f' \
#             -prefix ../mask/${region}_${maskdec_t}.draw

#     3dROIstats -mask ../mask/${region}_${maskdec_t}.draw+orig \
#     -nzmean ${data_tent}"[`seq -s , 1 64`65]" >! ../../stats/${sub}/${region}_${maskdec_t}_tent_12.txt

#     # extract betas from blurred statas
#     # 3dROIstats -mask ../mask/${region}_${maskdec}.freesurfer+orig \
#     # -nzmean ${data_beta}"[`seq -s , 1 3 9`10]" >! ../../stats/${sub}/${region}_${maskdec}_beta.txt
# end

# foreach region (Amy9 Amy8 corticalAmy CeMeAmy BaLaAmy)
#     3dcalc  -a ${data_beta}'[2]' \
#             -b ${data_beta}'[5]' \
#             -c ${data_beta}'[8]' \
#             -d ${data_beta}'[11]' \
#             -e ${data_beta}'[14]' \
#             -f ../mask/${region}_${maskdec}.freesurfer+orig \
#             -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65),astep(e,1.65))*f' \
#             -prefix ../mask/${region}_${maskdec_t2}.freesurfer
    
#     3dcalc  -a ${data_beta}'[2]' \
#             -b ${data_beta}'[5]' \
#             -c ${data_beta}'[8]' \
#             -d ${data_beta}'[11]' \
#             -e ${data_beta}'[14]' \
#             -f ../mask/${region}_${maskdec}.freesurfer+orig \
#             -expr 'or(step(a-1.65),step(b-1.65),step(c-1.65),step(d-1.65),step(e-1.65))*f' \
#             -prefix ../mask/${region}_${maskdec_t}.freesurfer

#     3dROIstats -mask ../mask/${region}_${maskdec_t}.freesurfer+orig \
#     -nzmean ${data_tent}"[`seq -s , 1 64`65]" >! ../../stats/${sub}/${region}_${maskdec_t}_tent_12.txt

#     # extract betas from blurred statas
#     # 3dROIstats -mask ../mask/${region}_${maskdec}.freesurfer+orig \
#     # -nzmean ${data_beta}"[`seq -s , 1 3 9`10]" >! ../../stats/${sub}/${region}_${maskdec}_beta.txt
# end

# foreach region (1 3 5 6 7 8 9 10 15)
#     3dROIstats -mask ../mask/Amy_${maskdec}${region}seg.freesurfer+orig \
#     -nzmean ${data_tent_va}"[`seq -s , 1 43`44]" >! ../../stats/${sub}/Amy_${maskdec}${region}seg_tentva.txt
#     3dROIstats -mask ../mask/Amy_${maskdec}${region}seg.freesurfer+orig \
#     -nzmean ${data_tent}"[`seq -s , 1 43`44]" >! ../../stats/${sub}/Amy_${maskdec}${region}seg_tent.txt

#     # 3dROIstats -mask ../mask/Amy_${maskdec}${region}seg.freesurfer+orig \
#     # -nzmean ${data_beta}"[`seq -s , 1 3 9`10]" >! ../../stats/${sub}/Amy_${maskdec}${region}seg_beta.txt
# end

# # extract beta values from each voxel
# 3dmaskdump -mask ../mask/sAmy.freesurfer+orig   \
#     -mrange 1 15                                \
#     -o ../../stats/${sub}/sAmy_betadiff.txt     \
#     ../mask/sAmy.freesurfer+orig                \
#     ${data_beta}"[`seq -s , 1 3 12`13,`seq -s , 2 3 13`14]"
#     # -o option can not replace exsisting files
#     # >! ../../stats/${sub}/sAmy_betadiff.txt
# # Piriform
# 3dmaskdump -mask Piriform.seg+orig                   \
#     -o ../../stats/${sub}/sPir_betadiff.txt     \
#     Piriform.seg+orig                                \
#     ${data_beta}"[`seq -s , 1 3 12`13,`seq -s , 2 3 13`14]"
#     # -o option can not replace exsisting files
#     # >! ../../stats/${sub}/sAmy_betadiff.txt

# else
#  echo "Usage: $0 <Subjname> <analysis>"

end
