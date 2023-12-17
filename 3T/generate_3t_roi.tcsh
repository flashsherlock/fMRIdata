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

# # OFC mask 6mm sphere
# 3dcalc \
#     -a /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc   \
#     -expr 'step(36-(x-22)*(x-22)-(y+32)*(y+32)-(z+18)*(z+18))+step(36-(x+24)*(x+24)-(y+33)*(y+33)-(z+12)*(z+12))' \
#     -prefix /Volumes/WD_F/gufei/3T_cw/group/mask/OFC6mm

# # insula mask
# cd "/Volumes/WD_D/allsub/BN_atlas/nonresample"
# whereami -mask_atlas_region CA_ML_18_MNI:left:insula
# whereami -mask_atlas_region CA_ML_18_MNI:right:insula
# # combine
# 3dcalc \
# -a CA_ML_18_MNI.insula.l+tlrc \
# -b CA_ML_18_MNI.insula.r+tlrc \
# -expr 'a+b' \
# -prefix insula.CA
# # resample
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
# -prefix /Volumes/WD_F/gufei/3T_cw/group/mask/insulaCA \
# -input insula.CA+tlrc

# # aSTS mask
# http://www.brainactivityatlas.org/atlas/atlas-download/object-recognition/
# 3dcalc \
# -a /Volumes/WD_F/gufei/3T_cw/BAA-OR/face/volume/BAA-OR-FvO-MPRM-thr10-2mm.nii.gz \
# -expr 'amongst(a,11,12)' \
# -prefix /Volumes/WD_F/gufei/3T_cw/ASAP_maps/aSTS
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
# -prefix /Volumes/WD_F/gufei/3T_cw/group/mask/aSTS_OR \
# -input /Volumes/WD_F/gufei/3T_cw/ASAP_maps/aSTS+tlrc
# # pSTS mask
# 3dcalc \
# -a /Volumes/WD_F/gufei/3T_cw/BAA-OR/face/volume/BAA-OR-FvO-MPRM-thr10-2mm.nii.gz \
# -expr 'amongst(a,9,10)' \
# -prefix /Volumes/WD_F/gufei/3T_cw/ASAP_maps/pSTS
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
# -prefix /Volumes/WD_F/gufei/3T_cw/group/mask/pSTS_OR \
# -input /Volumes/WD_F/gufei/3T_cw/ASAP_maps/pSTS+tlrc
# # pSTS mask
# 3dcalc \
# -a /Volumes/WD_F/gufei/3T_cw/BAA-OR/face/volume/BAA-OR-FvO-MPRM-thr10-2mm.nii.gz \
# -expr 'amongst(a,7,8)' \
# -prefix /Volumes/WD_F/gufei/3T_cw/ASAP_maps/pcSTS
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
# -prefix /Volumes/WD_F/gufei/3T_cw/group/mask/pcSTS_OR \
# -input /Volumes/WD_F/gufei/3T_cw/ASAP_maps/pcSTS+tlrc

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
# foreach roi (Fusiform FFA FusiformCA FFA_CA)
# foreach roi (insulaCA OFC6mm aSTS_OR)
# foreach roi (pSTS_OR pcSTS_OR)
# set mask=/Volumes/WD_F/gufei/3T_cw/group/mask/${roi}+tlrc
# # nonlinear warp
# 3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
#              -source ${mask}                                                                      \
#              -interp NN                                                               \
#              -master pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
#              -prefix ../mask/${roi}
# end

# map the intersection of 3 conditions in Amy and OFC into individual space
set pre="sm_"
foreach roi (Amy OFC_AAL)
    foreach con (inter3 visinv visodo invodo)
    set mask=/Volumes/WD_F/gufei/3T_cw/group/plotmask/${pre}${roi}_${con}.nii
    # nonlinear warp
    3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
                -source ${mask}                                                                      \
                -interp NN                                                               \
                -master pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
                -prefix ../mask/${pre}${roi}_${con}
    end
end

