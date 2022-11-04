#! /bin/bash

# datafolder=/Volumes/WD_E/gufei/7T_odor
datafolder=/Volumes/WD_F/gufei/7T_odor
cd "${datafolder}" || exit

mask=group/mask/allROI+tlrc
stats=VIvaodor_l1_label

3dttest++ -prefix group/mvpa/${stats}_lim-tra -mask ${mask} -setA lim-tra \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_tra/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${stats}_lim-car -mask ${mask} -setA lim-car \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_car/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${stats}_lim-cit -mask ${mask} -setA lim-cit \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_cit/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${stats}_lim-ind -mask ${mask} -setA lim-ind \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_lim_ind/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${stats}_tra-car -mask ${mask} -setA tra-car \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_car/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${stats}_tra-cit -mask ${mask} -setA tra-cit \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_cit/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${stats}_tra-ind -mask ${mask} -setA tra-ind \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_tra_ind/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${stats}_car-cit -mask ${mask} -setA car-cit \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_cit/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${stats}_car-ind -mask ${mask} -setA car-ind \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_car_ind/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${stats}_cit-ind -mask ${mask} -setA cit-ind \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}_6/BoxROI/2odors_cit_ind/res_accuracy_minus_chance+tlrc" 

