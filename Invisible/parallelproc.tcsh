#! /bin/csh
set datafolder=/Volumes/WD_D/allsub/
# set datafolder=/Volumes/WD_D/Exp_odor_face/fMRI\ data_supplemental/

touch command.txt
# 清空之后文件大小为1
# echo >! command.txt
# 清空之后文件大小为0
cat /dev/null >! command.txt

foreach subj (`ls -d "${datafolder}"S* |rev| cut -d '/' -f 1 |rev`)
  echo tcsh 3Deconvolve.tcsh ${subj} >> command.txt
end
# cat command.txt

parallel -a command.txt

rm command.txt
