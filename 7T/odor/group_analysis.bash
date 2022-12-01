#! /bin/bash

# datafolder=/Volumes/WD_E/gufei/7T_odor
datafolder=/Volumes/WD_F/gufei/7T_odor
cd "${datafolder}" || exit
stats=stats
# mask=group/mask/Amy8_align.freesurfer+tlrc
mask=group/mask/allROI+tlrc
# count
# check sub brick
# skip 12 24 36 ...
# count -skipnmodm 0 12 -dig 2 4 18
# for ub in $(count -dig 2 4 11) $(count -dig 2 13 18)
# do
#     sub=S${ub}
#     cd "${sub}" || exit    
#     analysis=pabiode
#     subj=${sub}.${analysis}
#     # rm -r ${sub}.pabioe2a.results
#     cd "${subj}".results || exit
#     3dinfo -subbrick_info "${stats}.${subj}.odorVI+tlrc[31]"
#     cd ../..
# done
# cd "${datafolder}" || exit

# 3dttest for subs 4-34
3dttest++ -prefix group/${stats}_car-lim                                       \
          -mask ${mask}                                      \
          -setA car-lim                                               \
                01 "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[31]" \
                02 "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[31]" \
                03 "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[31]" \
                04 "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[31]" \
                05 "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[31]" \
                06 "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[31]" \
                07 "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[31]" \
                08 "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[31]" \
                09 "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[31]" \
                10 "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[31]" \
                11 "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[31]" \
                12 "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[31]" \
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[31]" \
                14 "S19/S19.pabiode.results/${stats}.S19.pabiode.odorVI+tlrc[31]" \
                15 "S20/S20.pabiode.results/${stats}.S20.pabiode.odorVI+tlrc[31]" \
                16 "S21/S21.pabiode.results/${stats}.S21.pabiode.odorVI+tlrc[31]" \
                17 "S22/S22.pabiode.results/${stats}.S22.pabiode.odorVI+tlrc[31]" \
                18 "S23/S23.pabiode.results/${stats}.S23.pabiode.odorVI+tlrc[31]" \
                19 "S24/S24.pabiode.results/${stats}.S24.pabiode.odorVI+tlrc[31]" \
                20 "S25/S25.pabiode.results/${stats}.S25.pabiode.odorVI+tlrc[31]" \
                21 "S26/S26.pabiode.results/${stats}.S26.pabiode.odorVI+tlrc[31]" \
                22 "S27/S27.pabiode.results/${stats}.S27.pabiode.odorVI+tlrc[31]" \
                23 "S28/S28.pabiode.results/${stats}.S28.pabiode.odorVI+tlrc[31]" \
                24 "S29/S29.pabiode.results/${stats}.S29.pabiode.odorVI+tlrc[31]" \
                25 "S31/S31.pabiode.results/${stats}.S31.pabiode.odorVI+tlrc[31]" \
                26 "S32/S32.pabiode.results/${stats}.S32.pabiode.odorVI+tlrc[31]" \
                27 "S33/S33.pabiode.results/${stats}.S33.pabiode.odorVI+tlrc[31]" \
                28 "S34/S34.pabiode.results/${stats}.S34.pabiode.odorVI+tlrc[31]"

3dttest++ -prefix group/${stats}_cit-lim                                       \
          -mask ${mask}                                      \
          -setA cit-lim                                               \
                01 "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[34]" \
                02 "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[34]" \
                03 "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[34]" \
                04 "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[34]" \
                05 "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[34]" \
                06 "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[34]" \
                07 "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[34]" \
                08 "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[34]" \
                09 "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[34]" \
                10 "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[34]" \
                11 "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[34]" \
                12 "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[34]" \
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[34]" \
                14 "S19/S19.pabiode.results/${stats}.S19.pabiode.odorVI+tlrc[34]" \
                15 "S20/S20.pabiode.results/${stats}.S20.pabiode.odorVI+tlrc[34]" \
                16 "S21/S21.pabiode.results/${stats}.S21.pabiode.odorVI+tlrc[34]" \
                17 "S22/S22.pabiode.results/${stats}.S22.pabiode.odorVI+tlrc[34]" \
                18 "S23/S23.pabiode.results/${stats}.S23.pabiode.odorVI+tlrc[34]" \
                19 "S24/S24.pabiode.results/${stats}.S24.pabiode.odorVI+tlrc[34]" \
                20 "S25/S25.pabiode.results/${stats}.S25.pabiode.odorVI+tlrc[34]" \
                21 "S26/S26.pabiode.results/${stats}.S26.pabiode.odorVI+tlrc[34]" \
                22 "S27/S27.pabiode.results/${stats}.S27.pabiode.odorVI+tlrc[34]" \
                23 "S28/S28.pabiode.results/${stats}.S28.pabiode.odorVI+tlrc[34]" \
                24 "S29/S29.pabiode.results/${stats}.S29.pabiode.odorVI+tlrc[34]" \
                25 "S31/S31.pabiode.results/${stats}.S31.pabiode.odorVI+tlrc[34]" \
                26 "S32/S32.pabiode.results/${stats}.S32.pabiode.odorVI+tlrc[34]" \
                27 "S33/S33.pabiode.results/${stats}.S33.pabiode.odorVI+tlrc[34]" \
                28 "S34/S34.pabiode.results/${stats}.S34.pabiode.odorVI+tlrc[34]"

