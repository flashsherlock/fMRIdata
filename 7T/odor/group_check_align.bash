#! /bin/bash

# datafolder=/Volumes/WD_E/gufei/7T_odor/group
datafolder=/Volumes/WD_F/gufei/7T_odor/group
cd "${datafolder}" || exit

# make dir image if not exist
if [ ! -d image/check ]; then
    mkdir image/check
fi

# for sub in {04..11} {13..14} {16..29} {31..34}
# do
#     subj=S${sub}.pabiode
#     # must use -all_dsets to read different folders
#     afni                                                                                            \
#     -all_dsets                                                                                      \
#     -com "OPEN_WINDOW A.coronalimage"                                                               \
#     -com "SET_XHAIRS A.OFF"                                                                         \
#     -com "SWITCH_UNDERLAY MNI152_T1_2009c+tlrc"                                                     \
#     -com "SWITCH_OVERLAY anat_final.${subj}+tlrc"                                                   \
#     -com "SET_DICOM_XYZ A 0 0 0"                                                                    \
#     -com "SAVE_PNG A.coronalimage ./image/check/S${sub}_coronal.png"                      \
#     -com "SAVE_PNG A.axialimage ./image/check/S${sub}_axial.png"                          \
#     -com "SAVE_PNG A.sagittalimage ./image/check/S${sub}_sagittal.png"                    \
#     -com "QUIT"                                                                                     \
#     ./ ../S${sub}/${subj}.results/
# done
sub=16
subj=S${sub}.pabiode
cd ../S${sub}/${subj}.results/ || exit

# deal with S16: add no_avoid_eyes
# @auto_tlrc -no_ss -init_xform AUTO_CENTER \
# -no_avoid_eyes -maxite 500 \
# -base ~/abin/MNI152_T1_2009c+tlrc \
# -input anat_final.S16.pabiode+orig

rm stats.S16.pabiode.odorVI+tlrc*
rm citcar.${subj}+tlrc*
rm citcar_norm.${subj}+tlrc*
rm allroi_citcar.${subj}+tlrc*
rm allroi_citcar_norm.${subj}+tlrc*

@auto_tlrc -apar anat_final.${subj}+tlrc -input stats.${subj}.odorVI+orig

# calculate abs(cit-lim)-abs(car-lim)
3dcalc -prefix citcar.${subj}       \
-a stats.${subj}.odorVI+tlrc"[34]"  \
-b stats.${subj}.odorVI+tlrc"[31]"  \
-expr "abs(a)-abs(b)"

# calculate abs(cit-lim)-abs(car-lim) and normalized by abs(cit-lim)+abs(car-lim)
3dcalc -prefix citcar_norm.${subj}       \
-a stats.${subj}.odorVI+tlrc"[34]"       \
-b stats.${subj}.odorVI+tlrc"[31]"       \
-expr "(abs(a)-abs(b))/(abs(a)+abs(b))"

3dcalc -prefix allroi_citcar.${subj}        \
-a stats.${subj}.odorVI+tlrc"[34]"          \
-b stats.${subj}.odorVI+tlrc"[31]"          \
-c ../../group/mask/allROI+tlrc             \
-expr "c*(abs(a)-abs(b))"

3dcalc -prefix allroi_citcar_norm.${subj}       \
-a stats.${subj}.odorVI+tlrc"[34]"              \
-b stats.${subj}.odorVI+tlrc"[31]"              \
-c ../../group/mask/allROI+tlrc                 \
-expr "c*(abs(a)-abs(b))/(abs(a)+abs(b))"

# for label in all of the list of directory start with searchlight
# enter the directory and echo subdirectory
cd mvpa || exit
for label in $(ls -d searchlight_AR*)
do
    cd "${label}" || exit
    for roi in $(ls -d Box*)
    do
        cd "${roi}" || exit

        # rm citcar*

        # 3dcalc \
        # -a ./2odors_lim_cit/res_accuracy_minus_chance+tlrc \
        # -b ./2odors_lim_car/res_accuracy_minus_chance+tlrc \
        # -expr "a*step(a)-b*step(b)" \
        # -prefix citcar

        # 3dcalc \
        # -a ./2odors_lim_cit/res_accuracy_minus_chance+tlrc \
        # -b ./2odors_lim_car/res_accuracy_minus_chance+tlrc \
        # -expr "(a*step(a)-b*step(b))/(a*step(a)+b*step(b))" \
        # -prefix citcar_norm

        for odor in $(ls -d 2odors*)
        do
            cd "${odor}" || exit
            rm *tlrc*
            @auto_tlrc -apar ../../../../anat_final.${subj}+tlrc -input res_accuracy_minus_chance+orig
            cd ..
        done

        cd ..
    done
    cd ..
done

