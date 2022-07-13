library(psych)
library(pracma)
# generate data
r <-magic(5)
r <- rbind(r,t(r))
r[1,1] <- 16

# factor analysis
pcu <- principal(r,nfactors = 5,rotate = "none")
pc <- principal(r,nfactors = 5,rotate = "varimax")
pco <- principal(r,nfactors = 5,rotate = "oblimin")
corpcu <- principal(cov(r),nfactors = 5,rotate = "none",covar = F)
copcu <- principal(cov(r),nfactors = 5,rotate = "none",covar = T)
#  prcomp function
prcopc <- prcomp(r, center = T,scale. = F)
prcopcs <- prcomp(r, center = T,scale. = T)
# weights and loadings has the same direction afte pca
pcu$weights[,5]/norm(pcu$weights[,5],type = "2")
pcu$loadings[,5]/norm(pcu$loadings[,5],type = "2")
corpcu$weights[,5]/norm(corpcu$weights[,5],type = "2")
corpcu$loadings[,5]/norm(corpcu$loadings[,5],type = "2")
prcopc
# unscaled pcs
prcopcs
copcu$weights[,5]/norm(copcu$weights[,5],type = "2")
copcu$loadings[,5]/norm(copcu$loadings[,5],type = "2")
# not for rotated weights (because unrotated W is the )
pc$loadings[,5]/norm(pc$loadings[,5],type = "2")
pc$weights[,5]/norm(pc$weights[,5],type = "2")
# score = zscore * weights
zr <- apply(r,2,scale)
zr%*%pcu$weights
pcu$scores
zr%*%pc$weights
pc$scores
# scores are normalized
describe(pcu$scores)
describe(pc$scores)
# no scores if covar = F
describe(r)
# scale columns weights and loadings are in the same direction
scale(copcu$weights, center=FALSE, scale=apply(copcu$weights,2,norm,type = "2"))
scale(copcu$loadings, center=FALSE, scale=apply(copcu$loadings,2,norm,type = "2"))
# loadings were scaled by the root of eigen values
sqrt(copcu$values)
apply(copcu$loadings,2,norm,type = "2")
# sd of the r*uniformed_eigen is the root of eigen values
describe(r%*%scale(copcu$loadings, center=FALSE,
                   scale=apply(copcu$loadings,2,norm,type = "2")))
# zr * weights sd!=1
zr%*%copcu$weights
describe(zr%*%copcu$weights)
# input * weights sd=1
r%*%copcu$weights
describe(r%*%copcu$weights)
zr%*%corpcu$weights
# weights = inv(R)*structure(loadings)
solve(cor(r))%*%pcu$loadings
solve(cor(r))%*%pcu$Structure
pcu$weights
solve(cor(r))%*%pc$loadings
solve(cor(r))%*%pc$Structure
pc$weights
# inv(COV) if use covar
solve(cov(r))%*%copcu$loadings
copcu$weights
# pc weights is the rotated pcu weights
pcu$weights%*%pc$rot.mat
# pc loadings is the rotated pcu loadings
pcu$loadings%*%pc$rot.mat
pc$loadings
pcu$loadings%*%pco$rot.mat
pco$loadings
# oblique rotation
zr%*%pco$weights
pco$scores
# S = P*interfactor-correlation
pco$Structure
pco$loadings%*%pco$Phi
# weights are rotated
pcu$weights%*%pco$rot.mat
solve(cor(r))%*%pco$loadings
# W = inv(R)*structrue
solve(cor(r))%*%pco$Structure
solve(cor(r))%*%pco$loadings%*%pco$Phi
pco$weights
# R = A*A'
cor(zr)
pc$loadings%*%t(pc$loadings)
pcu$loadings%*%t(pcu$loadings)
# sum of square of loadings
sum(pcu$loadings[1,]^2)
sum(pcu$loadings[,1]^2)
# rotated
sum(pc$loadings[1,]^2)
sum(pc$loadings[,1]^2)
sum(pco$loadings[1,]^2)
sum(pco$loadings[,1]^2)
# Structure is the correlation between zr and pco$scores
pco$Structure
cor(zr,pco$scores)
