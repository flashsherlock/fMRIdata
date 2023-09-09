#!/bin/tcsh

# for subs from 01 to 04
foreach ub (`count -dig 2 3 29`)
set sub=S${ub}
set datafolder=/Volumes/WD_F/gufei/3T_cw/${sub}
# if sub folder not exsist then continue
if (! -e ${datafolder}) then
    echo ${datafolder} not exsist
    continue
endif
cd "${datafolder}"
set analysis=de
echo ${sub} ${analysis}
# cd to the folder
set subj = ${sub}.${analysis}
set subjva = ${subj}.new
cd ${subj}.results

# warp to standard space
set name = stats.${subjva}
# 3dNwarpApply -nwarp "anatQQ.${sub}_WARP.nii anatQQ.${sub}.aff12.1D INV(anatSS.${sub}_al_keep_mat.aff12.1D)"   \
#              -source ${name}+orig                                                 \
#              -master anatQQ.${sub}+tlrc    \
#              -prefix ${name}
# # refit type
# 3drefit -fbuc ${name}+tlrc

# extract tent and beta values
set filedec = odor_14
set maskdec = align
set maskdec_t2 = at165
set maskdec_t = ${maskdec_t2}_p # positive only for tent
set data_tent=tent.${subj}.${filedec}+orig
set data_beta=stats.${subjva}+orig

# make dir
if (! -e ../../stats) then
    mkdir ../../stats
endif
if (! -e ../../stats/${sub}) then
    mkdir ../../stats/${sub}
endif

foreach region (FFA fusiform FFA_CA fusiformCA)

    # rm ../mask/${region}_${maskdec_t2}*
    # rm ../mask/${region}_${maskdec_t}*

    # generate t threshold masks
    # different regions of amygdala
    3dcalc  -a ${data_beta}'[2]' \
            -b ${data_beta}'[5]' \
            -c ${data_beta}'[8]' \
            -d ${data_beta}'[11]' \
            -e ${data_beta}'[14]' \
            -f ${data_beta}'[17]' \
            -g ${data_beta}'[20]' \
            -h ${data_beta}'[23]' \
            -i ../mask/${region}+orig \
            -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65),astep(e,1.65),astep(f,1.65),astep(g,1.65),astep(h,1.65))*i' \
            -prefix ../mask/${region}_${maskdec_t2}

    3dcalc  -a ${data_beta}'[2]' \
            -b ${data_beta}'[5]' \
            -c ${data_beta}'[8]' \
            -d ${data_beta}'[11]' \
            -e ${data_beta}'[14]' \
            -f ${data_beta}'[17]' \
            -g ${data_beta}'[20]' \
            -h ${data_beta}'[23]' \
            -i ../mask/${region}+orig \
            -expr 'or(step(a-1.65),step(b-1.65),step(c-1.65),step(d-1.65),step(e-1.65),step(f-1.65),step(g-1.65),step(h-1.65))*i' \
            -prefix ../mask/${region}_${maskdec_t}

     # all significant voxels
    3dROIstats -mask ../mask/${region}_${maskdec_t2}+orig \
    -nzmean ${data_tent}"[`seq -s , 1 63`64]" >! ../../stats/${sub}/${region}_${maskdec_t}_tent_14.txt
    # posistive only
    3dROIstats -mask ../mask/${region}_${maskdec_t}+orig \
    -nzmean ${data_tent}"[`seq -s , 1 63`64]" >! ../../stats/${sub}/${region}_${maskdec_t}_tent_14p.txt
end

# foreach region (Pir_new Pir_old APC_new APC_old PPC)

#     # rm ../mask/${region}_${maskdec_t2}.draw*
#     # rm ../mask/${region}_${maskdec_t}.draw*

#     # generate t threshold masks
#     # different regions of amygdala
#     3dcalc  -a ${data_beta}'[2]' \
#             -b ${data_beta}'[5]' \
#             -c ${data_beta}'[8]' \
#             -d ${data_beta}'[11]' \
#             -e ${data_beta}'[14]' \
#             -f ${data_beta}'[17]' \
#             -g ${data_beta}'[20]' \
#             -h ${data_beta}'[23]' \
#             -i ../mask/${region}.draw+orig \
#             -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65),astep(e,1.65),astep(f,1.65),astep(g,1.65),astep(h,1.65))*i' \
#             -prefix ../mask/${region}_${maskdec_t2}.draw

