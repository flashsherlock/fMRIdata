#! /bin/csh

set datafolder=/Volumes/WD_D/share/7Tdata/phy
cd "${datafolder}"

RetroTS.py -r resp01.1D -c puls01.1D -p 50 -n 99 -v 3 -prefix gufei.run1
RetroTS.py -r resp02.1D -c puls02.1D -p 50 -n 50 -v 3 -prefix gufei.run3