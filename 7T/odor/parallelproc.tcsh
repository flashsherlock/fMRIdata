#! /bin/csh
# set datafolder=/Volumes/WD_D/allsub/
# cd "${datafolder}"

touch command.txt
# 清空之后文件大小为1
# echo >! command.txt
# 清空之后文件大小为0
cat /dev/null >! command.txt

foreach run (`count -dig 2 29 34`)
  echo tcsh deconvolve_REML.tcsh S${run} >> command.txt
end
# cat command.txt

parallel -a command.txt

rm command.txt
