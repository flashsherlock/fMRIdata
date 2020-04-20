# install.packages("BiocManager")
# BiocManager::install("rhdf5")
library(rhdf5)

setwd("/Volumes/WD_D/gufei/document/NeoAnalysis_sample_data")
filename <- "graphics_data.h5"
# 列出文件的目录
h5ls(filename)
# 读取文件中的数据
spike26 <- h5read(filename,name="spikes/spike_26_1/waveforms")
spike26_time <- h5read(filename,name="spikes/spike_26_1/times")
# 读取完需要关闭
H5close()
