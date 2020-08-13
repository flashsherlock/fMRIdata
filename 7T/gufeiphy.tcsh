#! /bin/csh

set datafolder=/Volumes/WD_D/share/7Tdata/phy
cd "${datafolder}"

# compare 1D files with/without -M option
cd mb
foreach file (`ls *.1D` )

diff --head=10 $file ../$file

end

# RetroTS.py -r resp01.1D -c puls01.1D -p 50 -n 99 -v 3 -prefix gufei.run1
# RetroTS.py -r resp02.1D -c puls02.1D -p 50 -n 50 -v 3 -prefix gufei.run3
# RetroTS.py -r resp03.1D -c puls03.1D -p 50 -n 45 -v 3 -prefix gufei.run4
# RetroTS.py -r resp04.1D -c puls04.1D -p 50 -n 99 -v 3 -prefix gufei.run5