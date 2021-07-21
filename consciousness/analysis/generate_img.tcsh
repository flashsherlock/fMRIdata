#! /bin/csh
if ( $# > 0 ) then
set sub = $1
set datafolder=/Volumes/WD_D/gufei/consciousness/electrode
cd "${datafolder}"
cd use
# to3d 结果是有问题的，Dimon比较好
# ==========================transform========================== #
# foreach sub (s02)

cd ${sub}

# CT
cd CT
# mkdir 001
# mv I* 001/
# must sort files using -dicom_org option first
Dimon -infile_pattern 'I*' \
#-start_dir 001 \
#-start_file I10 \
#-file_type GEMS	\
-dicom_orgi \
-gert_create_dataset \
-gert_to3d_prefix ${sub}_CT.nii \
-gert_outdir ../ \
-no_wait
#-save_details errors.txt 
cd ..

# MRI
cd MRI
# mkdir 001
# mv I* 001/
Dimon -infile_pattern 'I*' \
#-start_dir 001 \
#-start_file I10 \
#-file_type GEMS	\
-dicom_org\
-gert_create_dataset \
-gert_to3d_prefix ${sub}_MRI.nii \
-gert_outdir ../ \
-no_wait
cd ..

# end

else
 echo "Usage: $0 <Subjname>"

endif
