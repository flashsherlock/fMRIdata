#! /bin/csh

# ffa mask
# cd "/Volumes/WD_D/allsub/BN_atlas/nonresample"
# whereami -mask_atlas_region Brainnetome_1.0::A37lv_right
# whereami -mask_atlas_region Brainnetome_1.0::A37lv_left
# whereami -mask_atlas_region Brainnetome_1.0::A37mv_right
# whereami -mask_atlas_region Brainnetome_1.0::A37mv_left
# whereami -mask_atlas_region Brainnetome_1.0::A20rv_right
# whereami -mask_atlas_region Brainnetome_1.0::A20rv_left
# # combine
# 3dcalc \
# -a Brainnetome_1.0.A_lv_left+tlrc \
# -b Brainnetome_1.0.A_lv_right+tlrc \
# -c Brainnetome_1.0.A_mv_left+tlrc \
# -d Brainnetome_1.0.A_mv_right+tlrc \
# -e Brainnetome_1.0.A_rv_left+tlrc \
# -f Brainnetome_1.0.A_rv_right+tlrc \
# -expr 'a+b+c+d+e+f' \
# -prefix fusiform.BN
# # resample
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
# -prefix ../Fusiform \
# -input fusiform.BN+tlrc

# resample to ASAP_maps
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/ASAP_maps/facescene_ttest_N124_face_vs_scene.nii.gz \
# -prefix ../Fusiform_asap \
# -input fusiform.BN+tlrc
# # combine with face-scene
# # http://www.andrewengell.com
# 3dcalc \
# -a /Volumes/WD_D/allsub/BN_atlas/Fusiform_asap+tlrc \
# -b "/Volumes/WD_F/gufei/3T_cw/ASAP_maps/facescene_ttest_N124_face_vs_scene.nii.gz[1]" \
# -expr 'a*step(b-1.65)' \
# -prefix /Volumes/WD_F/gufei/3T_cw/ASAP_maps/fusiform_face
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
# -prefix /Volumes/WD_F/gufei/3T_cw/group/mask/FFA \
# -input /Volumes/WD_F/gufei/3T_cw/ASAP_maps/fusiform_face+tlrc

# generate roi for each subject
foreach ub (`count -dig 2 $1 $2`)
set sub=S${ub}
set analysis=de

set datafolder=/Volumes/WD_F/gufei/3T_cw/${sub}/
# sub folder not exsist then continue
if (! -e ${datafolder}) then
    echo S${ub} not exsist
    continue
endif

cd "${datafolder}"

cd ${sub}.${analysis}.results

# get number from sub
set subnum=`echo ${sub} | cut -c2-3`
# if the first charactor is 0, then remove it
if ( `echo ${subnum} | cut -c1` == 0 ) then
    set subnum=`echo ${subnum} | cut -c2`
endif

# resample Piriform mask
# set roidir=/Volumes/Ventoy/roi/${subnum}
# 3dcalc \
# -a ${roidir}/lapc.nii \
# -b ${roidir}/rapc.nii \
# -c ${roidir}/lppc.nii \
# -d ${roidir}/rppc.nii \
# -e ${roidir}/lapc_n.nii \
# -f ${roidir}/rapc_n.nii \
# -expr '21*(a+b)+22*(c+d)+29*(e+f)' \
# -prefix  COPY_anat_final.${sub}.${analysis}

# resample
# 3dresample  -input COPY_anat_final.${sub}.${analysis}+orig      \
#             -master vr_base_min_outlier+orig               \
#             -rmode NN                                           \
#             -prefix Piriform.seg
# # creat piriform mask and remove voxels in Amy
# 3dcalc -a Piriform.seg+orig -b Amy.freesurfer+orig -expr 'amongst(a,21,22,29)*iszero(b)' -prefix ../mask/Pir_new.draw+orig
# # creat old piriform mask
# 3dcalc -a Piriform.seg+orig -b Amy.freesurfer+orig -expr 'amongst(a,21,22)*iszero(b)' -prefix ../mask/Pir_old.draw+orig
# # create APC_new
# 3dcalc -a Piriform.seg+orig -b Amy.freesurfer+orig -expr 'amongst(a,21,29)*iszero(b)' -prefix ../mask/APC_new.draw+orig
# # create APC_old
# 3dcalc -a Piriform.seg+orig -b Amy.freesurfer+orig -expr 'amongst(a,21)*iszero(b)' -prefix ../mask/APC_old.draw+orig
# # creat PPC
# 3dcalc -a Piriform.seg+orig -b Amy.freesurfer+orig -expr 'amongst(a,22)*iszero(b)' -prefix ../mask/PPC.draw+orig
# # move Piriform.seg to mask folder
# mv Piriform.seg* ../mask

# transform FFA mask
# set mask=/Volumes/WD_F/gufei/3T_cw/group/mask/FFA+tlrc
# # nonlinear warp
# 3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
#              -source ${mask}                                                                      \
#              -interp NN                                                               \
#              -master pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
#              -prefix ../mask/FFA
# # Fusiform
# set mask=/Volumes/WD_F/gufei/3T_cw/group/mask/Fusiform+tlrc
# # nonlinear warp
# 3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
#              -source ${mask}                                                                      \
#              -interp NN                                                               \
#              -master pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
#              -prefix ../mask/Fusiform

# CA masks
# transform FFA mask
# set mask=/Volumes/WD_F/gufei/3T_cw/group/mask/FFA_CA+tlrc
# # nonlinear warp
# 3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
#              -source ${mask}                                                                      \
#              -interp NN                                                               \
#              -master pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
#              -prefix ../mask/FFA_CA
# # Fusiform
# set mask=/Volumes/WD_F/gufei/3T_cw/group/mask/FusiformCA+tlrc
# # nonlinear warp
# 3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
#              -source ${mask}                                                                      \
#              -interp NN                                                               \
#              -master pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
#              -prefix ../mask/FusiformCA
# generate extended box ROI
set ijk=(`3dAutobox -npad 9 -extent_ijk -noclust ../mask/Amy8_align.freesurfer+orig`)
3dcalc -a ../mask/Amy8_align.freesurfer+orig \
-prefix ../mask/BoxROIext \
-expr "or(a,within(i,${ijk[1]},${ijk[2]})*within(j,${ijk[3]},${ijk[4]})*within(k,${ijk[5]},${ijk[6]}))"

end
