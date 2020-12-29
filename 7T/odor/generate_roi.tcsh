#! /bin/csh

set sub=S01_yyt
set analysis=pabiode

set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

cd ${sub}.${analysis}.results

# 3dcalc -a APC.${sub}.${analysis}+orig -b PPC_Amy.${sub}.${analysis}+orig -expr 'a+b+notzero(b)' -prefix ${sub}.ROI

# iszero and not can be used to extract certain area
# 3dcalc -a ${sub}.ROI+orig -expr 'iszero(a-1)' -prefix APC.${sub}
# 3dcalc -a ${sub}.ROI+orig -expr 'iszero(a-2)' -prefix PPC.${sub}
# 3dcalc -a ${sub}.ROI+orig -expr 'iszero(a-3)' -prefix Amy.${sub}

# 3dcalc -a APC.${sub}+orig -b PPC.${sub}+orig -expr 'a+b' -prefix Piriform.${sub} 


# normalize to mni space
@auto_tlrc -no_ss -maxite 500 -base ~/abin/MNI152_T1_2009c+tlrc. -input anat_final.${sub}.${analysis}+orig
# -init_xform AUTO_CENTER


# foreach mask (`ls {APC,PPC,Amy,Piriform}.${sub}+orig.HEAD`)
#     # echo ${mask}
#     3dresample  -input ${mask}                       \
#                 -master pb07.${sub}.${analysis}.r01.scale+orig.HEAD      \
#                 -rmode NN                                \
#                 -prefix ./mvpamask/${mask}      
# end