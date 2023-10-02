#! /bin/csh

# OFC mask from AAL
# 3dcalc \
# -a /Volumes/WD_F/gufei/3T_cw/aal/aal.nii.gz \
# -expr 'amongst(a,5,6,9,10,15,16,25,26,27,28)' \
# -prefix /Volumes/WD_F/gufei/3T_cw/aal/ofc_aal
# 3dresample \
# -master /Volumes/WD_F/gufei/3T_cw/group/MNI152_T1_2009c+tlrc \
# -prefix /Volumes/WD_F/gufei/3T_cw/group/mask/OFC_AAL \
# -input /Volumes/WD_F/gufei/3T_cw/aal/ofc_aal+tlrc

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

# OFC
set mask=/Volumes/WD_F/gufei/3T_cw/group/mask/OFC_AAL+tlrc
# nonlinear warp
3dNwarpApply -nwarp "anatSS.${sub}_al_keep_mat.aff12.1D INV(anatQQ.${sub}.aff12.1D) INV(anatQQ.${sub}_WARP.nii)"   \
             -source ${mask}                                                                      \
             -interp NN                                                               \
             -master pb0?.${sub}.${analysis}.r01.volreg+orig.HEAD    \
             -prefix ../mask/OFC_AAL
end
