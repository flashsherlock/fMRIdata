#! /bin/csh
# 将roi的mask变换
foreach num (2)

    set run=run${num}
    set subj=gufei.${run}.pa
    set datafolder=/Volumes/WD_D/share/7T/${subj}.results
    cd "${datafolder}"
    rm testamy*

    # 测试匹配，使用时一定要制定.HEAD，不然会因为两个匹配出错
    # ls pb0?.${subj}.r01.volreg+orig*

    # 对于整数的数据-final使用NN来避免插值
    # -master 用来改变输出的grid
    3dAllineate -input ../roitest.nii.gz                       \
                -master pb0?.${subj}.r01.volreg+orig.HEAD      \
                -final NN                                \
                -prefix testamy                             \
                -1Dmatrix_apply gufei.uniden15_brain_al_keep_mat.aff12.1D

end