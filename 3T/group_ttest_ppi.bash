#! /bin/bash

datafolder=/Volumes/WD_F/gufei/3T_cw
# datafolder=/Volumes/WD_D/allsub/
cd "${datafolder}" || exit

# check $1, if is whole, use bmask.nii as mask
if [ "$1" = "whole" ]; then
      mask=group/mask/bmask.nii
      out=whole
else
      mask=group/mask/Amy8_align.freesurfer+tlrc
      out=Amy
fi

suffix=de.new
outsuffix=${out}new

# for each condition
for brick in vi coin coin_vis coin_inv
do
# swithch brick
case ${brick} in
      vi)
            bricknum=79
            ;;
      coin)
            bricknum=52
            ;;
      coin_vis)
            bricknum=55
            ;;
      coin_inv)
            bricknum=58
            ;;
esac
3dttest++ -prefix group/ppi/ttest_${brick}_${outsuffix}                    \
          -mask ${mask}                                            \
          -setA all                                                \
                01 "S03/S03.de.results/ppi.S03.${suffix}+tlrc[${bricknum}]" \
                02 "S04/S04.de.results/ppi.S04.${suffix}+tlrc[${bricknum}]" \
                03 "S05/S05.de.results/ppi.S05.${suffix}+tlrc[${bricknum}]" \
                04 "S06/S06.de.results/ppi.S06.${suffix}+tlrc[${bricknum}]" \
                05 "S07/S07.de.results/ppi.S07.${suffix}+tlrc[${bricknum}]" \
                06 "S08/S08.de.results/ppi.S08.${suffix}+tlrc[${bricknum}]" \
                07 "S09/S09.de.results/ppi.S09.${suffix}+tlrc[${bricknum}]" \
                08 "S10/S10.de.results/ppi.S10.${suffix}+tlrc[${bricknum}]" \
                09 "S11/S11.de.results/ppi.S11.${suffix}+tlrc[${bricknum}]" \
                10 "S12/S12.de.results/ppi.S12.${suffix}+tlrc[${bricknum}]" \
                11 "S13/S13.de.results/ppi.S13.${suffix}+tlrc[${bricknum}]" \
                12 "S14/S14.de.results/ppi.S14.${suffix}+tlrc[${bricknum}]" \
                13 "S15/S15.de.results/ppi.S15.${suffix}+tlrc[${bricknum}]" \
                14 "S16/S16.de.results/ppi.S16.${suffix}+tlrc[${bricknum}]" \
                15 "S17/S17.de.results/ppi.S17.${suffix}+tlrc[${bricknum}]" \
                16 "S18/S18.de.results/ppi.S18.${suffix}+tlrc[${bricknum}]" \
                17 "S19/S19.de.results/ppi.S19.${suffix}+tlrc[${bricknum}]" \
                18 "S20/S20.de.results/ppi.S20.${suffix}+tlrc[${bricknum}]" \
                19 "S21/S21.de.results/ppi.S21.${suffix}+tlrc[${bricknum}]" \
                20 "S22/S22.de.results/ppi.S22.${suffix}+tlrc[${bricknum}]" \
                21 "S23/S23.de.results/ppi.S23.${suffix}+tlrc[${bricknum}]" \
                22 "S24/S24.de.results/ppi.S24.${suffix}+tlrc[${bricknum}]" \
                23 "S25/S25.de.results/ppi.S25.${suffix}+tlrc[${bricknum}]" \
                24 "S26/S26.de.results/ppi.S26.${suffix}+tlrc[${bricknum}]" \
                25 "S27/S27.de.results/ppi.S27.${suffix}+tlrc[${bricknum}]" \
                26 "S28/S28.de.results/ppi.S28.${suffix}+tlrc[${bricknum}]" \
                27 "S29/S29.de.results/ppi.S29.${suffix}+tlrc[${bricknum}]"
done
# # 8 conditions
# # if ttest results exists, delete it
# if [ -f  group/ttest_8con_${outsuffix}+tlrc.HEAD ]; then
#       rm  group/ttest_8con_${outsuffix}+tlrc*
# fi
# 3dttest++ -prefix group/ttest_8con_${outsuffix}                    \
#           -mask ${mask}                                            \
#           -setA all                                                \
#                 01 "S03/S03.de.results/ppi.S03.${suffix}+tlrc[82]" \
#                 02 "S04/S04.de.results/ppi.S04.${suffix}+tlrc[82]" \
#                 03 "S05/S05.de.results/ppi.S05.${suffix}+tlrc[82]" \
#                 04 "S06/S06.de.results/ppi.S06.${suffix}+tlrc[82]" \
#                 05 "S07/S07.de.results/ppi.S07.${suffix}+tlrc[82]" \
#                 06 "S08/S08.de.results/ppi.S08.${suffix}+tlrc[82]" \
#                 07 "S09/S09.de.results/ppi.S09.${suffix}+tlrc[82]" \
#                 08 "S10/S10.de.results/ppi.S10.${suffix}+tlrc[82]" \
#                 09 "S11/S11.de.results/ppi.S11.${suffix}+tlrc[82]" \
#                 10 "S12/S12.de.results/ppi.S12.${suffix}+tlrc[82]" \
#                 11 "S13/S13.de.results/ppi.S13.${suffix}+tlrc[82]" \
#                 12 "S14/S14.de.results/ppi.S14.${suffix}+tlrc[82]" \
#                 13 "S15/S15.de.results/ppi.S15.${suffix}+tlrc[82]" \
#                 14 "S16/S16.de.results/ppi.S16.${suffix}+tlrc[82]" \
#                 15 "S17/S17.de.results/ppi.S17.${suffix}+tlrc[82]" \
#                 16 "S18/S18.de.results/ppi.S18.${suffix}+tlrc[82]" \
#                 17 "S19/S19.de.results/ppi.S19.${suffix}+tlrc[82]" \
#                 18 "S20/S20.de.results/ppi.S20.${suffix}+tlrc[82]" \
#                 19 "S21/S21.de.results/ppi.S21.${suffix}+tlrc[82]" \
#                 20 "S22/S22.de.results/ppi.S22.${suffix}+tlrc[82]" \
#                 21 "S23/S23.de.results/ppi.S23.${suffix}+tlrc[82]" \
#                 22 "S24/S24.de.results/ppi.S24.${suffix}+tlrc[82]" \
#                 23 "S25/S25.de.results/ppi.S25.${suffix}+tlrc[82]" \
#                 24 "S26/S26.de.results/ppi.S26.${suffix}+tlrc[82]" \
#                 25 "S27/S27.de.results/ppi.S27.${suffix}+tlrc[82]" \
#                 26 "S28/S28.de.results/ppi.S28.${suffix}+tlrc[82]" \
#                 27 "S29/S29.de.results/ppi.S29.${suffix}+tlrc[82]"