3dttest++ -prefix group/${stats}_lim-tra                                       \
          -mask ${mask}                                      \
          -setA lim-tra                                               \
                01 "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[22]" \
                02 "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[22]" \
                03 "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[22]" \
                04 "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[22]" \
                05 "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[22]" \
                06 "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[22]" \
                07 "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[22]" \
                08 "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[22]" \
                09 "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[22]" \
                10 "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[22]" \
                11 "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[22]" \
                12 "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[22]" \
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[22]" \
                14 "S19/S19.pabiode.results/${stats}.S19.pabiode.odorVI+tlrc[22]" \
                15 "S20/S20.pabiode.results/${stats}.S20.pabiode.odorVI+tlrc[22]" \
                16 "S21/S21.pabiode.results/${stats}.S21.pabiode.odorVI+tlrc[22]" \
                17 "S22/S22.pabiode.results/${stats}.S22.pabiode.odorVI+tlrc[22]" \
                18 "S23/S23.pabiode.results/${stats}.S23.pabiode.odorVI+tlrc[22]" \
                19 "S24/S24.pabiode.results/${stats}.S24.pabiode.odorVI+tlrc[22]" \
                20 "S25/S25.pabiode.results/${stats}.S25.pabiode.odorVI+tlrc[22]" \
                21 "S26/S26.pabiode.results/${stats}.S26.pabiode.odorVI+tlrc[22]" \
                22 "S27/S27.pabiode.results/${stats}.S27.pabiode.odorVI+tlrc[22]" \
                23 "S28/S28.pabiode.results/${stats}.S28.pabiode.odorVI+tlrc[22]" \
                24 "S29/S29.pabiode.results/${stats}.S29.pabiode.odorVI+tlrc[22]" \
                25 "S31/S31.pabiode.results/${stats}.S31.pabiode.odorVI+tlrc[22]" \
                26 "S32/S32.pabiode.results/${stats}.S32.pabiode.odorVI+tlrc[22]" \
                27 "S33/S33.pabiode.results/${stats}.S33.pabiode.odorVI+tlrc[22]" \
                28 "S34/S34.pabiode.results/${stats}.S34.pabiode.odorVI+tlrc[22]"

3dttest++ -prefix group/${stats}_lim-ind                                       \
          -mask ${mask}                                      \
          -paired                                                    \
          -setA lim                                               \
                01 "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[1]" \
                02 "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[1]" \
                03 "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[1]" \
                04 "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[1]" \
                05 "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[1]" \
                06 "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[1]" \
                07 "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[1]" \
                08 "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[1]" \
                09 "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[1]" \
                10 "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[1]" \
                11 "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[1]" \
                12 "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[1]" \
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[1]" \
                14 "S19/S19.pabiode.results/${stats}.S19.pabiode.odorVI+tlrc[1]" \
                15 "S20/S20.pabiode.results/${stats}.S20.pabiode.odorVI+tlrc[1]" \
                16 "S21/S21.pabiode.results/${stats}.S21.pabiode.odorVI+tlrc[1]" \
                17 "S22/S22.pabiode.results/${stats}.S22.pabiode.odorVI+tlrc[1]" \
                18 "S23/S23.pabiode.results/${stats}.S23.pabiode.odorVI+tlrc[1]" \
                19 "S24/S24.pabiode.results/${stats}.S24.pabiode.odorVI+tlrc[1]" \
                20 "S25/S25.pabiode.results/${stats}.S25.pabiode.odorVI+tlrc[1]" \
                21 "S26/S26.pabiode.results/${stats}.S26.pabiode.odorVI+tlrc[1]" \
                22 "S27/S27.pabiode.results/${stats}.S27.pabiode.odorVI+tlrc[1]" \
                23 "S28/S28.pabiode.results/${stats}.S28.pabiode.odorVI+tlrc[1]" \
                24 "S29/S29.pabiode.results/${stats}.S29.pabiode.odorVI+tlrc[1]" \
                25 "S31/S31.pabiode.results/${stats}.S31.pabiode.odorVI+tlrc[1]" \
                26 "S32/S32.pabiode.results/${stats}.S32.pabiode.odorVI+tlrc[1]" \
                27 "S33/S33.pabiode.results/${stats}.S33.pabiode.odorVI+tlrc[1]" \
                28 "S34/S34.pabiode.results/${stats}.S34.pabiode.odorVI+tlrc[1]" \
          -setB Ind                                               \
                01 "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[13]" \
                02 "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[13]" \
                03 "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[13]" \
                04 "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[13]" \
                05 "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[13]" \
                06 "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[13]" \
                07 "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[13]" \
                08 "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[13]" \
                09 "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[13]" \
                10 "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[13]" \
                11 "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[13]" \
                12 "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[13]" \
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[13]" \
                14 "S19/S19.pabiode.results/${stats}.S19.pabiode.odorVI+tlrc[13]" \
                15 "S20/S20.pabiode.results/${stats}.S20.pabiode.odorVI+tlrc[13]" \
                16 "S21/S21.pabiode.results/${stats}.S21.pabiode.odorVI+tlrc[13]" \
                17 "S22/S22.pabiode.results/${stats}.S22.pabiode.odorVI+tlrc[13]" \
                18 "S23/S23.pabiode.results/${stats}.S23.pabiode.odorVI+tlrc[13]" \
                19 "S24/S24.pabiode.results/${stats}.S24.pabiode.odorVI+tlrc[13]" \
                20 "S25/S25.pabiode.results/${stats}.S25.pabiode.odorVI+tlrc[13]" \
                21 "S26/S26.pabiode.results/${stats}.S26.pabiode.odorVI+tlrc[13]" \
                22 "S27/S27.pabiode.results/${stats}.S27.pabiode.odorVI+tlrc[13]" \
                23 "S28/S28.pabiode.results/${stats}.S28.pabiode.odorVI+tlrc[13]" \
                24 "S29/S29.pabiode.results/${stats}.S29.pabiode.odorVI+tlrc[13]" \
                25 "S31/S31.pabiode.results/${stats}.S31.pabiode.odorVI+tlrc[13]" \
                26 "S32/S32.pabiode.results/${stats}.S32.pabiode.odorVI+tlrc[13]" \
                27 "S33/S33.pabiode.results/${stats}.S33.pabiode.odorVI+tlrc[13]" \
                28 "S34/S34.pabiode.results/${stats}.S34.pabiode.odorVI+tlrc[13]"

# 3dttest++ -prefix group/${stats}_val                                       \
#           -mask ${mask}                                      \
#           -setA lim-tra                                               \
#                 01 "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[16]" \
#                 02 "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[16]" \
#                 03 "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[16]" \
#                 04 "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[16]" \
#                 05 "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[16]" \
#                 06 "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[16]" \
#                 07 "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[16]" \
#                 08 "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[16]" \
#                 09 "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[16]" \
#                 10 "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[16]" \
#                 11 "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[16]" \
#                 12 "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[16]" \
#                 13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[16]" 

# 3dttest++ -prefix group/${stats}_int                                       \
#           -mask ${mask}                                      \
#           -setA lim-tra                                               \
#                 01 "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[19]" \
#                 02 "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[19]" \
#                 03 "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[19]" \
#                 04 "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[19]" \
#                 05 "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[19]" \
#                 06 "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[19]" \
#                 07 "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[19]" \
#                 08 "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[19]" \
#                 09 "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[19]" \
#                 10 "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[19]" \
#                 11 "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[19]" \
#                 12 "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[19]" \
#                 13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[19]" 

