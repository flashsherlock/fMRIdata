# Spike and LFP

## D_plot_afsort
挑选经过合并和sorting之后的spike中属于在气味呈现时呼吸的部分。

## D_plot
没有经过合并和sorting的spike。

## D_plot2
只是对比空气和气味。

## D_plot2bin
对比空气与气味，并将spike根据相对呼吸的位置组织。

## find_resp_time
根据plx文件名找到对应的呼吸，返回在plx的时间中的呼吸时间点。

## find_resp_cbtime
根据合并后的plx文件找对应的呼吸。

## findpoints
根据标记完的biopac呼吸的mat文件中的标记找到呼吸的时间点。

## G_for_mrg
分析合并和sorting后的spike并进行聚类等。

## lfp_odortry
只是根据气味呈现的标记分析呈现气味的7s和呈现空气的13s中的后7s。

## lfp_resptry
找出所有的呼吸看LFP随呼吸的变化。

## lfp_odorresp
找出落在气味呈现时间段内的呼吸进行时频分析。

## plot_5odor
不选择呼吸，只是根据气味呈现挑选spike。

## plot_air_odor
不选择呼吸，只是根据气味呈现挑选spike，并将所有气味的合并。