# FFV masks
# 3dcalc \
#     -a "stats.${sub}.de.new+orig[52]" \
#     -b ../mask/FusiformCA+orig \
#     -expr 'step(a-1.65)*b' \
#     -prefix ../mask/FFV_CA
# rm ../mask/Pir_new0*
# 3dcalc \
# -a "stats.${sub}.de.odors+orig[2]" \
# -b ../mask/aSTS_OR+orig \
# -expr 'astep(a,1.96)*b' \
# -prefix ../mask/aSTS_OR05
# 3dcalc \
# -a "stats.${sub}.de.odors+orig[2]" \
# -b ../mask/aSTS_OR+orig \
# -expr 'astep(a,2.58)*b' \
# -prefix ../mask/aSTS_OR01
# 3dcalc \
# -a "stats.${sub}.de.odors+orig[2]" \
# -b ../mask/aSTS_OR+orig \
# -expr 'astep(a,2.81)*b' \
# -prefix ../mask/aSTS_OR005
# 3dcalc \
# -a "stats.${sub}.de.odors+orig[2]" \
# -b ../mask/aSTS_OR+orig \
# -expr 'astep(a,3.30)*b' \
# -prefix ../mask/aSTS_OR001
# 3dcalc \
# -a "stats.${sub}.de.odors+orig[2]" \
# -b ../mask/Pir_new.draw+orig \
# -expr 'astep(a,1.96)*b' \
# -prefix ../mask/Pir_new05
# 3dcalc \
# -a "stats.${sub}.de.odors+orig[2]" \
# -b ../mask/Pir_new.draw+orig \
# -expr 'astep(a,2.58)*b' \
# -prefix ../mask/Pir_new01
# 3dcalc \
# -a "stats.${sub}.de.odors+orig[2]" \
# -b ../mask/Pir_new.draw+orig \
# -expr 'astep(a,2.81)*b' \
# -prefix ../mask/Pir_new005
# 3dcalc \
# -a "stats.${sub}.de.odors+orig[2]" \
# -b ../mask/Pir_new.draw+orig \
# -expr 'astep(a,3.30)*b' \
# -prefix ../mask/Pir_new001
# rm ../mask/FFV_CA0*
# 3dcalc \
# -a "stats.${sub}.de.new+orig[52]" \
# -b ../mask/FusiformCA+orig \
# -expr 'step(a-1.96)*b' \
# -prefix ../mask/FFV_CA05
# 3dcalc \
# -a "stats.${sub}.de.new+orig[52]" \
# -b ../mask/FusiformCA+orig \
# -expr 'step(a-2.58)*b' \
# -prefix ../mask/FFV_CA01
# 3dcalc \
# -a "stats.${sub}.de.new+orig[52]" \
# -b ../mask/FusiformCA+orig \
# -expr 'step(a-2.81)*b' \
# -prefix ../mask/FFV_CA005
# 3dcalc \
# -a "stats.${sub}.de.new+orig[52]" \
# -b ../mask/FusiformCA+orig \
# -expr 'step(a-3.30)*b' \
# -prefix ../mask/FFV_CA001
# 3dcalc \
# -a "stats.${sub}.de.new+orig[52]" \
# -b ../mask/FusiformAAL+orig \
# -expr 'step(a-1.96)*b' \
# -prefix ../mask/FFV_AAL05
# 3dcalc \
# -a "stats.${sub}.de.new+orig[52]" \
# -b ../mask/FusiformAAL+orig \
# -expr 'step(a-2.58)*b' \
# -prefix ../mask/FFV_AAL01
# 3dcalc \
# -a "stats.${sub}.de.new+orig[52]" \
# -b ../mask/FusiformAAL+orig \
# -expr 'step(a-2.81)*b' \
# -prefix ../mask/FFV_AAL005
# 3dcalc \
# -a "stats.${sub}.de.new+orig[52]" \
# -b ../mask/FusiformAAL+orig \
# -expr 'step(a-3.30)*b' \
# -prefix ../mask/FFV_AAL001
# foreach dec (_at165 _at165_p)
#     3dcalc \
#         -a "stats.${sub}.de.new+orig[52]" \
#         -b ../mask/FusiformCA${dec}+orig \
#         -expr 'step(a-1.65)*b' \
#         -prefix ../mask/FFV_CA${dec}
# end

# rm ../mask/BoxROI*
# # generate extended box ROI 3 voxels
# set ijk=(`3dAutobox -npad 3 -extent_ijk -noclust ../mask/Amy8_align.freesurfer+orig`)
# 3dcalc -a ../mask/Amy8_align.freesurfer+orig \
# -prefix ../mask/BoxROIext \
# -expr "or(a,within(i,${ijk[1]},${ijk[2]})*within(j,${ijk[3]},${ijk[4]})*within(k,${ijk[5]},${ijk[6]}))"
# # nopad
# set ijk=(`3dAutobox -extent_ijk -noclust ../mask/Amy8_align.freesurfer+orig`)
# 3dcalc -a ../mask/Amy8_align.freesurfer+orig \
# -prefix ../mask/BoxROI \
# -expr "or(a,within(i,${ijk[1]},${ijk[2]})*within(j,${ijk[3]},${ijk[4]})*within(k,${ijk[5]},${ijk[6]}))"
# generate extended box ROI 3 voxels
# set ijk=(`3dAutobox -npad 3 -extent_ijk -noclust ../mask/OFC_AAL+orig`)
# 3dcalc -a ../mask/OFC_AAL+orig \
# -prefix ../mask/BoxOFCext \
# -expr "or(a,within(i,${ijk[1]},${ijk[2]})*within(j,${ijk[3]},${ijk[4]})*within(k,${ijk[5]},${ijk[6]}))"
# # nopad
# set ijk=(`3dAutobox -extent_ijk -noclust ../mask/OFC_AAL+orig`)
# 3dcalc -a ../mask/OFC_AAL+orig \
# -prefix ../mask/BoxOFC \
# -expr "or(a,within(i,${ijk[1]},${ijk[2]})*within(j,${ijk[3]},${ijk[4]})*within(k,${ijk[5]},${ijk[6]}))"
# # combine boxroi and boxofc
# 3dcalc \
# -a ../mask/BoxOFC+orig \
# -b ../mask/BoxROI+orig \
# -expr 'bool(a+b)' \
# -prefix ../mask/BoxROIs
# 3dcalc \
# -a ../mask/BoxOFCext+orig \
# -b ../mask/BoxROIext+orig \
# -expr 'bool(a+b)' \
# -prefix ../mask/BoxROIsext

end
