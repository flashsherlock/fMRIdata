#! /bin/csh
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_D/gufei/consciousness/NKTdata
cd "${datafolder}"

cd ${sub}

# change file flag
# http://zhengyi.me/2016/06/02/learning-shell-chflags/
chflags -R nouchg ./

else
 echo "Usage: $0 <Subjfolder>"

endif
