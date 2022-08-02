#! /bin/bash

datafolder=/Volumes/WD_E/gufei/7T_odor
cd "${datafolder}" || exit

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
#     3dinfo -subbrick_info "stats.${subj}.odorVI+tlrc[31]"
#     cd ../..
# done
# cd "${datafolder}" || exit

# 3dttest for subs 4-18
# 3dttest++ -prefix group/car-lim                                       \
#           -mask group/bmask.nii                                       \
#           -setA car-lim                                               \
#                 01 "S04/S04.pabiode.results/stats.S04.pabiode.odorVI+tlrc[31]" \
#                 02 "S05/S05.pabiode.results/stats.S05.pabiode.odorVI+tlrc[31]" \
#                 03 "S06/S06.pabiode.results/stats.S06.pabiode.odorVI+tlrc[31]" \
#                 04 "S07/S07.pabiode.results/stats.S07.pabiode.odorVI+tlrc[31]" \
#                 05 "S08/S08.pabiode.results/stats.S08.pabiode.odorVI+tlrc[31]" \
#                 06 "S09/S09.pabiode.results/stats.S09.pabiode.odorVI+tlrc[31]" \
#                 07 "S10/S10.pabiode.results/stats.S10.pabiode.odorVI+tlrc[31]" \
#                 08 "S11/S11.pabiode.results/stats.S11.pabiode.odorVI+tlrc[31]" \
#                 09 "S13/S13.pabiode.results/stats.S13.pabiode.odorVI+tlrc[31]" \
#                 10 "S14/S14.pabiode.results/stats.S14.pabiode.odorVI+tlrc[31]" \
#                 11 "S16/S16.pabiode.results/stats.S16.pabiode.odorVI+tlrc[31]" \
#                 12 "S17/S17.pabiode.results/stats.S17.pabiode.odorVI+tlrc[31]" \
#                 13 "S18/S18.pabiode.results/stats.S18.pabiode.odorVI+tlrc[31]" 

# 3dttest++ -prefix group/cit-lim                                       \
#           -mask group/bmask.nii                                       \
#           -setA car-lim                                               \
#                 01 "S04/S04.pabiode.results/stats.S04.pabiode.odorVI+tlrc[34]" \
#                 02 "S05/S05.pabiode.results/stats.S05.pabiode.odorVI+tlrc[34]" \
#                 03 "S06/S06.pabiode.results/stats.S06.pabiode.odorVI+tlrc[34]" \
#                 04 "S07/S07.pabiode.results/stats.S07.pabiode.odorVI+tlrc[34]" \
#                 05 "S08/S08.pabiode.results/stats.S08.pabiode.odorVI+tlrc[34]" \
#                 06 "S09/S09.pabiode.results/stats.S09.pabiode.odorVI+tlrc[34]" \
#                 07 "S10/S10.pabiode.results/stats.S10.pabiode.odorVI+tlrc[34]" \
#                 08 "S11/S11.pabiode.results/stats.S11.pabiode.odorVI+tlrc[34]" \
#                 09 "S13/S13.pabiode.results/stats.S13.pabiode.odorVI+tlrc[34]" \
#                 10 "S14/S14.pabiode.results/stats.S14.pabiode.odorVI+tlrc[34]" \
#                 11 "S16/S16.pabiode.results/stats.S16.pabiode.odorVI+tlrc[34]" \
#                 12 "S17/S17.pabiode.results/stats.S17.pabiode.odorVI+tlrc[34]" \
#                 13 "S18/S18.pabiode.results/stats.S18.pabiode.odorVI+tlrc[34]" 

3dttest++ -prefix group/lim-tra                                       \
          -mask group/bmask.nii                                       \
          -setA lim-tra                                               \
                01 "S04/S04.pabiode.results/stats.S04.pabiode.odorVI+tlrc[22]" \
                02 "S05/S05.pabiode.results/stats.S05.pabiode.odorVI+tlrc[22]" \
                03 "S06/S06.pabiode.results/stats.S06.pabiode.odorVI+tlrc[22]" \
                04 "S07/S07.pabiode.results/stats.S07.pabiode.odorVI+tlrc[22]" \
                05 "S08/S08.pabiode.results/stats.S08.pabiode.odorVI+tlrc[22]" \
                06 "S09/S09.pabiode.results/stats.S09.pabiode.odorVI+tlrc[22]" \
                07 "S10/S10.pabiode.results/stats.S10.pabiode.odorVI+tlrc[22]" \
                08 "S11/S11.pabiode.results/stats.S11.pabiode.odorVI+tlrc[22]" \
                09 "S13/S13.pabiode.results/stats.S13.pabiode.odorVI+tlrc[22]" \
                10 "S14/S14.pabiode.results/stats.S14.pabiode.odorVI+tlrc[22]" \
                11 "S16/S16.pabiode.results/stats.S16.pabiode.odorVI+tlrc[22]" \
                12 "S17/S17.pabiode.results/stats.S17.pabiode.odorVI+tlrc[22]" \
                13 "S18/S18.pabiode.results/stats.S18.pabiode.odorVI+tlrc[22]" 

