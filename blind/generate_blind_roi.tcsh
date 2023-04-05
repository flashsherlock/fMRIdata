#! /bin/csh

foreach ub (`count -dig 2 1 4`)
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

end
