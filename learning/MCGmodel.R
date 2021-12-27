# MCG 模型
# 标准刺激 单位是ms
standard_t <- 4 * 1000
# 比较刺激
compare_t <- c(1:7) * 1000
# 模型的主要参数c和b
c <- 0.5
sdc <- c * standard_t
# it has been assumed that the coefcient of
# variation of b is 0.5
b <- 0.2
cb <- 0.5
sdb <- b * cb
# 记忆的不准确，把标准的记成k倍
k <- 1
# 随机反应的比率
p <- 0
# 每个条件的重复数量
nt <- 20
# 被试数量
sub <- 40

# 进行实验的函数
experiment <- function(c, b, sdb, sdc, k, p, nt, sub, standard_t, compare_t) {
  # 实验的条件以及顺序
  trial <- rep(compare_t, nt)
  # 初始化结果向量f是最终得比率，result是每个被试的详细结果
  f <- rep(0, length(compare_t))
  result <- data.frame(compare = 0, response = 0)
  # 被试循环
  for (x in 1:sub) {
    # 试次循环
    for (x in 1:length(trial)) {
      # 得到比较刺激并记录
      t <- trial[x]
      result[x, 1] <- t
      # 随机反应一些试次
      if (x <= length(trial) * p) {
        result[x, 2] <- sample(c(0, 1), 1)
      } else {
        # 标准刺激的抽样
        s <- rnorm(1, mean = standard_t, sd = sdc)
        # b1 <- abs(k*s-t)/t
        # bc <- rnorm(1,mean = b,sd = sdb)
        # 进行比较，标准和比较刺激的差异是否小于阈限
        if (abs(k * s - t) / t < rnorm(1, mean = b, sd = sdb)) {
          result[x, 2] <- 1
        } else {
          result[x, 2] <- 0
        }
      }
    }
    t <- table(result)
    # 得到每个条件的是反应比例
    try(f <- t[, 2] / (t[, 1] + t[, 2]) + f, silent = T)
  }
  f <- f / sub
  return(f)
}

f <- experiment(c, b, sdb, sdc, k, p, nt, sub, standard_t, compare_t)
plot(compare_t / 1000, f, ylim = c(0, 0.6), type = "b", lty = 3)
# lines(compare_t/1000,f)
xfit <- seq(1, 7, 0.01)
lines(xfit, dnorm(xfit, mean = standard_t / 1000, sd = sdc / 1000))
# xfit <- seq(-5,5,0.01)
# plot(xfit,dnorm(xfit,mean=b,sd=sdb) )