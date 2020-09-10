#! /bin/csh
set subj=gufei.run1.paphde
set datafolder=/Volumes/WD_D/share/7T/${subj}.results
cd "${datafolder}"

if (! -e mvpa) then
    mkdir mvpa
    mkdir mvpa/output
endif

set dset = pb05.${subj}.r01.volreg+orig.HEAD
set pref = tr_
@ nv = `3dnvals $dset` - 1

foreach kk ( `count -dig 3 0 $nv` )
# kk是从零开始的，保存的文件名称中的brik是从1开始的
    @ brik = $kk + 1
    3dbucket -prefix ./mvpa/${pref}${brik} ${dset}"[$kk]"
end
