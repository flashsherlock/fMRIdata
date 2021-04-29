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

# resample epi images 
foreach run (2 3 4 5 6)
  3dresample                                            \
  -input 12blip/pb04.S01_yyt.pabiode.r0${run}.blip+orig \
  -master 12blip/pb04.S01_yyt.pabiode.r12.blip+orig     \
  -prefix pb04.S01_yyt.pabiode.r0${run}.bli
end
# rename epi images
foreach run (2 3 4 5 6)
  mv pb04.S01_yyt.pabiode.r0${run}.bli+orig.BRIK pb04.S01_yyt.pabiode.r0${run}.blip+orig.BRIK
  mv pb04.S01_yyt.pabiode.r0${run}.bli+orig.HEAD pb04.S01_yyt.pabiode.r0${run}.blip+orig.HEAD
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