# calculate p-values for the group-level tests
# tthr=$(ccalc -expr "cdf2stat(0.975,3,27,0,0)")
# # individual level t threshold
# tthri=1.96
# # extract voxels with p-values below the threshold
# 3dcalc \
# -a "group/${stats}_car-lim+tlrc[1]" \
# -b "group/${stats}_cit-lim+tlrc[1]" \
# -expr "astep(a,${tthr})+astep(b,${tthr})*10" \
# -prefix group/combine_car_cit

# # abs(cit-lim) and abs(car-lim)
# 3dcalc \
# -a "group/${stats}_car-lim+tlrc[1]" \
# -expr "abs(a)" \
# -prefix group/${stats}_abs_car_lim

# 3dcalc \
# -a "group/${stats}_cit-lim+tlrc[1]" \
# -expr "abs(a)" \
# -prefix group/${stats}_abs_cit_lim

# # valance and intensity rating screen (not odor_va)
# # 3dcalc \
# # -a "group/${stats}_val+tlrc[1]" \
# # -b "group/${stats}_int+tlrc[1]" \
# # -expr "astep(a,${tthr})+astep(b,${tthr})*10" \
# # -prefix group/combine_val_int

# # all 4 lim pairs
# 3dcalc \
# -a "group/${stats}_car-lim+tlrc[1]" \
# -b "group/${stats}_cit-lim+tlrc[1]" \
# -c "group/${stats}_lim-tra+tlrc[1]" \
# -d "group/${stats}_lim-ind+tlrc[1]" \
# -expr "astep(a,${tthr})+astep(b,${tthr})*10+astep(c,${tthr})*20+astep(d,${tthr})*50" \
# -prefix group/combine_4lim

# # percent of subjects activated in each voxel
# # # rm group/*percent*

# # first half of the subjects
# 3dcalc -prefix group/${stats}_car-lim_per_half1                         \
#       -a ${mask}                                                        \
#       -b "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[32]" \
#       -c "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[32]" \
#       -d "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[32]" \
#       -e "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[32]" \
#       -f "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[32]" \
#       -g "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[32]" \
#       -h "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[32]" \
#       -i "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[32]" \
#       -j "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[32]" \
#       -k "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[32]" \
#       -l "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[32]" \
#       -m "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[32]" \
#       -n "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[32]" \
#       -o "S19/S19.pabiode.results/${stats}.S19.pabiode.odorVI+tlrc[32]" \
#       -expr "a*(mean(astep(b,${tthri}),astep(c,${tthri}),astep(d,${tthri}),astep(e,${tthri}),astep(f,${tthri}),astep(g,${tthri}),astep(h,${tthri}),astep(i,${tthri}),astep(j,${tthri}),astep(k,${tthri}),astep(l,${tthri}),astep(m,${tthri}),astep(n,${tthri}),astep(o,${tthri})))"

# 3dcalc -prefix group/${stats}_cit-lim_per_half1                         \
#       -a ${mask}                                                        \
#       -b "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[35]" \
#       -c "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[35]" \
#       -d "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[35]" \
#       -e "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[35]" \
#       -f "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[35]" \
#       -g "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[35]" \
#       -h "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[35]" \
#       -i "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[35]" \
#       -j "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[35]" \
#       -k "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[35]" \
#       -l "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[35]" \
#       -m "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[35]" \
#       -n "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[35]" \
#       -o "S19/S19.pabiode.results/${stats}.S19.pabiode.odorVI+tlrc[35]" \
#       -expr "a*(mean(astep(b,${tthri}),astep(c,${tthri}),astep(d,${tthri}),astep(e,${tthri}),astep(f,${tthri}),astep(g,${tthri}),astep(h,${tthri}),astep(i,${tthri}),astep(j,${tthri}),astep(k,${tthri}),astep(l,${tthri}),astep(m,${tthri}),astep(n,${tthri}),astep(o,${tthri})))"
# # second half of the subjects
# 3dcalc -prefix group/${stats}_car-lim_per_half2                         \
#       -a ${mask}                                                        \
#       -b "S20/S20.pabiode.results/${stats}.S20.pabiode.odorVI+tlrc[32]" \
#       -c "S21/S21.pabiode.results/${stats}.S21.pabiode.odorVI+tlrc[32]" \
#       -d "S22/S22.pabiode.results/${stats}.S22.pabiode.odorVI+tlrc[32]" \
#       -e "S23/S23.pabiode.results/${stats}.S23.pabiode.odorVI+tlrc[32]" \
#       -f "S24/S24.pabiode.results/${stats}.S24.pabiode.odorVI+tlrc[32]" \
#       -g "S25/S25.pabiode.results/${stats}.S25.pabiode.odorVI+tlrc[32]" \
#       -h "S26/S26.pabiode.results/${stats}.S26.pabiode.odorVI+tlrc[32]" \
#       -i "S27/S27.pabiode.results/${stats}.S27.pabiode.odorVI+tlrc[32]" \
#       -j "S28/S28.pabiode.results/${stats}.S28.pabiode.odorVI+tlrc[32]" \
#       -k "S29/S29.pabiode.results/${stats}.S29.pabiode.odorVI+tlrc[32]" \
#       -l "S31/S31.pabiode.results/${stats}.S31.pabiode.odorVI+tlrc[32]" \
#       -m "S32/S32.pabiode.results/${stats}.S32.pabiode.odorVI+tlrc[32]" \
#       -n "S33/S33.pabiode.results/${stats}.S33.pabiode.odorVI+tlrc[32]" \
#       -o "S34/S34.pabiode.results/${stats}.S34.pabiode.odorVI+tlrc[32]" \
#       -expr "a*(mean(astep(b,${tthri}),astep(c,${tthri}),astep(d,${tthri}),astep(e,${tthri}),astep(f,${tthri}),astep(g,${tthri}),astep(h,${tthri}),astep(i,${tthri}),astep(j,${tthri}),astep(k,${tthri}),astep(l,${tthri}),astep(m,${tthri}),astep(n,${tthri}),astep(o,${tthri})))"

