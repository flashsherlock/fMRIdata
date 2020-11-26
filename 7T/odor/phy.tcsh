#! /bin/csh

set datafolder=/Volumes/WD_D/share
cd "${datafolder}"

# generate 1D files
# extract_physio.py                   \
# -p ./7Tdata/S40/                    \
# -d ./20200811_S40_TEST02/           \
# -o ./7Tdata/phy/                    \
# -C resp puls                        \
# -f 10 12 13 15 17 19 21 22 23 25    \
# -m overlap                          \
# -M

# run2 has broken resp file, but puls can be used
# extract_physio.py                   \
# -p ./7Tdata/S40                     \
# -d ./20200811_S40_TEST02/           \
# -o ./7Tdata/phy/test                \
# -C puls                             \
# -f 12                               \
# -m overlap                          \
# -M

# cd ./7Tdata/phy

# # compare 1D files with/without -M option
# cd mb
# foreach file (`ls *.1D` )

# diff --head=10 $file ../$file

# end

# RetroTS.py -r resp01.1D -c puls01.1D -p 50 -n 99 -v 3 -prefix gufei.run1
# RetroTS.py -c puls01.1D -p 50 -n 100 -v 3 -prefix gufei.run2
# RetroTS.py -r resp02.1D -c puls02.1D -p 50 -n 50 -v 3 -prefix gufei.run3
# RetroTS.py -r resp03.1D -c puls03.1D -p 50 -n 45 -v 3 -prefix gufei.run4
# RetroTS.py -r resp04.1D -c puls04.1D -p 50 -n 99 -v 3 -prefix gufei.run5