#!/bin/tcsh

set datafolder=/Volumes/WD_F/gufei/3T_cw/group
cd "${datafolder}"
# extract tent and beta values
set maskdec = align
set maskdec_t = at165
set suffix = de.new
set outsuffix = whole
# 8 conditions
foreach con (`count -dig 1 1 22 3`)
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
# if results exist then delete
if ( -e ./mask/whole_any_${maskdec_t}+tlrc.HEAD ) then
    rm ./mask/whole_any_${maskdec_t}+tlrc.*
endif
3dcalc  -a "consep/ttest_con1_${outsuffix}+tlrc[1]" \
        -b "consep/ttest_con4_${outsuffix}+tlrc[1]" \
        -c "consep/ttest_con7_${outsuffix}+tlrc[1]" \
        -d "consep/ttest_con10_${outsuffix}+tlrc[1]" \
        -e "consep/ttest_con13_${outsuffix}+tlrc[1]" \
        -f "consep/ttest_con16_${outsuffix}+tlrc[1]" \
        -g "consep/ttest_con19_${outsuffix}+tlrc[1]" \
        -h "consep/ttest_con22_${outsuffix}+tlrc[1]" \
        -i ./mask/bmask.nii \
        -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65),astep(e,1.65),astep(f,1.65),astep(g,1.65),astep(h,1.65))*i' \
        -prefix ./mask/whole_any_${maskdec_t}
if ( -e ./mask/whole_anyvis_${maskdec_t}+tlrc.HEAD ) then
    rm ./mask/whole_anyvis_${maskdec_t}+tlrc.*
endif
3dcalc  -a "consep/ttest_con1_${outsuffix}+tlrc[1]" \
        -b "consep/ttest_con7_${outsuffix}+tlrc[1]" \
        -c "consep/ttest_con13_${outsuffix}+tlrc[1]" \
        -d "consep/ttest_con19_${outsuffix}+tlrc[1]" \
        -e ./mask/bmask.nii \
        -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65))*e' \
        -prefix ./mask/whole_anyvis_${maskdec_t}
if ( -e ./mask/whole_anyinv_${maskdec_t}+tlrc.HEAD ) then
    rm ./mask/whole_anyinv_${maskdec_t}+tlrc.*
endif
3dcalc  -a "consep/ttest_con4_${outsuffix}+tlrc[1]" \
        -b "consep/ttest_con10_${outsuffix}+tlrc[1]" \
        -c "consep/ttest_con16_${outsuffix}+tlrc[1]" \
        -d "consep/ttest_con22_${outsuffix}+tlrc[1]" \
        -e ./mask/bmask.nii \
        -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65))*e' \
        -prefix ./mask/whole_anyinv_${maskdec_t}

# Visable > Invisible
3dttest++ -prefix consep/ttest_vis_${outsuffix}                                       \
          -mask ./mask/bmask.nii                                            \
          -setA all                                                \
                01 "../S03/S03.de.results/stats.S03.${suffix}+tlrc[52]" \
                02 "../S04/S04.de.results/stats.S04.${suffix}+tlrc[52]" \
                03 "../S05/S05.de.results/stats.S05.${suffix}+tlrc[52]" \
                04 "../S06/S06.de.results/stats.S06.${suffix}+tlrc[52]" \
                05 "../S07/S07.de.results/stats.S07.${suffix}+tlrc[52]" \
                06 "../S08/S08.de.results/stats.S08.${suffix}+tlrc[52]" \
                07 "../S09/S09.de.results/stats.S09.${suffix}+tlrc[52]" \
                08 "../S10/S10.de.results/stats.S10.${suffix}+tlrc[52]" \
                09 "../S11/S11.de.results/stats.S11.${suffix}+tlrc[52]" \
                10 "../S12/S12.de.results/stats.S12.${suffix}+tlrc[52]" \
                11 "../S13/S13.de.results/stats.S13.${suffix}+tlrc[52]" \
                12 "../S14/S14.de.results/stats.S14.${suffix}+tlrc[52]" \
                13 "../S15/S15.de.results/stats.S15.${suffix}+tlrc[52]" \
                14 "../S16/S16.de.results/stats.S16.${suffix}+tlrc[52]" \
                15 "../S17/S17.de.results/stats.S17.${suffix}+tlrc[52]" \
                16 "../S18/S18.de.results/stats.S18.${suffix}+tlrc[52]" \
                17 "../S19/S19.de.results/stats.S19.${suffix}+tlrc[52]" \
                18 "../S20/S20.de.results/stats.S20.${suffix}+tlrc[52]" \
                19 "../S21/S21.de.results/stats.S21.${suffix}+tlrc[52]" \
                20 "../S22/S22.de.results/stats.S22.${suffix}+tlrc[52]" \
                21 "../S23/S23.de.results/stats.S23.${suffix}+tlrc[52]" \
                22 "../S24/S24.de.results/stats.S24.${suffix}+tlrc[52]" \
                23 "../S25/S25.de.results/stats.S25.${suffix}+tlrc[52]" \
                24 "../S26/S26.de.results/stats.S26.${suffix}+tlrc[52]" \
                25 "../S27/S27.de.results/stats.S27.${suffix}+tlrc[52]" \
                26 "../S28/S28.de.results/stats.S28.${suffix}+tlrc[52]" \
                27 "../S29/S29.de.results/stats.S29.${suffix}+tlrc[52]"
