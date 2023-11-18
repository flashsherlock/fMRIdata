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
# 3dcalc \
# -a /Volumes/WD_F/gufei/3T_cw/BAA-OR/face/volume/BAA-OR-FvO-MPRM-thr10-2mm.nii.gz \
# -expr 'amongst(a,3,4,5,6)' \
# -prefix /Volumes/WD_F/gufei/3T_cw/ASAP_maps/fusiformOR_face
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
# -prefix /Volumes/WD_F/gufei/3T_cw/group/mask/FFA_OR \
# -input /Volumes/WD_F/gufei/3T_cw/ASAP_maps/fusiformOR_face+tlrc

# A37mv only
# 3dcalc \
# -a Brainnetome_1.0.A_mv_left+tlrc \
# -b Brainnetome_1.0.A_mv_right+tlrc \
# -expr 'a+b' \
# -prefix A37mv
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
# -prefix /Volumes/WD_F/gufei/3T_cw/group/mask/A37mv \
# -input /Volumes/WD_D/allsub/BN_atlas/nonresample/A37mv+tlrc
# # A37mv and A37lv
# 3dcalc \
# -a Brainnetome_1.0.A_lv_left+tlrc \
# -b Brainnetome_1.0.A_lv_right+tlrc \
# -c Brainnetome_1.0.A_mv_left+tlrc \
# -d Brainnetome_1.0.A_mv_right+tlrc \
# -expr 'a+b+c+d' \
# -prefix A37mlv
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
# -prefix /Volumes/WD_F/gufei/3T_cw/group/mask/A37mlv \
# -input /Volumes/WD_D/allsub/BN_atlas/nonresample/A37mlv+tlrc

# FFA mask from AAL
# 3dcalc \
# -a /Volumes/WD_F/gufei/3T_cw/aal/aal.nii.gz \
# -expr 'amongst(a,55,56)' \
# -prefix /Volumes/WD_F/gufei/3T_cw/aal/ffa_aal
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
# -prefix /Volumes/WD_F/gufei/3T_cw/group/mask/FusiformAAL \
# -input /Volumes/WD_F/gufei/3T_cw/aal/ffa_aal+tlrc

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

# calculate t for fusiform
# rm ../mask/FFV_CA_t+orig*
# # if data not exist
# if (! -e ../mask/FFV_CA_t+orig.HEAD) then
#     3dcalc \
#         -a "stats.${sub}.de.new+orig[52]" \
#         -b ../mask/FusiformCA+orig \
#         -expr 'a*b' \
#         -prefix ../mask/FFV_CA_t \
#         -datum short
# endif
# # draw sphere for difference radius
# foreach r (2 3 4 5 6)
#     3dmaxima \
#     -input "../mask/FFV_CA_t+orig" \
#     -spheres_1toN -out_rad ${r} -prefix ../mask/FFV_CA_max${r}v \
#     -min_dist 100 -thresh 1.65 -coords_only
# end

# # transform FFA mask
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

# Fusiform AAL
set mask=/Volumes/WD_F/gufei/3T_cw/group/mask/FusiformAAL+tlrc
# nonlinear warp
3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
             -source ${mask}                                                                      \
             -interp NN                                                               \
             -master pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
             -prefix ../mask/FusiformAAL
# if data not exist
if (! -e ../mask/FFV_AAL_t+orig.HEAD) then
    3dcalc \
        -a "stats.${sub}.de.new+orig[52]" \
        -b ../mask/FusiformAAL+orig \
        -expr 'a*b' \
        -prefix ../mask/FFV_AAL_t \
        -datum short
endif
# draw sphere for difference radius
foreach r (2 3 4 5 6)
    3dmaxima \
    -input "../mask/FFV_AAL_t+orig" \
    -spheres_1toN -out_rad ${r} -prefix ../mask/FFV_AAL_max${r}v \
    -min_dist 100 -thresh 1.65 -coords_only
end

end
