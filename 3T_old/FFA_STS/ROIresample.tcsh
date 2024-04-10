#! /bin/csh
set datafolder=/Volumes/WD_D/allsub/BN_atlas
cd ${datafolder}
# whereami -mask_atlas_region Brainnetome_1.0::A37lv_right
# whereami -mask_atlas_region Brainnetome_1.0::rpsts_right
# whereami -mask_atlas_region Brainnetome_1.0::asts_right
3dresample -master MNI152_T1_2009c+tlrc -prefix FFA_right -input ./nonresample/Brainnetome_1.0.A_lv_right+tlrc
3dresample -master MNI152_T1_2009c+tlrc -prefix pSTS_right -input ./nonresample/Brainnetome_1.0.rpsts_right+tlrc
3dresample -master MNI152_T1_2009c+tlrc -prefix aSTS_right -input ./nonresample/Brainnetome_1.0.asts_right+tlrc
