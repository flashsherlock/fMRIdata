#! /bin/csh
# set datafolder=/Volumes/WD_D/allsub
set datafolder=/Volumes/WD_D/Exp_odor_face/fMRI\ data_supplemental/
cd "${datafolder}"

if ( $# > 0 ) then

# foreach subj (`echo $*`)

# set subj = $1
set subj = S07


cd ${subj}
#mkdir analysis
cd analysis

# 使用显著有反应的mask的结果，阈值设置比较低
3dClusterize -nosum -1Dformat -inset S07.analysis.+tlrc \
-mask S07.FaceValence.AmyFH.t196+tlrc -idat 34 -ithr 35 \
-NN 1 -clust_nvox 40 -bisided -1.5638 1.5638

# 使用杏仁核的解剖mask然后加上一个阈值，结果和上面是一样的
# -1sided LEFT或RIGHT 阈值
# -2sided 左阈值 右阈值（满足条件的会合并在一起）
# -bisided 左阈值 右阈值（左右分开）
3dClusterize -nosum -1Dformat -inset S07.analysis.+tlrc \
-mask /Volumes/WD_D/allsub/BN_atlas/BN_Amyg+tlrc -idat 34 -ithr 35 \
-NN 1 -clust_nvox 40 -1sided RIGHT 1.96 > cluster_FH.1D
# 得到的是cluster的列表
cat cluster_FH.1D
# 可以通过whereami找到相应坐标的位置
whereami -coord_file cluster_FH.1D'[1,2,3]' -tab

# 进行蒙特卡洛计算cluster大小的阈值
set BrainMask = /Volumes/WD_D/allsub/BN_atlas/BN_Amyg+tlrc
3dFWHMx -overwrite -mask ${BrainMask} -input S07.analysis.+tlrc'[35]' -ACF -detrend > ACF.txt #这句话会计算ACF（AutoCorrelation Function），得到四个参数，但是只用其中的前三个。
set acf=(`awk 'NR==4{print $1,$2,$3}' ACF.txt`) #读取前三个参数值
#进行Monte Carlo模拟
3dClustSim -mask ${BrainMask} -acf `awk 'NR==4{print $1,$2,$3}' ACF.txt` -prefix AmyFH

# end
else
 echo "Usage: $0 <Subjname>"

endif
