#! /bin/bash

# datafolder=/Volumes/WD_E/gufei/7T_odor
datafolder=/Volumes/WD_F/gufei/7T_odor
cd "${datafolder}" || exit

mask=group/mask/allROI+tlrc
stats="ARodor_l1_labelbase_-6-36"
statsn="ARodor_l1_extbase"

3dttest++ -prefix group/mvpa/${statsn}_lim-tra -mask ${mask} -setA lim-tra \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_tra/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${statsn}_lim-car -mask ${mask} -setA lim-car \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_car/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${statsn}_lim-cit -mask ${mask} -setA lim-cit \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_cit/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${statsn}_lim-ind -mask ${mask} -setA lim-ind \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_lim_ind/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${statsn}_tra-car -mask ${mask} -setA tra-car \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_car/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${statsn}_tra-cit -mask ${mask} -setA tra-cit \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_cit/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${statsn}_tra-ind -mask ${mask} -setA tra-ind \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_tra_ind/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${statsn}_car-cit -mask ${mask} -setA car-cit \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_cit/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${statsn}_car-ind -mask ${mask} -setA car-ind \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_car_ind/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${statsn}_cit-ind -mask ${mask} -setA cit-ind \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/2odors_cit_ind/res_accuracy_minus_chance+tlrc" 

3dttest++ -prefix group/mvpa/${statsn}_citcar -mask ${mask} -setA citcar \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar+tlrc" 

3dttest++ -prefix group/mvpa/${statsn}_citcar_norm -mask ${mask} -setA citcar_norm \
01 "S04/S04.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
02 "S05/S05.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
03 "S06/S06.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
04 "S07/S07.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
05 "S08/S08.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
06 "S09/S09.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
07 "S10/S10.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
08 "S11/S11.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
09 "S13/S13.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
10 "S14/S14.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
11 "S16/S16.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
12 "S17/S17.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
13 "S18/S18.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
14 "S19/S19.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
15 "S20/S20.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
16 "S21/S21.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
17 "S22/S22.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
18 "S23/S23.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
19 "S24/S24.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
20 "S25/S25.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
21 "S26/S26.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
22 "S27/S27.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
23 "S28/S28.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
24 "S29/S29.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
25 "S31/S31.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
26 "S32/S32.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
27 "S33/S33.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" \
28 "S34/S34.pabiode.results/mvpa/searchlight_${stats}/BoxROIext/citcar_norm+tlrc" 

