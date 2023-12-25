#! /bin/bash

# datafolder=/Volumes/WD_E/gufei/3t_cw
datafolder=/Volumes/WD_F/gufei/3t_cw
cd "${datafolder}" || exit

mask=group/mask/bmask.nii
sm="_sm"
out=whole${sm}
stats="trans_shift6"
statsn="trans"

3dttest++ -prefix group/mvpa/${statsn}_test_inv_${out}4r -mask ${mask} -resid group/mvpa/errs_${statsn}_test_inv_${out}4r -setA test_inv \
01 "S03/S03.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
02 "S04/S04.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
03 "S05/S05.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
04 "S06/S06.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
05 "S07/S07.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
06 "S08/S08.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
07 "S09/S09.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
08 "S10/S10.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
09 "S11/S11.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
10 "S12/S12.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
11 "S13/S13.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
12 "S14/S14.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
13 "S15/S15.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
14 "S16/S16.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
15 "S17/S17.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
16 "S18/S18.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
17 "S19/S19.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
18 "S20/S20.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
19 "S21/S21.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
20 "S22/S22.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
21 "S23/S23.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
22 "S24/S24.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
23 "S25/S25.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
24 "S26/S26.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
25 "S27/S27.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
26 "S28/S28.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
27 "S29/S29.de.results/mvpa/searchlight_${stats}/test_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" 

3dttest++ -prefix group/mvpa/${statsn}_train_inv_${out}4r -mask ${mask} -resid group/mvpa/errs_${statsn}_train_inv_${out}4r -setA train_inv \
01 "S03/S03.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
02 "S04/S04.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
03 "S05/S05.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
04 "S06/S06.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
05 "S07/S07.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
06 "S08/S08.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
07 "S09/S09.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
08 "S10/S10.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
09 "S11/S11.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
10 "S12/S12.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
11 "S13/S13.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
12 "S14/S14.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
13 "S15/S15.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
14 "S16/S16.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
15 "S17/S17.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
16 "S18/S18.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
17 "S19/S19.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
18 "S20/S20.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
19 "S21/S21.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
20 "S22/S22.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
21 "S23/S23.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
22 "S24/S24.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
23 "S25/S25.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
24 "S26/S26.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
25 "S27/S27.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
26 "S28/S28.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" \
27 "S29/S29.de.results/mvpa/searchlight_${stats}/train_inv_epi_anat/res_accuracy_minus_chance${sm}+tlrc" 

