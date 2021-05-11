#! /bin/csh
foreach sub (S01_yyt S01 S02 S03)
# set sub=S01_yyt
set analysis=pabiode

set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}/
cd "${datafolder}"

cd ${sub}.${analysis}.results

# resample Piriform mask
3dresample  -input COPY_anat_final.${sub}.${analysis}+orig      \
            -master stats.${sub}.${analysis}+orig               \
            -rmode NN                                           \
            -prefix Piriform.seg
# creat piriform mask
3dcalc -a Piriform.seg+orig -expr 'amongst(a,21,22,29)' -prefix ../mask/Pir_new.draw+orig
# creat old piriform mask
3dcalc -a Piriform.seg+orig -expr 'amongst(a,21,22)' -prefix ../mask/Pir_old.draw+orig
# create APC_new
3dcalc -a Piriform.seg+orig -expr 'amongst(a,21,29)' -prefix ../mask/APC_new.draw+orig
# create APC_old
3dcalc -a Piriform.seg+orig -expr 'amongst(a,21)' -prefix ../mask/APC_old.draw+orig
# creat PPC
3dcalc -a Piriform.seg+orig -expr 'amongst(a,22)' -prefix ../mask/PPC.draw+orig




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
