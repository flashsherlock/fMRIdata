#! /bin/csh

set sub=S01_yyt
set analysis=pade

set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

cd ${sub}.${analysis}.results

# apply masks to stats
cd mvpamask
foreach mask (corticalAmy corticalAmy_align Amy_9seg Amy_align9seg)
    3dcalc -a ../stats.${sub}.${analysis}.odorVI+orig -b ${mask}.freesurfer+orig -expr 'a*b' -prefix ../stats_mask.${mask}
end
# 3dcalc -a APC.${sub}.${analysis}+orig -b PPC_Amy.${sub}.${analysis}+orig -expr 'a+b+notzero(b)' -prefix ${sub}.ROI

# iszero and not can be used to extract certain area
# 3dcalc -a ${sub}.ROI+orig -expr 'iszero(a-1)' -prefix APC.${sub}
# 3dcalc -a ${sub}.ROI+orig -expr 'iszero(a-2)' -prefix PPC.${sub}
# 3dcalc -a ${sub}.ROI+orig -expr 'iszero(a-3)' -prefix Amy.${sub}

# 3dcalc -a APC.${sub}+orig -b PPC.${sub}+orig -expr 'a+b' -prefix Piriform.${sub} 

# foreach mask (`ls {APC,PPC,Amy,Piriform}.${sub}+orig.HEAD`)
#     # echo ${mask}
#     3dresample  -input ${mask}                       \
#                 -master pb07.${sub}.${analysis}.r01.scale+orig.HEAD      \
#                 -rmode NN                                \
#                 -prefix ./mvpamask/${mask}      
# end

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

