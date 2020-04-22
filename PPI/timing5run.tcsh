#! /bin/csh
set datafolder=/Volumes/WD_D/allsub
# 双引号避免空格路径问题
cd "${datafolder}"
cd timing
foreach file (`ls *{Visible,Invisible}.1D`)
cat ${file} | wc -l
end
