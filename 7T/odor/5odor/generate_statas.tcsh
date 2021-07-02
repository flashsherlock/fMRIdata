#!/bin/tcsh
# set sub=S01_yyt
# use input as sub
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"
set analysis=pabiode

# switch ($2)
#     case bio:
#         set analysis=pabiode
#         breaksw
#     case phy:
#         set analysis=paphde
#         breaksw
#     case no:
#         set analysis=pade
#         breaksw
#     default:
#         echo The second input must be bio, phy or no.
#         echo ${analysis}
# endsw

echo ${sub} ${analysis}

# run the regression analysis
set subj = ${sub}.${analysis}
set subjva = ${subj}.odorVI
cd ${subj}.results

# rename
# mv tent.${subj}.odorVI_noblur+orig.BRIK tent.${subj}.odorVI+orig.BRIK
# mv tent.${subj}.odorVI_noblur+orig.HEAD tent.${subj}.odorVI+orig.HEAD
# foreach data (errts fitts stats)
#     mv ${data}.${subj}.odorVI_noblur+orig.BRIK ${data}.${subj}.odorVI+orig.BRIK
#     mv ${data}.${subj}.odorVI_noblur+orig.HEAD ${data}.${subj}.odorVI+orig.HEAD
# end
# mv X.odorVI_noblur.jpg X.odorVI.jpg
# mv X.nocensor.odorVI_noblur.xmat.1D X.nocensor.odorVI.xmat.1D
# mv X.xmat.odorVI_noblur.1D X.xmat.odorVI.1D
# mv X.tent.odorVI_noblur.jpg X.tent.odorVI.jpg
# mv X.xmat.tent.odorVI_noblur.1D X.xmat.tent.odorVI.1D

# # auto tlrc to MNI space
# # normalize Anatomical img to mni space
# @auto_tlrc -no_ss -init_xform AUTO_CENTER -maxite 500 -base ~/abin/MNI152_T1_2009c+tlrc. -input anat_final.${sub}.${analysis}+orig
# # align to nomalized Anatomical img
# @auto_tlrc -apar anat_final.${sub}.${analysis}+tlrc -input stats.${subj}+orig
# rm *t165.freesurfer*
# rm ../mask/*at165*

# Print number of voxels for each ROI
# 3dROIstats -nzvoxels -mask Amy.seg_t165.freesurfer+orig.HEAD Amy.seg_t165.freesurfer+orig.HEAD >! ../mask/voxels_act.txt

# # create mask for each region
# foreach region (1 3 5 6 7 8 9 10 15)
#     3dcalc -a Amy.seg_t165.freesurfer+orig -expr "equals(a,${region})" -prefix ../mask/Amy_at165${region}seg.freesurfer+orig
# end

# extract tent and beta values
set filedec = odorVI_noblur
set maskdec = align # at165 or align
set maskdec_t = at196 # at165 or align
set data_tent=tent.${subj}.${filedec}+orig
set data_beta=stats.${subj}.odorVI+orig

# make dir
if (! -e ../../stats) then
    mkdir ../../stats
endif
if (! -e ../../stats/${sub}) then
    mkdir ../../stats/${sub}
endif

foreach region (Pir_new Pir_old APC_new APC_old PPC)
    # generate t threshold masks
    # different regions of amygdala
    3dcalc  -a stats.${subjva}+orig'[2]' \
            -b stats.${subjva}+orig'[5]' \
            -c stats.${subjva}+orig'[8]' \
            -d stats.${subjva}+orig'[11]' \
            -e stats.${subjva}+orig'[14]' \
            -f ../mask/${region}.draw+orig \
            -expr 'or(astep(a,1.96),astep(b,1.96),astep(c,1.96),astep(d,1.96),astep(e,1.96))*f' \
            -prefix ../mask/${region}_${maskdec_t}.draw

    3dROIstats -mask ../mask/${region}_${maskdec_t}.draw+orig \
    -nzmean ${data_tent}"[`seq -s , 1 54`55]" >! ../../stats/${sub}/${region}_${maskdec_t}_tent.txt

    # extract betas from blurred statas
    # 3dROIstats -mask ../mask/${region}_${maskdec}.freesurfer+orig \
    # -nzmean ${data_beta}"[`seq -s , 1 3 9`10]" >! ../../stats/${sub}/${region}_${maskdec}_beta.txt
end

foreach region (Amy9 Amy8 corticalAmy CeMeAmy BaLaAmy)
     3dcalc  -a stats.${subjva}+orig'[2]' \
            -b stats.${subjva}+orig'[5]' \
            -c stats.${subjva}+orig'[8]' \
            -d stats.${subjva}+orig'[11]' \
            -e stats.${subjva}+orig'[14]' \
            -f ../mask/${region}_${maskdec}.freesurfer+orig \
            -expr 'or(astep(a,1.96),astep(b,1.96),astep(c,1.96),astep(d,1.96),astep(e,1.96))*f' \
            -prefix ../mask/${region}_${maskdec_t}.freesurfer

    3dROIstats -mask ../mask/${region}_${maskdec_t}.freesurfer+orig \
    -nzmean ${data_tent}"[`seq -s , 1 54`55]" >! ../../stats/${sub}/${region}_${maskdec_t}_tent.txt

    # extract betas from blurred statas
    # 3dROIstats -mask ../mask/${region}_${maskdec}.freesurfer+orig \
    # -nzmean ${data_beta}"[`seq -s , 1 3 9`10]" >! ../../stats/${sub}/${region}_${maskdec}_beta.txt
end

# foreach region (1 3 5 6 7 8 9 10 15)
#     3dROIstats -mask ../mask/Amy_${maskdec}${region}seg.freesurfer+orig \
#     -nzmean ${data_tent_va}"[`seq -s , 1 43`44]" >! ../../stats/${sub}/Amy_${maskdec}${region}seg_tentva.txt
#     3dROIstats -mask ../mask/Amy_${maskdec}${region}seg.freesurfer+orig \
#     -nzmean ${data_tent}"[`seq -s , 1 43`44]" >! ../../stats/${sub}/Amy_${maskdec}${region}seg_tent.txt

#     # 3dROIstats -mask ../mask/Amy_${maskdec}${region}seg.freesurfer+orig \
#     # -nzmean ${data_beta}"[`seq -s , 1 3 9`10]" >! ../../stats/${sub}/Amy_${maskdec}${region}seg_beta.txt
# end

# # extract beta values from each voxel
# 3dmaskdump -mask ../mask/sAmy.freesurfer+orig   \
#     -mrange 1 15                                \
#     -o ../../stats/${sub}/sAmy_betadiff.txt     \
#     ../mask/sAmy.freesurfer+orig                \
#     ${data_beta}"[`seq -s , 1 3 12`13,`seq -s , 2 3 13`14]"
#     # -o option can not replace exsisting files
#     # >! ../../stats/${sub}/sAmy_betadiff.txt
# # Piriform
# 3dmaskdump -mask Piriform.seg+orig                   \
#     -o ../../stats/${sub}/sPir_betadiff.txt     \
#     Piriform.seg+orig                                \
#     ${data_beta}"[`seq -s , 1 3 12`13,`seq -s , 2 3 13`14]"
#     # -o option can not replace exsisting files
#     # >! ../../stats/${sub}/sAmy_betadiff.txt

else
 echo "Usage: $0 <Subjname> <analysis>"

endif
