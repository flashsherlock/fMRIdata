#! /bin/csh
# set datafolder=/Volumes/WD_D/allsub/
# cd "${datafolder}"

touch command.txt
# 清空之后文件大小为1
# echo >! command.txt
# 清空之后文件大小为0
cat /dev/null >! command.txt

foreach run (`seq -s ' ' 3 6`)
  echo tcsh deconvolve_run.tcsh ${run} >> command.txt
end
# cat command.txt

parallel -a command.txt

rm command.txt