3dttest++ -prefix group/lim-ind                                       \
          -mask group/bmask.nii                                       \
          -paired                                                    \
          -setA lim                                               \
                01 "S04/S04.pabiode.results/stats.S04.pabiode.odorVI+tlrc[1]" \
                02 "S05/S05.pabiode.results/stats.S05.pabiode.odorVI+tlrc[1]" \
                03 "S06/S06.pabiode.results/stats.S06.pabiode.odorVI+tlrc[1]" \
                04 "S07/S07.pabiode.results/stats.S07.pabiode.odorVI+tlrc[1]" \
                05 "S08/S08.pabiode.results/stats.S08.pabiode.odorVI+tlrc[1]" \
                06 "S09/S09.pabiode.results/stats.S09.pabiode.odorVI+tlrc[1]" \
                07 "S10/S10.pabiode.results/stats.S10.pabiode.odorVI+tlrc[1]" \
                08 "S11/S11.pabiode.results/stats.S11.pabiode.odorVI+tlrc[1]" \
                09 "S13/S13.pabiode.results/stats.S13.pabiode.odorVI+tlrc[1]" \
                10 "S14/S14.pabiode.results/stats.S14.pabiode.odorVI+tlrc[1]" \
                11 "S16/S16.pabiode.results/stats.S16.pabiode.odorVI+tlrc[1]" \
                12 "S17/S17.pabiode.results/stats.S17.pabiode.odorVI+tlrc[1]" \
                13 "S18/S18.pabiode.results/stats.S18.pabiode.odorVI+tlrc[1]" \
          -setB Ind                                               \
                01 "S04/S04.pabiode.results/stats.S04.pabiode.odorVI+tlrc[13]" \
                02 "S05/S05.pabiode.results/stats.S05.pabiode.odorVI+tlrc[13]" \
                03 "S06/S06.pabiode.results/stats.S06.pabiode.odorVI+tlrc[13]" \
                04 "S07/S07.pabiode.results/stats.S07.pabiode.odorVI+tlrc[13]" \
                05 "S08/S08.pabiode.results/stats.S08.pabiode.odorVI+tlrc[13]" \
                06 "S09/S09.pabiode.results/stats.S09.pabiode.odorVI+tlrc[13]" \
                07 "S10/S10.pabiode.results/stats.S10.pabiode.odorVI+tlrc[13]" \
                08 "S11/S11.pabiode.results/stats.S11.pabiode.odorVI+tlrc[13]" \
                09 "S13/S13.pabiode.results/stats.S13.pabiode.odorVI+tlrc[13]" \
                10 "S14/S14.pabiode.results/stats.S14.pabiode.odorVI+tlrc[13]" \
                11 "S16/S16.pabiode.results/stats.S16.pabiode.odorVI+tlrc[13]" \
                12 "S17/S17.pabiode.results/stats.S17.pabiode.odorVI+tlrc[13]" \
                13 "S18/S18.pabiode.results/stats.S18.pabiode.odorVI+tlrc[13]" 

# check whether the same as one-sample t-test
3dttest++ -prefix group/testcit-lim                                       \
          -mask group/bmask.nii                                       \
          -paired                                                    \
          -BminusA                                                   \
          -setA lim                                               \
                01 "S04/S04.pabiode.results/stats.S04.pabiode.odorVI+tlrc[1]" \
                02 "S05/S05.pabiode.results/stats.S05.pabiode.odorVI+tlrc[1]" \
                03 "S06/S06.pabiode.results/stats.S06.pabiode.odorVI+tlrc[1]" \
                04 "S07/S07.pabiode.results/stats.S07.pabiode.odorVI+tlrc[1]" \
                05 "S08/S08.pabiode.results/stats.S08.pabiode.odorVI+tlrc[1]" \
                06 "S09/S09.pabiode.results/stats.S09.pabiode.odorVI+tlrc[1]" \
                07 "S10/S10.pabiode.results/stats.S10.pabiode.odorVI+tlrc[1]" \
                08 "S11/S11.pabiode.results/stats.S11.pabiode.odorVI+tlrc[1]" \
                09 "S13/S13.pabiode.results/stats.S13.pabiode.odorVI+tlrc[1]" \
                10 "S14/S14.pabiode.results/stats.S14.pabiode.odorVI+tlrc[1]" \
                11 "S16/S16.pabiode.results/stats.S16.pabiode.odorVI+tlrc[1]" \
                12 "S17/S17.pabiode.results/stats.S17.pabiode.odorVI+tlrc[1]" \
                13 "S18/S18.pabiode.results/stats.S18.pabiode.odorVI+tlrc[1]" \
          -setB cit                                               \
                01 "S04/S04.pabiode.results/stats.S04.pabiode.odorVI+tlrc[10]" \
                02 "S05/S05.pabiode.results/stats.S05.pabiode.odorVI+tlrc[10]" \
                03 "S06/S06.pabiode.results/stats.S06.pabiode.odorVI+tlrc[10]" \
                04 "S07/S07.pabiode.results/stats.S07.pabiode.odorVI+tlrc[10]" \
                05 "S08/S08.pabiode.results/stats.S08.pabiode.odorVI+tlrc[10]" \
                06 "S09/S09.pabiode.results/stats.S09.pabiode.odorVI+tlrc[10]" \
                07 "S10/S10.pabiode.results/stats.S10.pabiode.odorVI+tlrc[10]" \
                08 "S11/S11.pabiode.results/stats.S11.pabiode.odorVI+tlrc[10]" \
                09 "S13/S13.pabiode.results/stats.S13.pabiode.odorVI+tlrc[10]" \
                10 "S14/S14.pabiode.results/stats.S14.pabiode.odorVI+tlrc[10]" \
                11 "S16/S16.pabiode.results/stats.S16.pabiode.odorVI+tlrc[10]" \
                12 "S17/S17.pabiode.results/stats.S17.pabiode.odorVI+tlrc[10]" \
                13 "S18/S18.pabiode.results/stats.S18.pabiode.odorVI+tlrc[10]" 