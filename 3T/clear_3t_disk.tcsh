#! /bin/csh
# foreach ub (`count -dig 2 17 19`)
# from the first to the second input
foreach ub (`count -dig 2 $1 $2`)

set sub = S${ub}
set datafolder=/Volumes/WD_F/gufei/3T_cw/${sub}/
# set datafolder=/Volumes/WD_D/allsub/${sub}/
# if datafolder exist
if ( -d "${datafolder}" ) then
    cd "${datafolder}"

    # make dir to save masks
    set analysis=de
    set subj = ${sub}.${analysis}
    cd ${subj}.results
    # cd analysis

    # find volreg number
    # @ pbvol = `ls pb0?.*.r01.volreg+orig.HEAD | cut -d . -f1 | cut -c3-4` - 1
    # @ blurvol = `ls pb0?.*.r01.blur+orig.HEAD | cut -d . -f1 | cut -c3-4`

    # remove files
    # rm all_runs*
    # rm pb0[0-${pbvol}]*
    # rm pb0${blurvol}*
    # rm errts*
    # rm fitts*
    # rm *nocross*
    # ls *frame*
    # rm *_16*
    3dcopy anat_final.${subj}+orig ../../roi/${sub}.nii
    3dcopy ../mask/Amy8_align.freesurfer+orig ../../roi/${sub}_amy.nii
else
    echo "${datafolder} not exsist"
endif

end