# 3dcalc -prefix group/${stats}_cit-lim_per_half2                         \
#       -a ${mask}                                                        \
#       -b "S20/S20.pabiode.results/${stats}.S20.pabiode.odorVI+tlrc[35]" \
#       -c "S21/S21.pabiode.results/${stats}.S21.pabiode.odorVI+tlrc[35]" \
#       -d "S22/S22.pabiode.results/${stats}.S22.pabiode.odorVI+tlrc[35]" \
#       -e "S23/S23.pabiode.results/${stats}.S23.pabiode.odorVI+tlrc[35]" \
#       -f "S24/S24.pabiode.results/${stats}.S24.pabiode.odorVI+tlrc[35]" \
#       -g "S25/S25.pabiode.results/${stats}.S25.pabiode.odorVI+tlrc[35]" \
#       -h "S26/S26.pabiode.results/${stats}.S26.pabiode.odorVI+tlrc[35]" \
#       -i "S27/S27.pabiode.results/${stats}.S27.pabiode.odorVI+tlrc[35]" \
#       -j "S28/S28.pabiode.results/${stats}.S28.pabiode.odorVI+tlrc[35]" \
#       -k "S29/S29.pabiode.results/${stats}.S29.pabiode.odorVI+tlrc[35]" \
#       -l "S31/S31.pabiode.results/${stats}.S31.pabiode.odorVI+tlrc[35]" \
#       -m "S32/S32.pabiode.results/${stats}.S32.pabiode.odorVI+tlrc[35]" \
#       -n "S33/S33.pabiode.results/${stats}.S33.pabiode.odorVI+tlrc[35]" \
#       -o "S34/S34.pabiode.results/${stats}.S34.pabiode.odorVI+tlrc[35]" \
#       -expr "a*(mean(astep(b,${tthri}),astep(c,${tthri}),astep(d,${tthri}),astep(e,${tthri}),astep(f,${tthri}),astep(g,${tthri}),astep(h,${tthri}),astep(i,${tthri}),astep(j,${tthri}),astep(k,${tthri}),astep(l,${tthri}),astep(m,${tthri}),astep(n,${tthri}),astep(o,${tthri})))"
# # combine the two halves
# 3dcalc -prefix group/${stats}_car-lim_percent                           \
#       -a group/${stats}_car-lim_per_half1+tlrc                           \
#       -b group/${stats}_car-lim_per_half2+tlrc                           \
#       -expr "mean(a,b)"
# 3dcalc -prefix group/${stats}_cit-lim_percent                           \
#       -a group/${stats}_cit-lim_per_half1+tlrc                           \
#       -b group/${stats}_cit-lim_per_half2+tlrc                           \
#       -expr "mean(a,b)"

# # cit-car
# 3dcalc -prefix group/${stats}_carcit_per_half1                           \
#       -a group/${stats}_car-lim_per_half1+tlrc                           \
#       -b group/${stats}_cit-lim_per_half1+tlrc                           \
#       -expr "b-a"
# 3dcalc -prefix group/${stats}_carcit_per_half2                           \
#       -a group/${stats}_car-lim_per_half2+tlrc                           \
#       -b group/${stats}_cit-lim_per_half2+tlrc                           \
#       -expr "b-a"
# 3dcalc -prefix group/${stats}_carcit_percent                           \
#       -a group/${stats}_car-lim_percent+tlrc                           \
#       -b group/${stats}_cit-lim_percent+tlrc                           \
#       -expr "b-a"
3dcalc -prefix group/${stats}_carcit_pernorm_half1                       \
      -a group/${stats}_car-lim_per_half1+tlrc                           \
      -b group/${stats}_cit-lim_per_half1+tlrc                           \
      -expr "(b-a)/(b+a)"
3dcalc -prefix group/${stats}_carcit_pernorm_half2                       \
      -a group/${stats}_car-lim_per_half2+tlrc                           \
      -b group/${stats}_cit-lim_per_half2+tlrc                           \
      -expr "(b-a)/(b+a)"
3dcalc -prefix group/${stats}_carcit_pernorm                           \
      -a group/${stats}_car-lim_percent+tlrc                           \
      -b group/${stats}_cit-lim_percent+tlrc                           \
      -expr "(b-a)/(b+a)"

# 3dttest++ -prefix group/stats_cit-car_abs                               \
#           -mask ${mask}                                                 \
#           -setA cit_lim-car-lim                                         \
#                 01 "S04/S04.pabiode.results/citcar.S04.pabiode+tlrc" \
#                 02 "S05/S05.pabiode.results/citcar.S05.pabiode+tlrc" \
#                 03 "S06/S06.pabiode.results/citcar.S06.pabiode+tlrc" \
#                 04 "S07/S07.pabiode.results/citcar.S07.pabiode+tlrc" \
#                 05 "S08/S08.pabiode.results/citcar.S08.pabiode+tlrc" \
#                 06 "S09/S09.pabiode.results/citcar.S09.pabiode+tlrc" \
#                 07 "S10/S10.pabiode.results/citcar.S10.pabiode+tlrc" \
#                 08 "S11/S11.pabiode.results/citcar.S11.pabiode+tlrc" \
#                 09 "S13/S13.pabiode.results/citcar.S13.pabiode+tlrc" \
#                 10 "S14/S14.pabiode.results/citcar.S14.pabiode+tlrc" \
#                 11 "S16/S16.pabiode.results/citcar.S16.pabiode+tlrc" \
#                 12 "S17/S17.pabiode.results/citcar.S17.pabiode+tlrc" \
#                 13 "S18/S18.pabiode.results/citcar.S18.pabiode+tlrc" \
#                 14 "S19/S19.pabiode.results/citcar.S19.pabiode+tlrc" \
#                 15 "S20/S20.pabiode.results/citcar.S20.pabiode+tlrc" \
#                 16 "S21/S21.pabiode.results/citcar.S21.pabiode+tlrc" \
#                 17 "S22/S22.pabiode.results/citcar.S22.pabiode+tlrc" \
#                 18 "S23/S23.pabiode.results/citcar.S23.pabiode+tlrc" \
#                 19 "S24/S24.pabiode.results/citcar.S24.pabiode+tlrc" \
#                 20 "S25/S25.pabiode.results/citcar.S25.pabiode+tlrc" \
#                 21 "S26/S26.pabiode.results/citcar.S26.pabiode+tlrc" \
#                 22 "S27/S27.pabiode.results/citcar.S27.pabiode+tlrc" \
#                 23 "S28/S28.pabiode.results/citcar.S28.pabiode+tlrc" \
#                 24 "S29/S29.pabiode.results/citcar.S29.pabiode+tlrc" \
#                 25 "S31/S31.pabiode.results/citcar.S31.pabiode+tlrc" \
#                 26 "S32/S32.pabiode.results/citcar.S32.pabiode+tlrc" \
#                 27 "S33/S33.pabiode.results/citcar.S33.pabiode+tlrc" \
#                 28 "S34/S34.pabiode.results/citcar.S34.pabiode+tlrc"

