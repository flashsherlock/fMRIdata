#! /bin/csh
# set sub=S01_yyt
# foreach sub (S01 S02 S03)
# use input as sub
if ( $# > 0 ) then
set sub = $1
# set sub = S01
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
set rawfolder=/Volumes/WD_E/gufei/7T_odor/phy_raw/2021*${sub}
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
cd "${rawfolder}"
# set imgdir=`ls -d *S40*`
# copy resp and pulse to phy
# cp *.resp ${datafolder}/phy/
# cp *.puls ${datafolder}/phy/

cd "${datafolder}"
set imgdir=`ls -d *S40*`

# generate 1D files
conda activate psychopy
sleep 2
extract_physio.py                   \
-p ./phy/                    \
-d ./${imgdir}/           \
-o ./phy/                    \
-C resp puls                        \
-f $2                           \
-m overlap                          \
-M
conda deactivate
sleep 2
# -m default is cover

# get number of slices
set slices = `3dinfo ${sub}.run1+orig.HEAD | grep "Number time-offset slices =" | cut -d " " -f 21`
# echo ${slices}
cd ./phy

# 1dplot -xaxis 1:1000:10:10 puls01.1D

# use fMRI respiration
foreach run (1 2 3 4 5 6)
    RetroTS.py -r resp0${run}.1D -c puls0${run}.1D -p 50 -n ${slices} -v 3 -prefix ${sub}.run${run}
end

# use fMRI respiration
foreach run (1 2 3 4 5 6)
    RetroTS.py -r biop0${run}.1D -c puls0${run}.1D -p 50 -n ${slices} -v 3 -prefix ${sub}.biop.run${run}
end
# -r: (respiration_file) Respiration data file
# -c: (cardiac_file) Cardiac data file
# -p: (phys_fs) Physiological signal sampling frequency in Hz.
# -n: (number_of_slices) Number of slices
# -v: (volume_tr) Volume TR in seconds

echo "Number time-offset slices: ${slices}"

else

echo "Usage: $0 <Subjname> <runs>"

endif
