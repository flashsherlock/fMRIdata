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

# weights and loadings has the same direction afte pca
pcu$weights[,5]/norm(pcu$weights[,5],type = "2")
pcu$loadings[,5]/norm(pcu$loadings[,5],type = "2")
# not for rotated weights (because unrotated W is the )
pc$loadings[,5]/norm(pc$loadings[,5],type = "2")
pc$weights[,5]/norm(pc$weights[,5],type = "2")
# score = zscore * weights
zr <- apply(r,2,scale)
zr%*%pcu$weights
pcu$scores
zr%*%pc$weights
pc$scores
# weights = inv(R)*structure(loadings)
solve(cor(r))%*%pcu$loadings
solve(cor(r))%*%pcu$Structure
pcu$weights
solve(cor(r))%*%pc$loadings
solve(cor(r))%*%pc$Structure
pc$weights
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
