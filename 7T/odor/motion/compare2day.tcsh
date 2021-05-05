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

# rotate S01_yyt to S01 blured results
3drotate -rotparent 12blip/reg2S01+orig \
  -gridparent S01.pabiode.results/stats.S01.pabiode.odorVIva+orig \
  -prefix 12blip/stats.S01_yyt.pabiode.odorVIva+orig \
  ../S01_yyt/S01_yyt.pabiode.results/stats.S01_yyt.pabiode.odorVIva+orig
# no blur
3drotate -rotparent 12blip/reg2S01_noblur+orig \
  -gridparent S01.pabiode.results/NIerrts.S01.pabiode.odorVIva_noblur+orig \
  -prefix 12blip/NIerrts.S01_yyt.pabiode.odorVIva_noblur+orig \
  ../S01_yyt/S01_yyt.pabiode.results/NIerrts.S01_yyt.pabiode.odorVIva_noblur+orig

set maskdec = align # at165 or align
set data_beta = 12blip/NIerrts.S01_yyt.pabiode.odorVIva_noblur+orig

foreach region (Amy9 corticalAmy CeMeAmy BaLaAmy)
  # extract betas from blurred statas
  3dROIstats -mask mask/${region}_${maskdec}.freesurfer+orig \
  -nzmean ${data_beta}"[`seq -s , 1 3 9`10]" >! 12blip/S01_yyt_${region}_${maskdec}_beta.txt
end

foreach region (1 3 5 6 7 8 9 10 15)
  3dROIstats -mask mask/Amy_${maskdec}${region}seg.freesurfer+orig \
  -nzmean ${data_beta}"[`seq -s , 1 3 9`10]" >! 12blip/S01_yyt_${maskdec}${region}seg_beta.txt
end

else
  echo "Usage: $0 <Subjname>"
endif
