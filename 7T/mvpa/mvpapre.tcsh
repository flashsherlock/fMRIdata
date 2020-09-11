#! /bin/csh
# 复制结构像
foreach num (2)

    set run=run${num}
    set subj=gufei.${run}.pa
    set datafolder=/Volumes/WD_D/share/7T/${subj}.results
    cd "${datafolder}"

    3dcopy anat_final.${subj}+orig ../../7Tdata/mvpa/${run}/${run}

end

# 建立文件夹并且保存每个TR的图像
# 因为可以直接读取不同的时间点，所以不再需要
# if (! -e mvpa) then
#     mkdir mvpa
#     mkdir mvpa/output
# endif

# set dset = pb05.${subj}.r01.volreg+orig.HEAD
# set pref = tr_
# @ nv = `3dnvals $dset` - 1

# foreach kk ( `count -dig 3 0 $nv` )
# # kk是从零开始的，保存的文件名称中的brik是从1开始的
#     @ brik = $kk + 1
#     3dbucket -prefix ./mvpa/${pref}${brik} ${dset}"[$kk]"
# end