3dttest++ -prefix group/stats_cit-car_norm                              \
          -mask ${mask}                                                 \
          -setA cit_lim-car-lim                                         \
                01 "S04/S04.pabiode.results/citcar_norm.S04.pabiode+tlrc" \
                02 "S05/S05.pabiode.results/citcar_norm.S05.pabiode+tlrc" \
                03 "S06/S06.pabiode.results/citcar_norm.S06.pabiode+tlrc" \
                04 "S07/S07.pabiode.results/citcar_norm.S07.pabiode+tlrc" \
                05 "S08/S08.pabiode.results/citcar_norm.S08.pabiode+tlrc" \
                06 "S09/S09.pabiode.results/citcar_norm.S09.pabiode+tlrc" \
                07 "S10/S10.pabiode.results/citcar_norm.S10.pabiode+tlrc" \
                08 "S11/S11.pabiode.results/citcar_norm.S11.pabiode+tlrc" \
                09 "S13/S13.pabiode.results/citcar_norm.S13.pabiode+tlrc" \
                10 "S14/S14.pabiode.results/citcar_norm.S14.pabiode+tlrc" \
                11 "S16/S16.pabiode.results/citcar_norm.S16.pabiode+tlrc" \
                12 "S17/S17.pabiode.results/citcar_norm.S17.pabiode+tlrc" \
                13 "S18/S18.pabiode.results/citcar_norm.S18.pabiode+tlrc" \
                14 "S19/S19.pabiode.results/citcar_norm.S19.pabiode+tlrc" \
                15 "S20/S20.pabiode.results/citcar_norm.S20.pabiode+tlrc" \
                16 "S21/S21.pabiode.results/citcar_norm.S21.pabiode+tlrc" \
                17 "S22/S22.pabiode.results/citcar_norm.S22.pabiode+tlrc" \
                18 "S23/S23.pabiode.results/citcar_norm.S23.pabiode+tlrc" \
                19 "S24/S24.pabiode.results/citcar_norm.S24.pabiode+tlrc" \
                20 "S25/S25.pabiode.results/citcar_norm.S25.pabiode+tlrc" \
                21 "S26/S26.pabiode.results/citcar_norm.S26.pabiode+tlrc" \
                22 "S27/S27.pabiode.results/citcar_norm.S27.pabiode+tlrc" \
                23 "S28/S28.pabiode.results/citcar_norm.S28.pabiode+tlrc" \
                24 "S29/S29.pabiode.results/citcar_norm.S29.pabiode+tlrc" \
                25 "S31/S31.pabiode.results/citcar_norm.S31.pabiode+tlrc" \
                26 "S32/S32.pabiode.results/citcar_norm.S32.pabiode+tlrc" \
                27 "S33/S33.pabiode.results/citcar_norm.S33.pabiode+tlrc" \
                28 "S34/S34.pabiode.results/citcar_norm.S34.pabiode+tlrc"

# dunmp group level results
# xyz are in RAI order
3dmaskdump                                      \
-noijk -xyz                                     \
-mask group/mask/all.seg+tlrc                   \
group/mask/all.seg+tlrc                         \
group/${stats}_car-lim+tlrc"[0]"                \
group/${stats}_cit-lim+tlrc"[0]"                \
group/${stats}_lim-tra+tlrc"[0]"                \
group/${stats}_lim-ind+tlrc"[0]"                \
group/${stats}_car-lim+tlrc"[1]"                \
group/${stats}_cit-lim+tlrc"[1]"                \
group/${stats}_lim-tra+tlrc"[1]"                \
group/${stats}_lim-ind+tlrc"[1]"                \
> group/${stats}_results.txt

# 3dttest for subs 4-19 and 20-34
3dttest++ -prefix group/${stats}_car-lim_half1                                    \
          -mask ${mask}                                                           \
          -setA car-lim                                                           \
                01 "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[31]" \
                02 "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[31]" \
                03 "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[31]" \
                04 "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[31]" \
                05 "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[31]" \
                06 "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[31]" \
                07 "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[31]" \
                08 "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[31]" \
                09 "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[31]" \
                10 "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[31]" \
                11 "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[31]" \
                12 "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[31]" \
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[31]" \
                14 "S19/S19.pabiode.results/${stats}.S19.pabiode.odorVI+tlrc[31]"

3dttest++ -prefix group/${stats}_car-lim_half2                                    \
          -mask ${mask}                                                           \
          -setA car-lim                                                           \
                01 "S20/S20.pabiode.results/${stats}.S20.pabiode.odorVI+tlrc[31]" \
                02 "S21/S21.pabiode.results/${stats}.S21.pabiode.odorVI+tlrc[31]" \
                03 "S22/S22.pabiode.results/${stats}.S22.pabiode.odorVI+tlrc[31]" \
                04 "S23/S23.pabiode.results/${stats}.S23.pabiode.odorVI+tlrc[31]" \
                05 "S24/S24.pabiode.results/${stats}.S24.pabiode.odorVI+tlrc[31]" \
                06 "S25/S25.pabiode.results/${stats}.S25.pabiode.odorVI+tlrc[31]" \
                07 "S26/S26.pabiode.results/${stats}.S26.pabiode.odorVI+tlrc[31]" \
                08 "S27/S27.pabiode.results/${stats}.S27.pabiode.odorVI+tlrc[31]" \
                09 "S28/S28.pabiode.results/${stats}.S28.pabiode.odorVI+tlrc[31]" \
                10 "S29/S29.pabiode.results/${stats}.S29.pabiode.odorVI+tlrc[31]" \
                11 "S31/S31.pabiode.results/${stats}.S31.pabiode.odorVI+tlrc[31]" \
                12 "S32/S32.pabiode.results/${stats}.S32.pabiode.odorVI+tlrc[31]" \
                13 "S33/S33.pabiode.results/${stats}.S33.pabiode.odorVI+tlrc[31]" \
                14 "S34/S34.pabiode.results/${stats}.S34.pabiode.odorVI+tlrc[31]"

