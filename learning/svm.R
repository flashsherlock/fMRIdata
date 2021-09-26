library('ggplot2')
library('dplyr')
library('e1071')

# ------------------------- Create training function -------------------------
f_train <- function(n, nv = 2){
  
  # nv: number of features
  # n: number of observations
  
  
  # generate random data
  rNum = rnorm(nv*n)
  rNum = matrix(rNum, n, nv)
  d = as.data.frame(rNum)
  
  # generate random labels
  n2 = n/2
  labels = c(array(1, n2), array(0, n2))
  labels = sample(labels)
  # labels = sample.int(2,n,replace=T)
  d$condition = factor(labels)
  
  # training
  m_trained = svm(condition ~ ., data = d,
                  # cross = 10,
                  cross = nrow(d),  # leave one out
                  kernel = 'linear', 
                  cost = 1)
  
  # get CV
  acc = m_trained$tot.accuracy
  acc
}


# ------------------------------- run traiings -------------------------------
p = expand.grid(iTest = 1:100, n = seq(60, 200, 20))
data_test = p %>% group_by(iTest, n) %>% do(data.frame(acc = f_train(.$n)))

# ----------------------------------- Plot ----------------------------------- #
ggplot(data_test, aes(x = n, y = acc)) + 
  geom_hline(yintercept=50)+
  stat_summary(fun = "mean", colour = "red", geom = "line") + 
  stat_summary(fun.data = 'mean_sdl', geom = 'ribbon', alpha = 0.2)
# print(plot)