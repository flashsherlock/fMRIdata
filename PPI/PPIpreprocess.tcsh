#! /bin/csh
#set datafolder=/Volumes/WD_D/allsub
set datafolder=/Volumes/WD_D/Exp_odor_face/fMRI\ data_supplemental/
# 双引号避免空格路径问题
cd "${datafolder}"

if ( $# > 0 ) then
# echo `echo "`seq -s , 1 3 20`"
# foreach subj (`echo $*`)
# foreach subj (`ls -d S*`)
# foreach subj (S03)
#S22 S23 S24 S25 S26 S27 S28
set subj = $1

cd *${subj}

mkdir ppi
# 移动过来需要的文件
mv analysis/FMRI.*_s+orig* ppi/
mv analysis/FMRI.*_mask+orig* ppi/
mv analysis/*.str_al+tlrc* ppi/

cd ppi

# 循环处理每个run
@ run=1
foreach scan (`ls FMRI.*_s+orig.HEAD | cut -c1-9`)

    echo ${scan}
    # apply mask on epi image
    3dcalc -a ${scan}_s+orig -b ${scan}_mask+orig -expr 'a*b' -prefix ${subj}_run${run}
    # align to stuctual image
    @auto_tlrc -apar ${subj}.str_al+tlrc. -input ${subj}_run${run}+orig
    # @ run++
    # @ run+=1
    # 上面两个都可以，下面这个运算符前后要有空格
    @ run=${run} + 1

end

# 把5run和mask和结构像放回原位
mv FMRI*+orig* ../analysis/
mv *.str_al+tlrc* ../analysis/

cd ..
cd ..


else
 echo "Usage: $0 <Subjname>"

endif
