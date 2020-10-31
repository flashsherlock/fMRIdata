#! /bin/csh
set datafolder=/Volumes/WD_D/gufei/7T
# set datafolder=/Volumes/WD_D/share/7T/
cd "${datafolder}"

touch command.txt
# 清空之后文件大小为1
# echo >! command.txt
# 清空之后文件大小为0
cat /dev/null >! command.txt

foreach run (1 2 3 4 5)
  echo "tcsh -xef proc.gufei.run${run}.pade 2>&1 | tee output.proc.gufei.run${run}.pade" >> command.txt
end
# cat command.txt

parallel -a command.txt

rm command.txt
