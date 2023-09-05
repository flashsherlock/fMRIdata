#!/bin/tcsh

set datafolder=/Volumes/WD_F/gufei/3T_cw/group
cd "${datafolder}"
# extract tent and beta values
set maskdec = align
set maskdec_t = at165
set suffix = de.new
set outsuffix = whole
# 8 conditions
foreach con (`count -dig 1 2 23 3`)
3dttest++ -prefix consep/ttest_con${con}_${outsuffix}                                       \
          -mask ./mask/bmask.nii                                            \
          -setA all                                                \
                01 "../S03/S03.de.results/stats.S03.${suffix}+tlrc[${con}]" \
                02 "../S04/S04.de.results/stats.S04.${suffix}+tlrc[${con}]" \
                03 "../S05/S05.de.results/stats.S05.${suffix}+tlrc[${con}]" \
                04 "../S06/S06.de.results/stats.S06.${suffix}+tlrc[${con}]" \
                05 "../S07/S07.de.results/stats.S07.${suffix}+tlrc[${con}]" \
                06 "../S08/S08.de.results/stats.S08.${suffix}+tlrc[${con}]" \
                07 "../S09/S09.de.results/stats.S09.${suffix}+tlrc[${con}]" \
                08 "../S10/S10.de.results/stats.S10.${suffix}+tlrc[${con}]" \
                09 "../S11/S11.de.results/stats.S11.${suffix}+tlrc[${con}]" \
                10 "../S12/S12.de.results/stats.S12.${suffix}+tlrc[${con}]" \
                11 "../S13/S13.de.results/stats.S13.${suffix}+tlrc[${con}]" \
                12 "../S14/S14.de.results/stats.S14.${suffix}+tlrc[${con}]" \
                13 "../S15/S15.de.results/stats.S15.${suffix}+tlrc[${con}]" \
                14 "../S16/S16.de.results/stats.S16.${suffix}+tlrc[${con}]" \
                15 "../S17/S17.de.results/stats.S17.${suffix}+tlrc[${con}]" \
                16 "../S18/S18.de.results/stats.S18.${suffix}+tlrc[${con}]" \
                17 "../S19/S19.de.results/stats.S19.${suffix}+tlrc[${con}]" \
                18 "../S20/S20.de.results/stats.S20.${suffix}+tlrc[${con}]" \
                19 "../S21/S21.de.results/stats.S21.${suffix}+tlrc[${con}]" \
                20 "../S22/S22.de.results/stats.S22.${suffix}+tlrc[${con}]" \
                21 "../S23/S23.de.results/stats.S23.${suffix}+tlrc[${con}]" \
                22 "../S24/S24.de.results/stats.S24.${suffix}+tlrc[${con}]" \
                23 "../S25/S25.de.results/stats.S25.${suffix}+tlrc[${con}]" \
                24 "../S26/S26.de.results/stats.S26.${suffix}+tlrc[${con}]" \
                25 "../S27/S27.de.results/stats.S27.${suffix}+tlrc[${con}]" \
                26 "../S28/S28.de.results/stats.S28.${suffix}+tlrc[${con}]" \
                27 "../S29/S29.de.results/stats.S29.${suffix}+tlrc[${con}]"
end
# any sig
3dcalc  -a consep/ttest_con2_${outsuffix}+tlrc \
        -b consep/ttest_con5_${outsuffix}+tlrc \
        -c consep/ttest_con8_${outsuffix}+tlrc \
        -d consep/ttest_con11_${outsuffix}+tlrc \
        -e consep/ttest_con14_${outsuffix}+tlrc \
        -f consep/ttest_con17_${outsuffix}+tlrc \
        -g consep/ttest_con20_${outsuffix}+tlrc \
        -h consep/ttest_con23_${outsuffix}+tlrc \
        -i ./mask/bmask.nii \
        -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65),astep(e,1.65),astep(f,1.65),astep(g,1.65),astep(h,1.65))*i' \
        -prefix ./mask/whole_any_${maskdec_t}

# foreach region (FFA fusiform)

# end
