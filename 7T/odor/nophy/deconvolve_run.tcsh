#!/bin/tcsh
if ( $# > 0 ) then

    foreach run (`echo $*`)

        set sub=S01_yyt
        set analysis=pade

        set datafolder=/Volumes/WD_D/gufei/7T_odor/${sub}/
        cd "${datafolder}"

        # run the regression analysis
        set subj = ${sub}.${analysis}
        cd ${subj}.results
        set filedec = Run

        # remove file to resolve conflicts
        # rm *${filedec}_${run}*

        3dDeconvolve -input pb07.$subj.r0${run}.scale+orig.HEAD              \
            -ortvec mot_demean.r${run}.1D mot_demean_r${run}         \
            -polort 3                                                  \
            -num_stimts 4                                              \
            -stim_times 1 ../behavior/lim_run_${run}.txt 'BLOCK(2,1)'      \
            -stim_label 1 lim                                          \
            -stim_times 2 ../behavior/tra_run_${run}.txt 'BLOCK(2,1)'      \
            -stim_label 2 tra                                          \
            -stim_times 3 ../behavior/car_run_${run}.txt 'BLOCK(2,1)'      \
            -stim_label 3 car                                          \
            -stim_times 4 ../behavior/cit_run_${run}.txt 'BLOCK(2,1)'      \
            -stim_label 4 cit                                          \
            -jobs 12                                                   \
            -fout -tout -x1D X.xmat.${filedec}_${run}.1D -xjpeg X.${filedec}_${run}.jpg  \
            -fitts fitts.$subj.${filedec}_${run}                                         \
            -errts errts.${subj}.${filedec}_${run}                                       \
            -bucket stats.$subj.${filedec}_${run}

    end

else

    echo "Usage: $0 <Run number>"
endif

# endif 后面需要有个回车，否则会显示endifnot found
