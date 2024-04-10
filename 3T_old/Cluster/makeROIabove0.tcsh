#! /bin/csh
# if ( $# > 0 ) then
# t=1.64 正负显著激活的区域合在一起
# foreach subj (`echo $*`)
# foreach subj (S29)

set datafolder=/Volumes/WD_D/allsub
# set datafolder=/Volumes/WD_D/Exp_odor_face/fMRI\ data_supplemental/
cd "${datafolder}"
# 效价偏好的t值
set t=1.65
set tmark=t165
# 减数大于0的t值
set t0=1.96
set t0mark=t196

# mask的名称上标记了两个阈值，比如${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}
# txt结果的文件夹上标记了两个阈值，比如AmyAbove0${t0mark}${tmark}
# 每个人的txt文件上标记了两个阈值，比如${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}.txt
# 所有被试的txt文件上只标记了做差的阈值，这样之后的r程序就不需要修改多少了，比如20subj_OdorValence.lateralAmyUP.${tmark}.txt

if (! -e ana4/AmyAbove0${t0mark}${tmark}) then
mkdir ana4/AmyAbove0${t0mark}${tmark}
endif

foreach subj (`ls -d S*`)
#S22 S23 S24 S25 S26 S27 S28

cd ${subj}

cd analysis

# 减数大于0的mask
# 38F0 41H0 44P0 47U0
# if (! -e ${subj}.FaceValenceF0.${t0mark}*.BRIK) then
#
# 3dcalc -a ${subj}.analysis.+tlrc'[38]' -expr 'step(a-${t0})' -prefix ${subj}.FaceValenceF0.${t0mark}
# 3dcalc -a ${subj}.analysis.+tlrc'[41]' -expr 'step(a-${t0})' -prefix ${subj}.FaceValenceH0.${t0mark}
# 3dcalc -a ${subj}.analysis.+tlrc'[44]' -expr 'step(a-${t0})' -prefix ${subj}.OdorValenceP0.${t0mark}
# 3dcalc -a ${subj}.analysis.+tlrc'[47]' -expr 'step(a-${t0})' -prefix ${subj}.OdorValenceU0.${t0mark}
#
# endif

#两个mask相交
# 38F0 41H0 44P0 47U0
set expr="(step(c-${t0}))*b*(step(a-${t}))"
set expr_r="(step(c-${t0}))*b*(step(-a-${t}))"

# mask rename-----------------------------------------------------------
# foreach file (`ls ${subj}.*Ab0.*.t*`)
#   set newname=`echo "${file}" | awk 'BEGIN { FS="." ; OFS="." } {print $1,$2 "t196",$3,$4,$5 }'`
#   # echo "${newname}"
#   mv ${file} ${newname}
# end
# # BRIK文件应该是.gz结尾的
# foreach file (`ls ${subj}.*Ab0*.t*.BRIK`)
#   set newname=${file}.gz
#   # echo "${newname}"
#   mv ${file} ${newname}
# end
# ls ${subj}.*Ab0*.t*
# ----------------------------------------------------------------------

