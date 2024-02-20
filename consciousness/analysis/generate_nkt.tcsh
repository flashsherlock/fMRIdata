#! /bin/csh
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_D/gufei/consciousness/NKTdata
cd "${datafolder}"

cd *${sub}

# change file flag
# http://zhengyi.me/2016/06/02/learning-shell-chflags/
chflags -R nouchg ./
# make directory and move all files to the directory ./NKT/EEG2100
mkdir -p ./NKT/EEG2100
mv * ./NKT/EEG2100

else
 echo "Usage: $0 <Subjfolder>"

endif