3dttest++ -prefix group/${stats}_cit-lim_half1                                    \
          -mask ${mask}                                                           \
          -setA cit-lim                                                           \
                01 "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[34]" \
                02 "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[34]" \
                03 "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[34]" \
                04 "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[34]" \
                05 "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[34]" \
                06 "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[34]" \
                07 "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[34]" \
                08 "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[34]" \
                09 "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[34]" \
                10 "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[34]" \
                11 "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[34]" \
                12 "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[34]" \
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[34]" \
                14 "S19/S19.pabiode.results/${stats}.S19.pabiode.odorVI+tlrc[34]"

3dttest++ -prefix group/${stats}_cit-lim_half2                                    \
          -mask ${mask}                                                           \
          -setA cit-lim                                                           \
                01 "S20/S20.pabiode.results/${stats}.S20.pabiode.odorVI+tlrc[34]" \
                02 "S21/S21.pabiode.results/${stats}.S21.pabiode.odorVI+tlrc[34]" \
                03 "S22/S22.pabiode.results/${stats}.S22.pabiode.odorVI+tlrc[34]" \
                04 "S23/S23.pabiode.results/${stats}.S23.pabiode.odorVI+tlrc[34]" \
                05 "S24/S24.pabiode.results/${stats}.S24.pabiode.odorVI+tlrc[34]" \
                06 "S25/S25.pabiode.results/${stats}.S25.pabiode.odorVI+tlrc[34]" \
                07 "S26/S26.pabiode.results/${stats}.S26.pabiode.odorVI+tlrc[34]" \
                08 "S27/S27.pabiode.results/${stats}.S27.pabiode.odorVI+tlrc[34]" \
                09 "S28/S28.pabiode.results/${stats}.S28.pabiode.odorVI+tlrc[34]" \
                10 "S29/S29.pabiode.results/${stats}.S29.pabiode.odorVI+tlrc[34]" \
                11 "S31/S31.pabiode.results/${stats}.S31.pabiode.odorVI+tlrc[34]" \
                12 "S32/S32.pabiode.results/${stats}.S32.pabiode.odorVI+tlrc[34]" \
                13 "S33/S33.pabiode.results/${stats}.S33.pabiode.odorVI+tlrc[34]" \
                14 "S34/S34.pabiode.results/${stats}.S34.pabiode.odorVI+tlrc[34]"

3dttest++ -prefix group/${stats}_lim-tra_half1                                    \
          -mask ${mask}                                                           \
          -setA lim-tra                                                           \
                01 "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[22]" \
                02 "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[22]" \
                03 "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[22]" \
                04 "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[22]" \
                05 "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[22]" \
                06 "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[22]" \
                07 "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[22]" \
                08 "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[22]" \
                09 "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[22]" \
                10 "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[22]" \
                11 "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[22]" \
                12 "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[22]" \
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[22]" \
                14 "S19/S19.pabiode.results/${stats}.S19.pabiode.odorVI+tlrc[22]"

3dttest++ -prefix group/${stats}_lim-tra_half2                                    \
          -mask ${mask}                                                           \
          -setA lim-tra                                                           \
                01 "S20/S20.pabiode.results/${stats}.S20.pabiode.odorVI+tlrc[22]" \
                02 "S21/S21.pabiode.results/${stats}.S21.pabiode.odorVI+tlrc[22]" \
                03 "S22/S22.pabiode.results/${stats}.S22.pabiode.odorVI+tlrc[22]" \
                04 "S23/S23.pabiode.results/${stats}.S23.pabiode.odorVI+tlrc[22]" \
                05 "S24/S24.pabiode.results/${stats}.S24.pabiode.odorVI+tlrc[22]" \
                06 "S25/S25.pabiode.results/${stats}.S25.pabiode.odorVI+tlrc[22]" \
                07 "S26/S26.pabiode.results/${stats}.S26.pabiode.odorVI+tlrc[22]" \
                08 "S27/S27.pabiode.results/${stats}.S27.pabiode.odorVI+tlrc[22]" \
                09 "S28/S28.pabiode.results/${stats}.S28.pabiode.odorVI+tlrc[22]" \
                10 "S29/S29.pabiode.results/${stats}.S29.pabiode.odorVI+tlrc[22]" \
                11 "S31/S31.pabiode.results/${stats}.S31.pabiode.odorVI+tlrc[22]" \
                12 "S32/S32.pabiode.results/${stats}.S32.pabiode.odorVI+tlrc[22]" \
                13 "S33/S33.pabiode.results/${stats}.S33.pabiode.odorVI+tlrc[22]" \
                14 "S34/S34.pabiode.results/${stats}.S34.pabiode.odorVI+tlrc[22]"

3dttest++ -prefix group/${stats}_lim-ind_half1                                   \
          -mask ${mask}                                                          \
          -paired                                                                \
          -setA lim                                                              \
                01 "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[1]" \
                02 "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[1]" \
                03 "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[1]" \
                04 "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[1]" \
                05 "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[1]" \
                06 "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[1]" \
                07 "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[1]" \
                08 "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[1]" \
                09 "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[1]" \
                10 "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[1]" \
                11 "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[1]" \
                12 "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[1]" \
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[1]" \
                14 "S19/S19.pabiode.results/${stats}.S19.pabiode.odorVI+tlrc[1]" \
          -setB Ind                                               \
                01 "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[13]" \
                02 "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[13]" \
                03 "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[13]" \
                04 "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[13]" \
                05 "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[13]" \
                06 "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[13]" \
                07 "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[13]" \
                08 "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[13]" \
                09 "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[13]" \
                10 "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[13]" \
                11 "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[13]" \
                12 "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[13]" \
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[13]" \
                14 "S19/S19.pabiode.results/${stats}.S19.pabiode.odorVI+tlrc[13]" \

