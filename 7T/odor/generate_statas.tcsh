#!/bin/tcsh
# set sub=S01_yyt
# use input as sub
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_E/gufei/7T_odor/${sub}
# set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
cd "${datafolder}"

switch ($2)
    case bio:
        set analysis=pabiode
        breaksw
    case phy:
        set analysis=paphde
        breaksw
    case no:
        set analysis=pade
        breaksw
    default:
        echo The second input must be bio, phy or no.
        echo ${analysis}
endsw

echo ${sub} ${analysis}

# run the regression analysis
set subj = ${sub}.${analysis}
cd ${subj}.results

# auto tlrc to MNI space
# normalize Anatomical img to mni space
@auto_tlrc -no_ss -init_xform AUTO_CENTER -maxite 500 -base ~/abin/MNI152_T1_2009c+tlrc. -input anat_final.${sub}.${analysis}+orig
# align to nomalized Anatomical img
@auto_tlrc -apar anat_final.${sub}.${analysis}+tlrc -input stats.${subj}+orig



else
 echo "Usage: $0 <Subjname> <analysis>"

endif