# 使用双引号在表达式中应用变量
3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/lAmyg+tlrc -c ${subj}.analysis.+tlrc'[47]' -expr "${expr}" -prefix ${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/mAmyg+tlrc -c ${subj}.analysis.+tlrc'[47]' -expr "${expr}" -prefix ${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/BN_Amyg+tlrc -c ${subj}.analysis.+tlrc'[47]' -expr "${expr}" -prefix ${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}

3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/lAmyg+tlrc -c ${subj}.analysis.+tlrc'[38]' -expr "${expr}" -prefix ${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/mAmyg+tlrc -c ${subj}.analysis.+tlrc'[38]' -expr "${expr}" -prefix ${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/BN_Amyg+tlrc -c ${subj}.analysis.+tlrc'[38]' -expr "${expr}" -prefix ${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}

#reverse 偏好相反的
3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/lAmyg+tlrc -c ${subj}.analysis.+tlrc'[44]' -expr "${expr_r}" -prefix ${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/mAmyg+tlrc -c ${subj}.analysis.+tlrc'[44]' -expr "${expr_r}" -prefix ${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[32]' -b ../../BN_atlas/BN_Amyg+tlrc -c ${subj}.analysis.+tlrc'[44]' -expr "${expr_r}" -prefix ${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}

3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/lAmyg+tlrc -c ${subj}.analysis.+tlrc'[41]' -expr "${expr_r}" -prefix ${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/mAmyg+tlrc -c ${subj}.analysis.+tlrc'[41]' -expr "${expr_r}" -prefix ${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}
3dcalc -a ${subj}.analysis.+tlrc'[35]' -b ../../BN_atlas/BN_Amyg+tlrc -c ${subj}.analysis.+tlrc'[41]' -expr "${expr_r}" -prefix ${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}

3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${t0mark}${tmark}/${subj}.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${t0mark}${tmark}/${subj}.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${t0mark}${tmark}/${subj}.OdorValenceAb0${t0mark}.AmyPU.${tmark}.txt

3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${t0mark}${tmark}/${subj}.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${t0mark}${tmark}/${subj}.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${t0mark}${tmark}/${subj}.FaceValenceAb0${t0mark}.AmyHF.${tmark}.txt
##################

3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${t0mark}${tmark}/${subj}.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${t0mark}${tmark}/${subj}.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}.txt
3dROIstats -mask ${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${t0mark}${tmark}/${subj}.OdorValenceAb0${t0mark}.AmyUP.${tmark}.txt

3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${t0mark}${tmark}/${subj}.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${t0mark}${tmark}/${subj}.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}.txt
3dROIstats -mask ${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}+tlrc -nzmean -nzvoxels ${subj}.analysis.+tlrc'[1,4,7,10,13,16,19,22]' >! ../../ana4/AmyAbove0${t0mark}${tmark}/${subj}.FaceValenceAb0${t0mark}.AmyFH.${tmark}.txt


cd ..
cd ..

end

cd ana4/AmyAbove0${t0mark}${tmark}

cat *.OdorValenceAb0${t0mark}.lateralAmyUP.${tmark}.txt >! 20subj_OdorValence.lateralAmyUP.${tmark}.txt
cat *.OdorValenceAb0${t0mark}.medialAmyUP.${tmark}.txt >! 20subj_OdorValence.medialAmyUP.${tmark}.txt
cat *.OdorValenceAb0${t0mark}.AmyUP.${tmark}.txt >! 20subj_OdorValence.AmyUP.${tmark}.txt

cat *.FaceValenceAb0${t0mark}.lateralAmyFH.${tmark}.txt >! 20subj_FaceValence.lateralAmyFH.${tmark}.txt
cat *.FaceValenceAb0${t0mark}.medialAmyFH.${tmark}.txt >! 20subj_FaceValence.medialAmyFH.${tmark}.txt
cat *.FaceValenceAb0${t0mark}.AmyFH.${tmark}.txt >! 20subj_FaceValence.AmyFH.${tmark}.txt

cat *.OdorValenceAb0${t0mark}.lateralAmyPU.${tmark}.txt >! 20subj_OdorValence.lateralAmyPU.${tmark}.txt
cat *.OdorValenceAb0${t0mark}.medialAmyPU.${tmark}.txt >! 20subj_OdorValence.medialAmyPU.${tmark}.txt
cat *.OdorValenceAb0${t0mark}.AmyPU.${tmark}.txt >! 20subj_OdorValence.AmyPU.${tmark}.txt

cat *.FaceValenceAb0${t0mark}.lateralAmyHF.${tmark}.txt >! 20subj_FaceValence.lateralAmyHF.${tmark}.txt
cat *.FaceValenceAb0${t0mark}.medialAmyHF.${tmark}.txt >! 20subj_FaceValence.medialAmyHF.${tmark}.txt
cat *.FaceValenceAb0${t0mark}.AmyHF.${tmark}.txt >! 20subj_FaceValence.AmyHF.${tmark}.txt

# else
 # echo "Usage: $0 <Subjname>"

# endif
