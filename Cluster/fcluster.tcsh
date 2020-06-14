#! /bin/csh
# set datafolder=/Volumes/WD_D/allsub
set datafolder=/Volumes/WD_D/Exp_odor_face/fMRI\ data_supplemental/
cd ${datafolder}

if ( $# > 0 ) then

# foreach subj (`echo $*`)

set subj = $1


cd ${subj}
#mkdir analysis
cd analysis



# end

else
 echo "Usage: $0 <Subjname>"

endif
