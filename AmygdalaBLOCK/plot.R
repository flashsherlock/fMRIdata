rm(list = ls())
load("All.RData")
# 分组统计
library(psych)
analyze <- describeBy(all[2:14],list(all$position,all$condition),mat = TRUE)
# 把vars列中的数字替换为名称
varnames <- row.names(analyze)
tempstr <- strsplit(varnames,"[0-9]")
varnames <- sapply(tempstr,'[',1)
analyze$vars <- as.factor(varnames)

# 备份 把是odor还是face作为一个变量
# library(psych)
# analyze <- describeBy(all[2:14],list(all$valance,all$position,all$condition),mat = TRUE)
# analyze <- na.omit(analyze)
# varnames <- row.names(analyze)
# tempstr <- strsplit(varnames,"[0-9]")
# varnames <- sapply(tempstr,'[',1)
# analyze$vars <- as.factor(varnames)
# 提取需要画图的部分
# FaceAmy <- subset(analyze,group1=="Face" & group2=="Amy" & vars%in%c('FP','FU','HP','HU'),select = c(mean,se,vars,group3))


# 绘图
library(ggplot2)
library(ggthemr)
library(RColorBrewer)
ggthemr('fresh',layout = "clean")
# 提取需要画图的部分
FaceAmy <- subset(analyze,group1=="Amy" & group2%in%c("HF","FH") & vars%in%c('FP','FU','HP','HU'),select = c(mean,se,vars,group2))
# Error bars represent standard error of the mean
ggplot(FaceAmy, aes(x=vars, y=mean, fill=group2)) +
  coord_cartesian(ylim=c(0,0.4)) +  # 设置y轴坐标范围
  scale_y_continuous(expand = c(0,0))+
  geom_bar(position="dodge", stat="identity") +
  scale_fill_manual(values = colors[1:2])+ #颜色
  # scale_fill_brewer(palette = "Set2",direction = -1)+ #颜色
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se),
                width=.2,color='black',      # Width of the error bars
                position=position_dodge(.9))

# 可以查看对应主题的颜色
colour_plot(swatch())
colour_plot(ggthemr("pale"))
colour_plot(ggthemr("greyscale"))
colour_plot(ggthemr("solarized"))
# colorbrewer选择颜色，生成颜色
display.brewer.all()
colors <- brewer.pal(8,"Set2")
colour_plot(colors)
# colors是自带颜色函数
colors()
