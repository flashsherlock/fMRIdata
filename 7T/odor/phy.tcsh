#! /bin/csh
# set sub=S01_yyt
# foreach sub (S01 S02 S03)
# use input as sub
if ( $# > 0 ) then
set sub = $1
# set rootfolder=/Volumes/WD_D/gufei/7T_odor
set rootfolder=/Volumes/WD_F/gufei/7T_odor
set rawfolder=${rootfolder}/phy_raw/202*${sub}
set datafolder=${rootfolder}/${sub}
cd "${rawfolder}"

# copy resp and pulse to phy
cp *.resp ${datafolder}/phy/
cp *.puls ${datafolder}/phy/

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

# check resp and puls length
# standard
set length=`cat biop01.1D | wc -l `
# echo $length

foreach run (1 2 3 4 5 6)
    # resp
    set cur_l=`cat resp0${run}.1D | wc -l`
    @ d = ${length} - ${cur_l}
    # duplicate the last line if not long enough
    if (${d} > 0) then
        foreach dd (`count -dig 1 1 $d`)
            echo `tail -n 1 resp0${run}.1D` >> resp0${run}.1D
        end
    # delete lines if too long
    else
        if (${d} < 0) then
            head -n ${length} resp0${run}.1D > tmp.txt
            # replace the original file (>! does not work)
            mv tmp.txt resp0${run}.1D
        endif
    endif
    # pulse
    set cur_l=`cat puls0${run}.1D | wc -l`
    @ d = ${length} - ${cur_l}
    if (${d} > 0) then
        foreach dd (`count -dig 1 1 $d`)
            echo `tail -n 1 puls0${run}.1D` >> puls0${run}.1D
        end
    else
        if (${d} < 0) then
            head -n ${length} puls0${run}.1D > tmp.txt
            mv tmp.txt puls0${run}.1D
        endif
    endif
end

# use fMRI respiration
foreach run (1 2 3 4 5 6)
    RetroTS.py -r resp0${run}.1D -c puls0${run}.1D -p 50 -n ${slices} -v 3 -prefix ${sub}.run${run}
end

# use biopac respiration
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
