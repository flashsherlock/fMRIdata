#! /bin/csh
# use input as sub
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

# align two T1 images
3dvolreg -twopass -twodup -base S01.pabiode.results/anat_final.S01.pabiode+orig \
  -prefix 12blip/reg2S01 12blip/anat_final.S01_yyt.pabiode+orig

# rotate S01_yyt to S01
3drotate -rotparent 12blip/reg2S01+orig \
  -gridparent S01.pabiode.results/stats.S01.pabiode.odorVIva+orig \
  -prefix 12blip/stats.S01_yyt.pabiode.odorVIva+orig \
  ../S01_yyt/S01_yyt.pabiode.results/stats.S01_yyt.pabiode.odorVIva+orig

else
  echo "Usage: $0 <Subjname>"
endif
