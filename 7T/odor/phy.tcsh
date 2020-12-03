#! /bin/csh
set sub=S01_yyt
set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

set imgdir=`ls -d *S40*`

# generate 1D files
# conda activate psychopy
# extract_physio.py                   \
# -p ./phy/                    \
# -d ./${imgdir}/           \
# -o ./phy/                    \
# -C resp puls                        \
# -f 10 12 14 16 18 20    \
# -m overlap                          \
# -M

# -m default is cover

cd ./phy

# 1dplot -xaxis 1:1000:10:10 puls01.1D

# use fMRI respiration
# foreach run (1 2 3 4 5 6)
#     RetroTS.py -r resp0${run}.1D -c puls0${run}.1D -p 50 -n 105 -v 3 -prefix ${sub}.run${run}
# end

# use fMRI respiration
foreach run (1 2 3 4 5 6)
    RetroTS.py -r biop0${run}.1D -c puls0${run}.1D -p 50 -n 105 -v 3 -prefix ${sub}.biop.run${run}
end
# -r: (respiration_file) Respiration data file
# -c: (cardiac_file) Cardiac data file
# -p: (phys_fs) Physiological signal sampling frequency in Hz.
# -n: (number_of_slices) Number of slices
# -v: (volume_tr) Volume TR in seconds