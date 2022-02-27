# Spike and LFP

## Spike

### D_plot_afsort
挑选经过合并和sorting之后的spike中属于在气味呈现时呼吸的部分。

### D_plot
没有经过合并和sorting的spike。

### D_plot2
只是对比空气和气味。

### D_plot2bin
对比空气与气味，并将spike根据相对呼吸的位置组织。

### find_resp_time
根据plx文件名找到对应的呼吸，返回在plx的时间中的呼吸时间点。

### find_resp_cbtime
根据合并后的plx文件找对应的呼吸。目前的标准是吸气开始后1s位于呈现气味或者空气的时间段内。

### findpoints
根据标记完的biopac呼吸的mat文件中的标记找到呼吸的时间点。

### G_for_mrg
分析合并和sorting后的spike并进行聚类等。

### plot_5odor
不选择呼吸，只是根据气味呈现挑选spike。

### plot_air_odor
不选择呼吸，只是根据气味呈现挑选spike，并将所有气味的合并。

## LFP

### saveplx
读取plx中的原始数据和呼吸，降采样，滤波，调用find_resp_time找到呼吸的时间点，保存为mat格式。
* lfp: 0.1Hz-200Hz带通滤波，采样率1KHz的信号
* resp: plx中的呼吸，采样率1KHz
* bioresp: biopac记录的呼吸，采样率从500Hz升到了1KHz
* trl: 呼吸的时间点和标签，取0点前3.5s,后9.5s
    * resp: 所有的呼吸，标签123分别是吸气开始，呼气开始和呼气结束
    * odor: 所有的气味条件，空气是后7s的开始作为零点，标签是气味条件
    * odorresp: 所有落在气味或者空气的后7s的呼吸，零点是吸气开始，标签是气味条件

### tf_resptry
所有呼吸的数据分段然后做时频分析然后保存。

### lfp_resptry
找出所有的呼吸看LFP随呼吸的变化。直接读取tf_resptry得到的结果。画出两个周期的时频分析图。

### erp_resp
看低频(0.1Hz-0.6Hz)的LFP和呼吸之间的关系，计算相关。

### lfp_odorresp
找出落在气味呈现时间段内的呼吸进行时频分析。画两个周期的气味和空气条件，比较一个周期内气味和空气条件，以及好闻和难闻气味的能量。

### erp_odorresp
画出不同气味条件下吸气开始作为时间零点的ERP。

### lfp_odortry
只是根据气味呈现的标记分析呈现气味的7s和呈现空气的13s中的后7s。

### align_atlas
将猴脑对齐到模板并根据图谱分区。

### find_elec_position
找出电极的位置坐标，并画出电极位置。

### find_elec_label
根据电极的坐标查找在图谱上的标签。

### respiration_odor
分析不同气味条件下的呼吸是否存在差异。

### match_label_data
保存和数据文件对应的日期的坐标标签和文件名。

### save_merge_position
根据电极所在位置将位于同一脑区的数据合并保存。

### roi_erp_odorresp
分析不同的区域对气味的反应，对齐到吸气开始的时间。