# generate mask of voxels vis > inv 
if ( -e ./mask/whole_vis_${maskdec_t}+tlrc.HEAD ) then
    rm ./mask/whole_vis_${maskdec_t}+tlrc.*
endif
3dcalc  -a "consep/ttest_vis_${outsuffix}+tlrc[1]" \
        -b ./mask/bmask.nii \
        -expr 'step(a-1.65)*b' \
        -prefix ./mask/whole_vis_${maskdec_t}
# generate mask of voxels vis < inv
if ( -e ./mask/whole_inv_${maskdec_t}+tlrc.HEAD ) then
    rm ./mask/whole_inv_${maskdec_t}+tlrc.*
endif
3dcalc  -a "consep/ttest_vis_${outsuffix}+tlrc[1]" \
        -b ./mask/bmask.nii \
        -expr 'step(-a-1.65)*b' \
        -prefix ./mask/whole_inv_${maskdec_t}
# generate mask of voxels vis > inv in fusiform
3dcalc  -a "consep/ttest_vis_${outsuffix}+tlrc[1]" \
        -b ./mask/FusiformCA+tlrc \
        -expr 'step(a-1.65)*b' \
        -prefix ./mask/FFV
# generate mask of voxels different in vis and inv in fusiform
rm ./mask/FFV0*
3dcalc  -a "consep/ttest_vis_${outsuffix}+tlrc[1]" \
        -b ./mask/FusiformCA+tlrc \
        -expr 'step(a-2.78)*b' \
        -prefix ./mask/FFV01
3dcalc  -a "consep/ttest_vis_${outsuffix}+tlrc[1]" \
        -b ./mask/FusiformCA+tlrc \
        -expr 'step(a-3.07)*b' \
        -prefix ./mask/FFV005
# Fusiform from aal atlas
3dcalc  -a "consep/ttest_vis_${outsuffix}+tlrc[1]" \
        -b ./mask/FusiformAAL+tlrc \
        -expr 'step(a-1.65)*b' \
        -prefix ./mask/FFVAAL
3dcalc  -a "consep/ttest_vis_${outsuffix}+tlrc[1]" \
        -b ./mask/FusiformAAL+tlrc \
        -expr 'step(a-2.05)*b' \
        -prefix ./mask/FFVAAL05
3dcalc  -a "consep/ttest_vis_${outsuffix}+tlrc[1]" \
        -b ./mask/FusiformAAL+tlrc \
        -expr 'step(a-2.78)*b' \
        -prefix ./mask/FFVAAL01
3dcalc  -a "consep/ttest_vis_${outsuffix}+tlrc[1]" \
        -b ./mask/FusiformAAL+tlrc \
        -expr 'step(a-3.71)*b' \
        -prefix ./mask/FFVAAL001
# generate mask of voxels sig in all conditions
3dcalc  -a "ttest_${outsuffix}odors+tlrc[1]" \
        -b ./mask/bmask.nii \
        -expr 'astep(a,1.65)*b' \
        -prefix ./mask/whole_odors
3dcalc  -a "ttest_${outsuffix}odors+tlrc[1]" \
        -b ./mask/bmask.nii \
        -expr 'astep(a,2.05)*b' \
        -prefix ./mask/whole_odors05
3dcalc  -a "ttest_${outsuffix}odors+tlrc[1]" \
        -b ./mask/bmask.nii \
        -expr 'astep(a,2.78)*b' \
        -prefix ./mask/whole_odors01
3dcalc  -a "ttest_${outsuffix}odors+tlrc[1]" \
        -b ./mask/bmask.nii \
        -expr 'astep(a,3.07)*b' \
        -prefix ./mask/whole_odors005
3dcalc  -a "ttest_${outsuffix}odors+tlrc[1]" \
        -b ./mask/bmask.nii \
        -expr 'astep(a,3.71)*b' \
        -prefix ./mask/whole_odors001