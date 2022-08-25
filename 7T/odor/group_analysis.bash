#! /bin/bash

datafolder=/Volumes/WD_E/gufei/7T_odor
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

# 3dttest for subs 4-18
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
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[31]" 

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
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[34]" 

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
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[22]" 

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
                13 "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[13]" 

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
tthr=$(ccalc -expr "cdf2stat(0.975,3,12,0,0)")
# individual level t threshold
tthri=1.96
# extract voxels with p-values below the threshold
3dcalc \
-a "group/${stats}_car-lim+tlrc[1]" \
-b "group/${stats}_cit-lim+tlrc[1]" \
-expr "astep(a,${tthr})+astep(b,${tthr})*10" \
-prefix group/combine_car_cit

# ab(cit-lim) and abs(car-lim)
3dcalc \
-a "group/${stats}_car-lim+tlrc[1]" \
-expr "abs(a)" \
-prefix group/${stats}_abs_car_lim

3dcalc \
-a "group/${stats}_cit-lim+tlrc[1]" \
-expr "abs(a)" \
-prefix group/${stats}_abs_cit_lim

# valance and intensity rating screen (not odor_va)
# 3dcalc \
# -a "group/${stats}_val+tlrc[1]" \
# -b "group/${stats}_int+tlrc[1]" \
# -expr "astep(a,${tthr})+astep(b,${tthr})*10" \
# -prefix group/combine_val_int

# all 4 lim pairs
3dcalc \
-a "group/${stats}_car-lim+tlrc[1]" \
-b "group/${stats}_cit-lim+tlrc[1]" \
-c "group/${stats}_lim-tra+tlrc[1]" \
-d "group/${stats}_lim-ind+tlrc[1]" \
-expr "astep(a,${tthr})+astep(b,${tthr})*10+astep(c,${tthr})*20+astep(d,${tthr})*50" \
-prefix group/combine_4lim

# percent of subjects activated in each voxel
# # rm group/*percent*
3dcalc -prefix group/${stats}_car-lim_percent                           \
      -a ${mask}                                                        \
      -b "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[32]" \
      -c "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[32]" \
      -d "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[32]" \
      -e "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[32]" \
      -f "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[32]" \
      -g "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[32]" \
      -h "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[32]" \
      -i "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[32]" \
      -j "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[32]" \
      -k "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[32]" \
      -l "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[32]" \
      -m "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[32]" \
      -n "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[32]" \
      -expr "a*(mean(astep(b,${tthri}),astep(c,${tthri}),astep(d,${tthri}),astep(e,${tthri}),astep(f,${tthri}),astep(g,${tthri}),astep(h,${tthri}),astep(i,${tthri}),astep(j,${tthri}),astep(k,${tthri}),astep(l,${tthri}),astep(m,${tthri}),astep(n,${tthri})))"

3dcalc -prefix group/${stats}_cit-lim_percent                           \
      -a ${mask}                                                        \
      -b "S04/S04.pabiode.results/${stats}.S04.pabiode.odorVI+tlrc[35]" \
      -c "S05/S05.pabiode.results/${stats}.S05.pabiode.odorVI+tlrc[35]" \
      -d "S06/S06.pabiode.results/${stats}.S06.pabiode.odorVI+tlrc[35]" \
      -e "S07/S07.pabiode.results/${stats}.S07.pabiode.odorVI+tlrc[35]" \
      -f "S08/S08.pabiode.results/${stats}.S08.pabiode.odorVI+tlrc[35]" \
      -g "S09/S09.pabiode.results/${stats}.S09.pabiode.odorVI+tlrc[35]" \
      -h "S10/S10.pabiode.results/${stats}.S10.pabiode.odorVI+tlrc[35]" \
      -i "S11/S11.pabiode.results/${stats}.S11.pabiode.odorVI+tlrc[35]" \
      -j "S13/S13.pabiode.results/${stats}.S13.pabiode.odorVI+tlrc[35]" \
      -k "S14/S14.pabiode.results/${stats}.S14.pabiode.odorVI+tlrc[35]" \
      -l "S16/S16.pabiode.results/${stats}.S16.pabiode.odorVI+tlrc[35]" \
      -m "S17/S17.pabiode.results/${stats}.S17.pabiode.odorVI+tlrc[35]" \
      -n "S18/S18.pabiode.results/${stats}.S18.pabiode.odorVI+tlrc[35]" \
      -expr "a*(mean(astep(b,${tthri}),astep(c,${tthri}),astep(d,${tthri}),astep(e,${tthri}),astep(f,${tthri}),astep(g,${tthri}),astep(h,${tthri}),astep(i,${tthri}),astep(j,${tthri}),astep(k,${tthri}),astep(l,${tthri}),astep(m,${tthri}),astep(n,${tthri})))"

3dcalc -prefix group/${stats}_carcit_percent                           \
      -a group/${stats}_car-lim_percent+tlrc                           \
      -b group/${stats}_cit-lim_percent+tlrc                           \
      -expr "b-a"

3dttest++ -prefix group/stats_cit-car_abs                               \
          -mask ${mask}                                                 \
          -setA cit_lim-car-lim                                         \
                01 "S04/S04.pabiode.results/citcar.S04.pabiode+tlrc" \
                02 "S05/S05.pabiode.results/citcar.S05.pabiode+tlrc" \
                03 "S06/S06.pabiode.results/citcar.S06.pabiode+tlrc" \
                04 "S07/S07.pabiode.results/citcar.S07.pabiode+tlrc" \
                05 "S08/S08.pabiode.results/citcar.S08.pabiode+tlrc" \
                06 "S09/S09.pabiode.results/citcar.S09.pabiode+tlrc" \
                07 "S10/S10.pabiode.results/citcar.S10.pabiode+tlrc" \
                08 "S11/S11.pabiode.results/citcar.S11.pabiode+tlrc" \
                09 "S13/S13.pabiode.results/citcar.S13.pabiode+tlrc" \
                10 "S14/S14.pabiode.results/citcar.S14.pabiode+tlrc" \
                11 "S16/S16.pabiode.results/citcar.S16.pabiode+tlrc" \
                12 "S17/S17.pabiode.results/citcar.S17.pabiode+tlrc" \
                13 "S18/S18.pabiode.results/citcar.S18.pabiode+tlrc" 
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