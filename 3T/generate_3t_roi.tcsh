#! /bin/csh

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
set roidir=/Volumes/Ventoy/roi/${subnum}
3dcalc \
-a ${roidir}/lapc.nii \
-b ${roidir}/rapc.nii \
-c ${roidir}/lppc.nii \
-d ${roidir}/rppc.nii \
-e ${roidir}/lapc_n.nii \
-f ${roidir}/rapc_n.nii \
-expr '21*(a+b)+22*(c+d)+29*(e+f)' \
-prefix  COPY_anat_final.${sub}.${analysis}
# resample
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

end
