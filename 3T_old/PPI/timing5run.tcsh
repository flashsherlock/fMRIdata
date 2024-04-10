#! /bin/csh
set datafolder=/Volumes/WD_D/allsub
# 双引号避免空格路径问题
cd "${datafolder}"
cd timing
foreach file (`ls *{Visible,Invisible}.1D`)
  # 查看文件行数
  # cat ${file} | wc -l
  # 按行分割,196个TR一个run
  # use split to separate file
  split -l 196 ${file}

  # rename
  @ run=1
  set filename = `echo ${file} | cut -d '.' -f 1,2`
  foreach name (a b c d e)
    mv xa${name} ${filename}_run${run}.1D
    @ run++
  end

end

mv *_run?.1D ../timing5run/
