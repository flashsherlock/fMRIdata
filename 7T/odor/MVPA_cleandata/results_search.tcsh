#! /bin/csh
foreach ub (`count -dig 2 4 8`)

set sub = S${ub}
# foreach sub (S01_yyt S01 S02 S03)
    set threshold=8 #56/96=58.33
    set rootdir=/Volumes/WD_E/gufei/7T_odor
    set datafolder=${rootdir}/${sub}
    cd "${datafolder}"
    set analysis=pabiode
    set subj = ${sub}.${analysis}
    cd ${subj}.results/mvpa/searchlight_VIodor_l1_label_6/BoxROI
    # copy anatomy
    # if (! -e anat_final.${subj}+orig.HEAD) then
    #     3dcopy ../../../anat_final.${subj}+orig anat_final.${subj}
    # endif
    # # structure 
    # 3dcalc                                                              \
    #     -a 2odors_lim_car/res_accuracy_minus_chance+orig                \
    #     -b 2odors_lim_cit/res_accuracy_minus_chance+orig                \
    #     -expr "and(step(${threshold}-a),step(b-${threshold}))"          \
    #     -prefix struct 
    # # quality
    # 3dcalc                                                              \
    #     -a 2odors_lim_car/res_accuracy_minus_chance+orig                \
    #     -b 2odors_lim_cit/res_accuracy_minus_chance+orig                \
    #     -expr "and(step(a-${threshold}),step(${threshold}-b))"          \
    #     -prefix quality

    3dmaskdump                                          \
        -mask ${datafolder}/mask/Box_label+orig         \
        -o ${rootdir}/stats/${sub}/search_box.txt       \
        ${datafolder}/mask/Box_label+orig               \
        2odors_lim_tra/res_accuracy_minus_chance+orig   \
        2odors_lim_car/res_accuracy_minus_chance+orig   \
        2odors_lim_cit/res_accuracy_minus_chance+orig   \
        2odors_tra_car/res_accuracy_minus_chance+orig   \
        2odors_tra_cit/res_accuracy_minus_chance+orig   \
        2odors_car_cit/res_accuracy_minus_chance+orig   
end

