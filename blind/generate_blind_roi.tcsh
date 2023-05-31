#! /bin/csh

foreach ub (`count -dig 2 14 16`)
set sub=S${ub}
set analysis=pade

set datafolder=/Volumes/WD_F/gufei/blind/${sub}/
cd "${datafolder}"

cd ${sub}.${analysis}.results

# resample Piriform mask
3dresample  -input COPY_anat_final.${sub}.${analysis}+orig      \
            -master vr_base_min_outlier+orig               \
            -rmode NN                                           \
            -prefix Piriform.seg
# creat piriform mask and remove voxels in Amy
3dcalc -a Piriform.seg+orig -b Amy.freesurfer+orig -expr 'amongst(a,21,22,29)*iszero(b)' -prefix ../mask/Pir_new.draw+orig
# creat old piriform mask
3dcalc -a Piriform.seg+orig -b Amy.freesurfer+orig -expr 'amongst(a,21,22)*iszero(b)' -prefix ../mask/Pir_old.draw+orig
# create APC_new
3dcalc -a Piriform.seg+orig -b Amy.freesurfer+orig -expr 'amongst(a,21,29)*iszero(b)' -prefix ../mask/APC_new.draw+orig
# create APC_old
3dcalc -a Piriform.seg+orig -b Amy.freesurfer+orig -expr 'amongst(a,21)*iszero(b)' -prefix ../mask/APC_old.draw+orig
# creat PPC
3dcalc -a Piriform.seg+orig -b Amy.freesurfer+orig -expr 'amongst(a,22)*iszero(b)' -prefix ../mask/PPC.draw+orig
# move Piriform.seg to mask folder
mv Piriform.seg* ../mask

# normalize Anatomical img to mni space (linear warp)
@auto_tlrc -no_ss -init_xform AUTO_CENTER -maxite 500 -base ~/abin/MNI152_T1_2009c+tlrc. -input anat_final.${sub}.${analysis}+orig
# align to nomalized Anatomical img
@auto_tlrc -apar anat_final.${sub}.${analysis}+tlrc -input stats.${sub}.${analysis}+orig

# transform occipital mask
set mask=/Volumes/WD_F/gufei/blind/ProbAtlas_v4/subj_vol_all/maxprob_vol.nii
# affine warp
# rm visual_area+*
cat_matvec ./anat_final.${sub}.${analysis}.Xaff12.1D -I > ./anat_final.${sub}.${analysis}.inv.1D
3dAllineate -input ${mask}                                                  \
            -master ./pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD          \
            -final NN                                                       \
            -prefix ./visual_area                                           \
            -1Dmatrix_apply ./anat_final.${sub}.${analysis}.inv.1D
# nonlinear warp
# rm visual_area_nl+*
3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
             -source ${mask}                                                                      \
             -interp NN                                                               \
             -master pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
             -prefix visual_area_nl
# the -iwarp option is slower and may fail to converge
# 3dNwarpApply -iwarp -nwarp "anatQQ.${sub}_WARP.nii anatQQ.${sub}.aff12.1D INV(anatSS.${sub}_al_keep_mat.aff12.1D)"   \
#              -source ${mask}                                                                      \
#              -interp NN                                                               \
#              -master pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
#              -prefix visual_area_nl
# creat V1-V3
3dcalc -a visual_area_nl+orig -expr 'amongst(a,1,2)' -prefix ../mask/V1+orig
3dcalc -a visual_area_nl+orig -expr 'amongst(a,3,4)' -prefix ../mask/V2+orig
3dcalc -a visual_area_nl+orig -expr 'amongst(a,5,6)' -prefix ../mask/V3+orig
3dcalc -a visual_area_nl+orig -expr 'amongst(a,1,2,3,4,5,6)' -prefix ../mask/EarlyV+orig

end