#     3dcalc  -a ${data_beta}'[2]' \
#             -b ${data_beta}'[5]' \
#             -c ${data_beta}'[8]' \
#             -d ${data_beta}'[11]' \
#             -e ${data_beta}'[14]' \
#             -f ${data_beta}'[17]' \
#             -g ${data_beta}'[20]' \
#             -h ${data_beta}'[23]' \
#             -i ../mask/${region}.draw+orig \
#             -expr 'or(step(a-1.65),step(b-1.65),step(c-1.65),step(d-1.65),step(e-1.65),step(f-1.65),step(g-1.65),step(h-1.65))*i' \
#             -prefix ../mask/${region}_${maskdec_t}.draw

#     # all significant voxels
#     3dROIstats -mask ../mask/${region}_${maskdec_t2}.draw+orig \
#     -nzmean ${data_tent}"[`seq -s , 1 63`64]" >! ../../stats/${sub}/${region}_${maskdec_t}_tent_14.txt
#     # posistive only
#     3dROIstats -mask ../mask/${region}_${maskdec_t}.draw+orig \
#     -nzmean ${data_tent}"[`seq -s , 1 63`64]" >! ../../stats/${sub}/${region}_${maskdec_t}_tent_14p.txt
# end

# foreach region (Amy9 Amy8 corticalAmy CeMeAmy BaLaAmy )

#     # rm ../mask/${region}_${maskdec_t2}.freesurfer*
#     # rm ../mask/${region}_${maskdec_t}.freesurfer*

#     3dcalc  -a ${data_beta}'[2]' \
#             -b ${data_beta}'[5]' \
#             -c ${data_beta}'[8]' \
#             -d ${data_beta}'[11]' \
#             -e ${data_beta}'[14]' \
#             -f ${data_beta}'[17]' \
#             -g ${data_beta}'[20]' \
#             -h ${data_beta}'[23]' \
#             -i ../mask/${region}_${maskdec}.freesurfer+orig \
#             -expr 'or(astep(a,1.65),astep(b,1.65),astep(c,1.65),astep(d,1.65),astep(e,1.65),astep(f,1.65),astep(g,1.65),astep(h,1.65))*i' \
#             -prefix ../mask/${region}_${maskdec_t2}.freesurfer
    
#     3dcalc  -a ${data_beta}'[2]' \
#             -b ${data_beta}'[5]' \
#             -c ${data_beta}'[8]' \
#             -d ${data_beta}'[11]' \
#             -e ${data_beta}'[14]' \
#             -f ${data_beta}'[17]' \
#             -g ${data_beta}'[20]' \
#             -h ${data_beta}'[23]' \
#             -i ../mask/${region}_${maskdec}.freesurfer+orig \
#             -expr 'or(step(a-1.65),step(b-1.65),step(c-1.65),step(d-1.65),step(e-1.65),step(f-1.65),step(g-1.65),step(h-1.65))*i' \
#             -prefix ../mask/${region}_${maskdec_t}.freesurfer
#     # all significant voxels
#     3dROIstats -mask ../mask/${region}_${maskdec_t2}.freesurfer+orig \
#     -nzmean ${data_tent}"[`seq -s , 1 63`64]" >! ../../stats/${sub}/${region}_${maskdec_t}_tent_14.txt
#     # posistive only
#     3dROIstats -mask ../mask/${region}_${maskdec_t}.freesurfer+orig \
#     -nzmean ${data_tent}"[`seq -s , 1 63`64]" >! ../../stats/${sub}/${region}_${maskdec_t}_tent_14p.txt
#     # rename
#     # mv ../../stats/${sub}/${region}_${maskdec_t}_tent11s_14.txt ../../stats/${sub}/${region}_${maskdec_t}_tent_14.txt
#     # mv ../../stats/${sub}/${region}_${maskdec_t}_tent11s_14p.txt ../../stats/${sub}/${region}_${maskdec_t}_tent_14p.txt

# end

end
