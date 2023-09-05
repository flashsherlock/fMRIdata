#! /bin/csh

# ffa mask
# cd "/Volumes/WD_D/allsub/BN_atlas/nonresample"
# whereami -mask_atlas_region CA_ML_18_MNI:Left:Fusiform
# whereami -mask_atlas_region CA_ML_18_MNI:Right:Fusiform
# # combine
# 3dcalc \
# -a CA_ML_18_MNI.Fusiform.l+tlrc \
# -b CA_ML_18_MNI.Fusiform.r+tlrc \
# -expr 'a+b' \
# -prefix fusiform.CA
# # resample
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
# -prefix ../FusiformCA \
# -input fusiform.CA+tlrc

# # resample to ASAP_maps
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/ASAP_maps/facescene_ttest_N124_face_vs_scene.nii.gz \
# -prefix ../FusiformCA_asap \
# -input fusiform.CA+tlrc
# # combine with face-scene
# # http://www.andrewengell.com
# 3dcalc \
# -a /Volumes/WD_D/allsub/BN_atlas/FusiformCA_asap+tlrc \
# -b "/Volumes/WD_F/gufei/3T_cw/ASAP_maps/facescene_ttest_N124_face_vs_scene.nii.gz[1]" \
# -expr 'a*step(b-1.65)' \
# -prefix /Volumes/WD_F/gufei/3T_cw/ASAP_maps/fusiformCA_face
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
# -prefix /Volumes/WD_F/gufei/3T_cw/group/mask/FFA_CA \
# -input /Volumes/WD_F/gufei/3T_cw/ASAP_maps/fusiformCA_face+tlrc

# http://www.brainactivityatlas.org/atlas/atlas-download/object-recognition/
3dcalc \
-a /Volumes/WD_F/gufei/3T_cw/BAA-OR/face/volume/BAA-OR-FvO-MPRM-thr10-2mm.nii.gz \
-expr 'amongst(a,3,4,5,6)' \
-prefix /Volumes/WD_F/gufei/3T_cw/ASAP_maps/fusiformOR_face
3dresample \
-master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
-prefix /Volumes/WD_F/gufei/3T_cw/group/mask/FFA_OR \
-input /Volumes/WD_F/gufei/3T_cw/ASAP_maps/fusiformOR_face+tlrc

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

# transform FFA mask
set mask=/Volumes/WD_F/gufei/3T_cw/group/mask/FFA_CA+tlrc
# nonlinear warp
3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
             -source ${mask}                                                                      \
             -interp NN                                                               \
             -master pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
             -prefix ../mask/FFA_CA
# Fusiform
set mask=/Volumes/WD_F/gufei/3T_cw/group/mask/FusiformCA+tlrc
# nonlinear warp
3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
             -source ${mask}                                                                      \
             -interp NN                                                               \
             -master pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
             -prefix ../mask/FusiformCA
end
