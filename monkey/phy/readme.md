# Preprocessing

## Data management

### saveplx / saveplx_RM033
读取plx中的原始数据和呼吸，降采样，滤波，调用`find_resp_time`找到呼吸的时间点，保存为mat格式。
* lfp: 0.1Hz-300Hz带通滤波，采样率1KHz的信号
* resp: plx中的呼吸，采样率1KHz
* bioresp: biopac记录的呼吸，采样率从500Hz升到了1KHz
* trl: 呼吸的时间点和标签，取0点前3.5s,后9.5s
    * resp: 所有的呼吸，标签123分别是吸气开始，呼气开始和呼气结束
    * odor: 所有的气味条件，空气是后7s的开始作为零点，标签是气味条件
    * odorresp: 所有落在气味或者空气的后7s的呼吸，零点是吸气开始，标签是气味条件

### find_resp_time
根据plx文件名找到plx文件和对应的呼吸mat文件，返回以下内容。
* valid_res_plx: 在plx的时间中位于气味呈现阶段（气味呈现覆盖开始吸气后1s）的呼吸时间点，用于trlodorresp。
* resp_points: 在plx的时间中的所有呼吸时间点，用于trlresp。
* odor_time: 在plx的时间中的气味（空气取后7s）呈现时间点，用于trlodor。
* bioresp: 1KHz的biopac的呼吸。

### find_resp_cbtime
根据合并后的plx文件找对应的呼吸。目前的标准是吸气开始后1s位于呈现气味或者空气的时间段内。

### findpoints
根据标记完的biopac呼吸的mat文件中的标记找到呼吸的时间点。

### match_label_data
保存和数据文件对应的日期的坐标标签和文件名。

### save_merge_position
根据电极所在位置将位于同一脑区的数据合并，并且可以提取指定日期的数据。

### save_merge_2monkey
根据电极所在位置将位于同一脑区的数据合并，并且可以合并两只猴子的数据。

### save_sep_2monkey
根据电极所在位置将位于同一记录位置的数据合并。

### count_trial
统计各个区域的trial数量。

### check_plx
检查plx文件是否存在问题。

## Electrodes localization

### ../align_img
将CT和MRI图像对齐，标出电极位置。

### align_atlas
将猴脑对齐到模板并根据图谱分区。

### find_elec_position
找出电极的位置坐标，并画出电极位置。

### find_elec_label
根据电极的坐标查找在图谱上的标签。

# Spike

### D_plot_afsort
挑选经过合并和sorting之后的spike中属于在气味呈现时呼吸的部分。

### D_plot
没有经过合并和sorting的spike。

### D_plot2
只是对比空气和气味。

### D_plot2bin
对比空气与气味，并将spike根据相对呼吸的位置组织。

### G_for_mrg
分析合并和sorting后的spike并进行聚类等。

### plot_5odor
不选择呼吸，只是根据气味呈现挑选spike。

### plot_air_odor
不选择呼吸，只是根据气味呈现挑选spike，并将所有气味的合并。

### PLV_spike
计算spike和呼吸的PLV。

# LFP

## Respiration
### respiration_odor
分析不同气味条件下的呼吸是否存在差异。

### respiration_cycle
分析不同气味条件下的呼吸周期的分布。

### roi_coherence
计算呼吸和LFP之间的相幅锁定关系。

### sep_coherence
计算每个位点呼吸和LFP之间的相幅锁定关系。

### ft_concat
将trial的LFP合并。

### get_sinal_pa
获取信号的phase和amplitude。

### plotsigx
用横线标记出显著的区域。

## Power spectrum

### roi_powerspec
分析不同区域的power spectrum，关注各个频段在不同气味条件下的能量差异。

### powspec_by_roi
画出各个区域不同频段的平均能量。

### pca_power
使用时频分析的结果做PCA降维并画图。

### pca_power_2m
用合并的数据做PCA。

### pca_permutation
生成1000个标签打乱之后平均的结果。

### pca_permutation_sep
返回每个记录位点标签打乱之后平均的结果。

### pca_data_sep
得到用于分类的每个记录位点PCA之后的时频数据。

### rsa_power_sep
使用时频分析的距离与气味的评分和描述词的距离做相关分析。

## Time-frequency analysis

### lfp_odortry
只是根据气味呈现的标记分析呈现气味的7s和呈现空气的13s中的后7s。

### lfp_resptry
找出所有的呼吸看LFP随呼吸的变化。直接读取tf_resptry得到的结果。画出两个周期的时频分析图。

### tf_resptry
所有呼吸的数据分段然后做时频分析然后保存。

### lfp_odorresp
找出落在气味呈现时间段内的呼吸进行时频分析。画两个周期的气味和空气条件，比较一个周期内气味和空气条件，以及好闻和难闻气味的能量。

### lfp_ptest
时频分析和基线比较的permutation test。

### lfp_comptest
时频分析条件之间比较的permutation test。

### lfp_tfplot
时频分析的结果画图。

### lfp_odorresp_sep
每一个记录位点分别做时频分析并计算PCA后的距离。

### find_outlier
查看原始数据中是否有异常值。

### generate_AH
通过图谱生成ROI用于显示单个电极的位置。

### cluster_power
针对强度进行PCA分析。

### plots
使用R分析频谱分析和时频分析的结果并画图。

### roi_merge_tf
基于level5的时频分析结果合并数据到只有HF和Amy。

## ERP

### erp_resp
看低频(0.1Hz-0.6Hz)的LFP和呼吸之间的关系，计算相关。

### erp_odorresp
画出不同的区域不同气味条件下吸气开始作为时间零点的ERP。

### erp_resp_sep
每一个记录位点分别计算LFP和呼吸之间的相关。

### roi_erp_odorresp (deprecated)
分析不同的区域对气味的反应，对齐到吸气开始的时间。

## Decoding
### roi_decoding
读取LFP并选取时间窗进行分类。

### roi_decoding_tf
采用经过PCA降维之后的时频数据选取时间窗进行分类。

### sample_lfp_decoding
随机抽取样本并调用`odor_decoding_function`做分类。

### sample_tf_decoding
根据条件对经过PCA后的时频数据调用`odor_decoding_function`做分类。

### odor_decoding_function
从decoding toolbox改造得到的decoding主要函数。

### odor_decoding_results
读取结果mat文件调用`odor_decoding_acc`得到正确率并画柱状图。

### odor_decoding_acc
返回正确率和随机水平的函数。

### acc_by_time
画出正确率随时间变化的折线图。