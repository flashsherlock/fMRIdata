# 通过图谱生成mask
whereami -mask_atlas_region Brainnetome_1.0::lAmyg_right
whereami -mask_atlas_region Brainnetome_1.0::mAmyg_left
whereami -mask_atlas_region Brainnetome_1.0::lAmyg_right
whereami -mask_atlas_region Brainnetome_1.0::mAmyg_left
# 合并左右
# 没有重合的部分直接相加即可，否则'a+b-a*b'
3dcalc -a Brainnetome_1.0.mAmyg_left+tlrc -b Brainnetome_1.0.mAmyg_right+tlrc -expr 'a+b' -prefix mAmyg
3dcalc -a Brainnetome_1.0.lAmyg_left+tlrc -b Brainnetome_1.0.lAmyg_right+tlrc -expr 'a+b' -prefix mAmyg
3dcalc -a lAmyg+tlrc -b mAmyg+tlrc -expr 'a+b' -prefix BN_Amyg

3dresample -master MNI152_T1_2009c+tlrc -prefix BN_Amyg -input ./nonresample/BN_Amyg+tlrc
3dresample -master MNI152_T1_2009c+tlrc -prefix lAmyg -input ./nonresample/lAmyg+tlrc
3dresample -master MNI152_T1_2009c+tlrc -prefix mAmyg -input ./nonresample/mAmyg+tlrc
