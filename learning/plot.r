# install vscode-r extension

# install packages
# install.packages("languageserver")
# install.packages("httpgd")
# devtools::install_github("ManuelHentschel/vscDebugger")

library(Hmisc)

data_dir <- "C:/Users/GuFei/zhuom/yanqihu/result100.sav"
data_exp1 <- spss.get(data_dir)
str(data_exp1)
summary(data_exp1)

# test plot
h <- c(1, 2, 3, 4, 5, 6)
M <- c("A", "B", "C", "D", "E", "F")
barplot(h,
    names.arg = M, xlab = "X", ylab = "Y",
    col = "#00cec9", main = "Chart", border = "#fdcb6e"
)