3dttest++ -prefix group/${stats}_lim-ind_half2                                   \
          -mask ${mask}                                                          \
          -paired                                                                \
          -setA lim                                                              \
                01 "S20/S20.pabiode.results/${stats}.S20.pabiode.odorVI+tlrc[1]" \
                02 "S21/S21.pabiode.results/${stats}.S21.pabiode.odorVI+tlrc[1]" \
                03 "S22/S22.pabiode.results/${stats}.S22.pabiode.odorVI+tlrc[1]" \
                04 "S23/S23.pabiode.results/${stats}.S23.pabiode.odorVI+tlrc[1]" \
                05 "S24/S24.pabiode.results/${stats}.S24.pabiode.odorVI+tlrc[1]" \
                06 "S25/S25.pabiode.results/${stats}.S25.pabiode.odorVI+tlrc[1]" \
                07 "S26/S26.pabiode.results/${stats}.S26.pabiode.odorVI+tlrc[1]" \
                08 "S27/S27.pabiode.results/${stats}.S27.pabiode.odorVI+tlrc[1]" \
                09 "S28/S28.pabiode.results/${stats}.S28.pabiode.odorVI+tlrc[1]" \
                10 "S29/S29.pabiode.results/${stats}.S29.pabiode.odorVI+tlrc[1]" \
                11 "S31/S31.pabiode.results/${stats}.S31.pabiode.odorVI+tlrc[1]" \
                12 "S32/S32.pabiode.results/${stats}.S32.pabiode.odorVI+tlrc[1]" \
                13 "S33/S33.pabiode.results/${stats}.S33.pabiode.odorVI+tlrc[1]" \
                14 "S34/S34.pabiode.results/${stats}.S34.pabiode.odorVI+tlrc[1]" \
          -setB Ind                                               \
                01 "S20/S20.pabiode.results/${stats}.S20.pabiode.odorVI+tlrc[13]" \
                02 "S21/S21.pabiode.results/${stats}.S21.pabiode.odorVI+tlrc[13]" \
                03 "S22/S22.pabiode.results/${stats}.S22.pabiode.odorVI+tlrc[13]" \
                04 "S23/S23.pabiode.results/${stats}.S23.pabiode.odorVI+tlrc[13]" \
                05 "S24/S24.pabiode.results/${stats}.S24.pabiode.odorVI+tlrc[13]" \
                06 "S25/S25.pabiode.results/${stats}.S25.pabiode.odorVI+tlrc[13]" \
                07 "S26/S26.pabiode.results/${stats}.S26.pabiode.odorVI+tlrc[13]" \
                08 "S27/S27.pabiode.results/${stats}.S27.pabiode.odorVI+tlrc[13]" \
                09 "S28/S28.pabiode.results/${stats}.S28.pabiode.odorVI+tlrc[13]" \
                10 "S29/S29.pabiode.results/${stats}.S29.pabiode.odorVI+tlrc[13]" \
                11 "S31/S31.pabiode.results/${stats}.S31.pabiode.odorVI+tlrc[13]" \
                12 "S32/S32.pabiode.results/${stats}.S32.pabiode.odorVI+tlrc[13]" \
                13 "S33/S33.pabiode.results/${stats}.S33.pabiode.odorVI+tlrc[13]" \
                14 "S34/S34.pabiode.results/${stats}.S34.pabiode.odorVI+tlrc[13]"

# dunmp group level results
# xyz are in RAI order
3dmaskdump                                      \
-noijk -xyz                                     \
-mask group/mask/all.seg+tlrc                   \
group/mask/all.seg+tlrc                         \
group/${stats}_car-lim_half1+tlrc"[0]"                \
group/${stats}_cit-lim_half1+tlrc"[0]"                \
group/${stats}_lim-tra_half1+tlrc"[0]"                \
group/${stats}_lim-ind_half1+tlrc"[0]"                \
group/${stats}_car-lim_half1+tlrc"[1]"                \
group/${stats}_cit-lim_half1+tlrc"[1]"                \
group/${stats}_lim-tra_half1+tlrc"[1]"                \
group/${stats}_lim-ind_half1+tlrc"[1]"                \
> group/${stats}_results_half1.txt

3dmaskdump                                      \
-noijk -xyz                                     \
-mask group/mask/all.seg+tlrc                   \
group/mask/all.seg+tlrc                         \
group/${stats}_car-lim_half2+tlrc"[0]"                \
group/${stats}_cit-lim_half2+tlrc"[0]"                \
group/${stats}_lim-tra_half2+tlrc"[0]"                \
group/${stats}_lim-ind_half2+tlrc"[0]"                \
group/${stats}_car-lim_half2+tlrc"[1]"                \
group/${stats}_cit-lim_half2+tlrc"[1]"                \
group/${stats}_lim-tra_half2+tlrc"[1]"                \
group/${stats}_lim-ind_half2+tlrc"[1]"                \
> group/${stats}_results_half2.txt

#################### half results for absolute diff ##########################
# 3dttest++ -prefix group/stats_cit-car_abs_half1                         \
#           -mask ${mask}                                                 \
#           -setA cit_lim-car-lim                                         \
#                 01 "S04/S04.pabiode.results/citcar.S04.pabiode+tlrc" \
#                 02 "S05/S05.pabiode.results/citcar.S05.pabiode+tlrc" \
#                 03 "S06/S06.pabiode.results/citcar.S06.pabiode+tlrc" \
#                 04 "S07/S07.pabiode.results/citcar.S07.pabiode+tlrc" \
#                 05 "S08/S08.pabiode.results/citcar.S08.pabiode+tlrc" \
#                 06 "S09/S09.pabiode.results/citcar.S09.pabiode+tlrc" \
#                 07 "S10/S10.pabiode.results/citcar.S10.pabiode+tlrc" \
#                 08 "S11/S11.pabiode.results/citcar.S11.pabiode+tlrc" \
#                 09 "S13/S13.pabiode.results/citcar.S13.pabiode+tlrc" \
#                 10 "S14/S14.pabiode.results/citcar.S14.pabiode+tlrc" \
#                 11 "S16/S16.pabiode.results/citcar.S16.pabiode+tlrc" \
#                 12 "S17/S17.pabiode.results/citcar.S17.pabiode+tlrc" \
#                 13 "S18/S18.pabiode.results/citcar.S18.pabiode+tlrc" \
#                 14 "S19/S19.pabiode.results/citcar.S19.pabiode+tlrc"

