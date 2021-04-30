#! /bin/csh
# use input as sub
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

# cat timing files
# foreach timing (lim car cit tra valence intensity odor_va)
#   cat ../S01_yyt/behavior/${timing}.txt behavior/${timing}.txt >! behavior_12run/${timing}.txt
#   cat ../S01_yyt/behavior/${timing}.txt behavior_5run/${timing}.txt >! behavior_11run/${timing}.txt
# end

# resample epi images (field view will be changed!!!)
# foreach run (1 2 3 4 5 6)
#   3dresample                                            \
#   -input 12blip/pb04.S01_yyt.pabiode.r0${run}.blip+orig \
#   -master 12blip/pb04.S01_yyt.pabiode.r12.blip+orig     \
#   -prefix pb04.S01_yyt.pabiode.r0${run}.bli
# end

# remove 6 slices to match 99
# foreach run (1 2 3 4 5 6)
#   3dZcutup \
#   -prefix 12blip/pb04.S01_yyt.pabiode.r0${run}.blip+orig \
#   -keep 3 101 \
#   ../S01_yyt/S01_yyt.pabiode.results/pb04.S01_yyt.pabiode.r0${run}.blip+orig
# end

# # cut T1 image to match 156 slices
# 3dZcutup \
#   -prefix 12blip/anat_final.S01_yyt.pabiode+orig \
#   -keep 0 155 \
#   ../S01_yyt/S01_yyt.pabiode.results/anat_final.S01_yyt.pabiode+orig
# # align two T1 images
# 3dvolreg -twopass -twodup -base S01.pabiode.results/anat_final.S01.pabiode+orig \
#   -prefix 12blip/reg2S01 12blip/anat_final.S01_yyt.pabiode+orig

foreach run (1 2 3 4 5 6) #
  # rotate to min_outlier
  3drotate -rotparent 12blip/reg2S01+orig -gridparent 12blip/vr_base_min_outlier+orig \
        -prefix 12blip/pb04.S01_yyt.pabiode.r0${run}.blip+orig \
        pb04.S01_yyt.pabiode.r0${run}.blip+orig
end

# rename epi images
# foreach run (1 2 3 4 5 6)
#   @ newrun = ${run} + 6
#   mv 12blip/pb04.S01.pabiode.r0${run}.blip+orig.BRIK 12blip/pb04.S01_yyt.pabiode.r0${newrun}.blip+orig.BRIK
#   mv 12blip/pb04.S01.pabiode.r0${run}.blip+orig.HEAD 12blip/pb04.S01_yyt.pabiode.r0${newrun}.blip+orig.HEAD
# end

else
  echo "Usage: $0 <Subjname>"
endif
