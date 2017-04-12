# Clear the console and remove variables from the cache.
cat('\f')
rm(list = ls())

library(glmnet)
library(mvtnorm)



getData <- function(n, beta, Sigma, sigma = 1){
  # Get a n x p matrix as X. Then use model Y = X %*% beta + error to get Y.
  # sigma is the std of error.
  p <- nrow(Sigma)
  X <- rmvnorm(n, mean = rep(0, p), sigma = Sigma)
  error <- rnorm(n, 0, sigma)
  Y <- X%*%beta + error
  return(list(X = X, Y = Y, error = error))
}

getLambda <- function(X, Y, nfolds){
  lambda <- cv.glmnet(X, Y, nfolds = nfolds)$lambda.min
  lambdaj <- cv.glmnet(X[, -1], X[, 1], nfolds = nfolds)$lambda.min
  return(list(lambda = lambda, lambdaj = lambdaj))
}

getThetaLasso <- function(X, Y, lambda, lambdaj){
  model <- glmnet(X, Y, lambda = lambda, family = "gaussian")
  beta_hat <- as.vector(model$beta)
  n <- nrow(X)
  p <- ncol(X)
  Sigma_hat <- (t(X) %*% X)/n
  T_hat2_inv <- diag(1, p)
  C_hat <- matrix(1, p, p)
  for(i in 1:p){
    gammai <- as.vector(glmnet(X[, -i], X[, i], lambda = lambdaj, family = "gaussian")$beta)
    C_hat[i, -i] <- -gammai
    T_hat2_inv[i, i] <- 1/(mean((X%*% C_hat[i, ])^2) + lambdaj*sum(abs(gammai)))
  }
  Theta_lasso <- T_hat2_inv %*% C_hat
  error <- Y - X %*% beta_hat
  b_hat <- beta_hat + Theta_lasso %*% t(X) %*% error/n
  l <- 1.96 * sd(error) * sqrt(diag(Theta_lasso %*% Sigma_hat %*% t(Theta_lasso) / n))
  CI <- cbind(b_hat - l, b_hat + l)
  return(CI)
}

main <- function(n, s0, Sigma, c, seeds, sigma = 1, iterations = 100){
  p <- nrow(Sigma)
  len_CI = matrix(0, iterations, p)
  betaInCI = matrix(0, iterations, p)
  for(i in 1:iterations){
    set.seed(seeds[i])
    beta <- c(runif(s0, 0, c), rep(0, p - s0))
    MyData <- getData(n, beta, Sigma, sigma)
    lambdas <- getLambda(MyData$X, MyData$Y, 10)
    CI <- getThetaLasso(MyData$X, MyData$Y, lambdas$lambda, lambdas$lambdaj)
    len_CI[i, ]  = t(CI[, 2] - CI[, 1])
    betaInCI[i, ] = (beta > CI[, 1]) * (beta < CI[, 2])
    print(paste(as.character(i/iterations * 100), "% completed"))
  }
  return(list(len_CI = len_CI, betaInCI = betaInCI))
}



iterations = 100
set.seed(65536)
seeds = sample(65536:131072, iterations + 10, replace=FALSE)
n = 100
p = 500
Sigma = matrix(0, p, p)
for (i in 1:p){
  for (j in 1:p){
    Sigma[i, j] = 0.9^(abs(i - j))
  }
}
s0 = 3
c = 2
sigma = 1

results <- main(n, s0, Sigma, c, seeds, sigma, iterations)

Avgcov <- colMeans(results$betaInCI)
AvgcovS0 <- mean(Avgcov[1: s0])
AvgcovS0c <- mean(Avgcov[s0: p - s0])
Avglen <- colMeans(results$len_CI)
AvglenS0 <- mean(Avglen[1: s0])
AvglenS0c <- mean(Avglen[s0: p - s0])
Toeplitz <- list(AvgcovS0 = AvgcovS0, AvgcovS0c = AvgcovS0c, AvglenS0 = AvglenS0, AvglenS0c = AvglenS0c)