# 3dttest++ -prefix group/stats_cit-car_abs_half2                         \
#           -mask ${mask}                                                 \
#           -setA cit_lim-car-lim                                         \
#                 01 "S20/S20.pabiode.results/citcar.S20.pabiode+tlrc" \
#                 02 "S21/S21.pabiode.results/citcar.S21.pabiode+tlrc" \
#                 03 "S22/S22.pabiode.results/citcar.S22.pabiode+tlrc" \
#                 04 "S23/S23.pabiode.results/citcar.S23.pabiode+tlrc" \
#                 05 "S24/S24.pabiode.results/citcar.S24.pabiode+tlrc" \
#                 06 "S25/S25.pabiode.results/citcar.S25.pabiode+tlrc" \
#                 07 "S26/S26.pabiode.results/citcar.S26.pabiode+tlrc" \
#                 08 "S27/S27.pabiode.results/citcar.S27.pabiode+tlrc" \
#                 09 "S28/S28.pabiode.results/citcar.S28.pabiode+tlrc" \
#                 10 "S29/S29.pabiode.results/citcar.S29.pabiode+tlrc" \
#                 11 "S31/S31.pabiode.results/citcar.S31.pabiode+tlrc" \
#                 12 "S32/S32.pabiode.results/citcar.S32.pabiode+tlrc" \
#                 13 "S33/S33.pabiode.results/citcar.S33.pabiode+tlrc" \
#                 14 "S34/S34.pabiode.results/citcar.S34.pabiode+tlrc"

3dttest++ -prefix group/stats_cit-car_norm_half1                        \
          -mask ${mask}                                                 \
          -setA cit_lim-car-lim                                         \
                01 "S04/S04.pabiode.results/citcar_norm.S04.pabiode+tlrc" \
                02 "S05/S05.pabiode.results/citcar_norm.S05.pabiode+tlrc" \
                03 "S06/S06.pabiode.results/citcar_norm.S06.pabiode+tlrc" \
                04 "S07/S07.pabiode.results/citcar_norm.S07.pabiode+tlrc" \
                05 "S08/S08.pabiode.results/citcar_norm.S08.pabiode+tlrc" \
                06 "S09/S09.pabiode.results/citcar_norm.S09.pabiode+tlrc" \
                07 "S10/S10.pabiode.results/citcar_norm.S10.pabiode+tlrc" \
                08 "S11/S11.pabiode.results/citcar_norm.S11.pabiode+tlrc" \
                09 "S13/S13.pabiode.results/citcar_norm.S13.pabiode+tlrc" \
                10 "S14/S14.pabiode.results/citcar_norm.S14.pabiode+tlrc" \
                11 "S16/S16.pabiode.results/citcar_norm.S16.pabiode+tlrc" \
                12 "S17/S17.pabiode.results/citcar_norm.S17.pabiode+tlrc" \
                13 "S18/S18.pabiode.results/citcar_norm.S18.pabiode+tlrc" \
                14 "S19/S19.pabiode.results/citcar_norm.S19.pabiode+tlrc"

3dttest++ -prefix group/stats_cit-car_norm_half2                        \
          -mask ${mask}                                                 \
          -setA cit_lim-car-lim                                         \
                01 "S20/S20.pabiode.results/citcar_norm.S20.pabiode+tlrc" \
                02 "S21/S21.pabiode.results/citcar_norm.S21.pabiode+tlrc" \
                03 "S22/S22.pabiode.results/citcar_norm.S22.pabiode+tlrc" \
                04 "S23/S23.pabiode.results/citcar_norm.S23.pabiode+tlrc" \
                05 "S24/S24.pabiode.results/citcar_norm.S24.pabiode+tlrc" \
                06 "S25/S25.pabiode.results/citcar_norm.S25.pabiode+tlrc" \
                07 "S26/S26.pabiode.results/citcar_norm.S26.pabiode+tlrc" \
                08 "S27/S27.pabiode.results/citcar_norm.S27.pabiode+tlrc" \
                09 "S28/S28.pabiode.results/citcar_norm.S28.pabiode+tlrc" \
                10 "S29/S29.pabiode.results/citcar_norm.S29.pabiode+tlrc" \
                11 "S31/S31.pabiode.results/citcar_norm.S31.pabiode+tlrc" \
                12 "S32/S32.pabiode.results/citcar_norm.S32.pabiode+tlrc" \
                13 "S33/S33.pabiode.results/citcar_norm.S33.pabiode+tlrc" \
                14 "S34/S34.pabiode.results/citcar_norm.S34.pabiode+tlrc"


################ mvpa results ################
stats=ARodor_l1_labelpolva
# searchlight results for 10 odor pairs
3dmaskdump                                      \
-noijk -xyz                                     \
-mask group/mask/all.seg+tlrc                   \
group/mask/all.seg+tlrc                         \
group/mvpa/${stats}_lim-car+tlrc"[0]"           \
group/mvpa/${stats}_lim-cit+tlrc"[0]"           \
group/mvpa/${stats}_lim-tra+tlrc"[0]"           \
group/mvpa/${stats}_lim-ind+tlrc"[0]"           \
group/mvpa/${stats}_tra-car+tlrc"[0]"           \
group/mvpa/${stats}_tra-cit+tlrc"[0]"           \
group/mvpa/${stats}_tra-ind+tlrc"[0]"           \
group/mvpa/${stats}_car-cit+tlrc"[0]"           \
group/mvpa/${stats}_car-ind+tlrc"[0]"           \
group/mvpa/${stats}_cit-ind+tlrc"[0]"           \
group/mvpa/${stats}_lim-car+tlrc"[1]"           \
group/mvpa/${stats}_lim-cit+tlrc"[1]"           \
group/mvpa/${stats}_lim-tra+tlrc"[1]"           \
group/mvpa/${stats}_lim-ind+tlrc"[1]"           \
group/mvpa/${stats}_tra-car+tlrc"[1]"           \
group/mvpa/${stats}_tra-cit+tlrc"[1]"           \
group/mvpa/${stats}_tra-ind+tlrc"[1]"           \
group/mvpa/${stats}_car-cit+tlrc"[1]"           \
group/mvpa/${stats}_car-ind+tlrc"[1]"           \
group/mvpa/${stats}_cit-ind+tlrc"[1]"           \
> group/stats_search_polva.txt