#! /bin/csh
# foreach ub (`count -dig 2 4 11` 13 14 `count -dig 2 16 29` 31 32 33 34)
foreach ub (`count -dig 2 $1 $2`)
set sub = S${ub}
# foreach sub (S01_yyt S01 S02 S03)
# set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/OlfDisk2/gf/7T_odor/${sub}
set datafolder=/Volumes/WD_F/gufei/7T_odor/${sub}
# if datafolder exist
if ( -d "${datafolder}" ) then
cd "${datafolder}"
# make dir to save masks
set analysis=pabiode
set subj = ${sub}.${analysis}
# rm -r ${sub}.pabioe2a.results
cd ${subj}.results
# move piriform roi to mask folder
# mv Piriform.seg* ../mask
# mv ../${subj}.results.old/Piriform.seg* ../mask
@ pbvol = `ls pb0?.*.r01.volreg+orig.HEAD | cut -d . -f1 | cut -c3-4` - 1    
@ blurvol = `ls pb0?.*.r01.blur+orig.HEAD | cut -d . -f1 | cut -c3-4`

# remove files
# rm all_runs*
# rm pb0[0-${pbvol}]*
# rm pb0${blurvol}*
# rm NIerrts.${subj}.odorVI_noblur+orig*
# rm NIerrts.${subj}.odorVIva_noblur+orig*
# rm NIfitts.${subj}.*
# rm fitts.${subj}+orig*
# rm errts.${subj}+orig*
# rm *odorVIv_noblur*
# rm *odorVIvat_noblur*
# rm errts.${subj}.odorVI+orig*
# rm NIerrts*
# rm NIfitts*
# cd mvpa
# rm -r *br*
# rm -r *rpt*
rm -r mvpa/roi_ARodor_l1_odor5va_6/4odors*
mv mvpa/roi_ARodor_l1_odor5va_6/* mvpa/roi_ARodor_l1_beta_6/

# set pb=`ls pb0?.*.r01.volreg+orig.HEAD | cut -d . -f1`
# # cat all runs
# if (! -e allrun.volreg.${subj}+orig.HEAD) then
#     # echo nodata
#     3dTcat -prefix allrun.volreg.${subj} ${pb}.${subj}.r*.volreg+orig.HEAD
# endif

# set filedec = odorVI_noblur
# 3dSynthesize -cbucket cbucket.${subj}.${filedec}+orig -matrix X.nocensor.${filedec}.xmat.1D -select 31..66 -prefix NIfittshead.${subj}.${filedec}
# with va regressors
# set filedec = odor_noblur
# 3dSynthesize -cbucket cbucket.${subj}.${filedec}+orig -matrix X.nocensor.${filedec}.xmat.1D -select 29..64 -prefix NIfittshead.${subj}.${filedec}

# # synthesize fitts of no interests, use -dry for debug
# 3dSynthesize -cbucket cbucket.${subj}.${filedec}+orig -matrix X.nocensor.${filedec}.xmat.1D -select baseline -prefix NIfitts.${subj}.${filedec}
# # subtract fitts of no interests from all runs
# 3dcalc -a allrun.volreg.${subj}+orig -b NIfitts.${subj}.${filedec}+orig -expr 'a-b' -prefix NIerrts.${subj}.odornova_noblur
# rm NIfitts*
# # remove polort and odor_va
# 3dSynthesize -cbucket cbucket.${subj}.${filedec}+orig -matrix X.nocensor.${filedec}.xmat.1D -select polort odor_va -prefix NIfittsnobs.${subj}.${filedec}
# # subtract fitts of no interests from all runs
# 3dcalc -a allrun.volreg.${subj}+orig -b NIfittsnobs.${subj}.${filedec}+orig -expr 'a-b' -prefix NIerrts.${subj}.onlypolandva
# rm NIfitts*

# rm tent.${subj}.odorVI+orig*
# rm tent.${subj}.odorVI_noblur+orig*
# rm NIerrts.${subj}.odorVIv_noblur+orig*
# rm NIerrts.${subj}.odorVIvat_noblur+orig*
else
    echo "${datafolder} not exsist"
endif
end
