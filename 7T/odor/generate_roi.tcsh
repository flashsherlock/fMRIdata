#! /bin/csh

# precentral mask from AAL
# 3dcalc \
# -a /Volumes/WD_F/gufei/3T_cw/aal/aal.nii.gz \
# -expr 'amongst(a,1,2)' \
# -prefix /Volumes/WD_F/gufei/3T_cw/aal/pre_aal

foreach ub (`count -dig 2 4 11` 13 14 `count -dig 2 16 29` 31 32 33 34)
# set sub=S01_yyt
set sub=S${ub}
set analysis=pabiode

# set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}/
set datafolder=/Volumes/WD_F/gufei/7T_odor/${sub}/
cd "${datafolder}"

cd ${sub}.${analysis}.results

# transform occipital mask
# set mask=/Volumes/WD_F/gufei/blind/ProbAtlas_v4/subj_vol_all/maxprob_vol.nii
set mask=/Volumes/WD_F/gufei/3T_cw/aal/pre_aal+tlrc
# nonlinear warp
# rm visual_area_nl+*
3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
             -source ${mask}                                                                      \
             -interp NN                                                               \
             -master pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
             -prefix ../mask/precentral
# creat V1-V3
# 3dcalc -a visual_area_nl+orig -expr 'amongst(a,1,2)' -prefix ../mask/V1+orig
# 3dcalc -a visual_area_nl+orig -expr 'amongst(a,3,4)' -prefix ../mask/V2+orig
# 3dcalc -a visual_area_nl+orig -expr 'amongst(a,5,6)' -prefix ../mask/V3+orig
# 3dcalc -a visual_area_nl+orig -expr 'amongst(a,1,2,3,4,5,6)' -prefix ../mask/EarlyV+orig

# resample Piriform mask
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


# normalize Anatomical img to mni space
# @auto_tlrc -no_ss -maxite 500 -base ~/abin/MNI152_T1_2009c+tlrc. -input anat_final.${sub}.${analysis}+orig
# -init_xform AUTO_CENTER
# align to nomalized Anatomical img
# @auto_tlrc -apar anat_final.${sub}.${analysis}+tlrc -input ${subj}.analysis.twoblock+orig.


# # apply masks in standard space to individual space
# cd mask
# # 3dcalc -a APC+tlrc -b PPC+tlrc -expr 'a+b' -prefix Piriform+tlrc 
# # calculate inverse transform matrix
# cat_matvec ../${sub}.${analysis}.results/anat_final.${sub}.${analysis}.Xaff12.1D -I > ../${sub}.${analysis}.results/anat_final.${sub}.${analysis}.inv.1D

# foreach mask (`ls {APC,PPC,Amy,Piriform}+tlrc.HEAD`)
# # delete HEAD
# set name=`echo ${mask} | cut -d + -f1`
# 3dAllineate -input ${mask}                                                                                           \
#             -master ../${sub}.${analysis}.results/pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD                       \
#             -final NN                                                                                                \
#             -prefix ../${sub}.${analysis}.results/mvpamask/${name}.${sub}.mni                                           \
#             -1Dmatrix_apply ../${sub}.${analysis}.results/anat_final.${sub}.${analysis}.inv.1D

# # 3dNwarpApply cannot only apply affine transformation ?
# # 3dNwarpApply -nwarp ../${sub}.${analysis}.results/anat_final.${sub}.${analysis}.Xaff12.1D   \
# #              -source ${mask}                                                                      \
# #              -interp NN  -iwarp                                                                   \
# #              -master ../${sub}.${analysis}.results/pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
# #              -prefix ../${sub}.${analysis}.results/mvpamask/${name}+tlrc
# end

end
