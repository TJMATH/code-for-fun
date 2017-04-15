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
  # lambda <- cv.glmnet(X, Y, nfolds = nfolds, family = "gaussian", intercept = FALSE)$lambda.min
  lambdaj <- cv.glmnet(X[, -1], X[, 1], nfolds = nfolds)$lambda.min
  return(lambdaj)
}

getThetaLasso <- function(X, Y, lambdaj){
  # model <- glmnet(X, Y, lambda = lambda, family = "gaussian", intercept = FALSE)
  # beta_hat <- as.vector(model$beta)
  # n <- nrow(X)
  p <- ncol(X)
  # Sigma_hat <- (t(X) %*% X)/n
  T_hat2_inv <- diag(1, p)
  tau_tilde <- diag(1, p)
  C_hat <- matrix(1, p, p)
  for(i in 1:p){
    gammai <- as.vector(glmnet(X[, -i], X[, i], lambda = lambdaj, family = "gaussian")$beta)
    C_hat[i, -i] <- -gammai
    tau_tilde[i, i] <- mean((X%*% C_hat[i, ])^2)
    T_hat2_inv[i, i] <- 1/(tau_tilde[i, i] + lambdaj*sum(abs(gammai)))
  }
  Theta_lasso <- T_hat2_inv %*% C_hat
  Omega_diag_hat <- diag(tau_tilde * T_hat2_inv * T_hat2_inv)
  # error_hat <- Y - X %*% beta_hat
  # b_hat <- beta_hat + Theta_lasso %*% t(X) %*% error_hat/n
  # l <- 1.96 * sd(error_hat) * sqrt(diag(Theta_lasso %*% Sigma_hat %*% t(Theta_lasso)) / n)
  # CI <- cbind(b_hat - l, b_hat + l)
  return(list(Theta_lasso = Theta_lasso, Omega_diag_hat = Omega_diag_hat))
}

getsigma <- function(X, Y){
  lambda <- cv.glmnet(X, Y, family = "gaussian")$lambda.min
  beta_hat_old <- glmnet(X, Y, lambda = lambda, family = "gaussian")$beta
  p = ncol(X)
  n = length(Y)
  iter = 0
  error = 1
  sigma_old = 0.5 # why 0.5?
  while(error > 0.01 & iter < 20){
    resid = Y - X %*% beta_hat_old
    sigma_new = sd(resid)
    lambda_new = 2 * sqrt(2 * log(p) / n) * sigma_new
    beta_hat_new = glmnet(X, Y, lambda = lambda_new, family = "gaussian")$beta
    err1 = max(abs(beta_hat_new - beta_hat_old))
    err2 = abs(sigma_new - sigma_old)
    error = max(err1, err2)
    print(error)
    print(sigma_new)
    print(beta_hat_new[1:3])
    beta_hat_old = beta_hat_new
    sigma_old = sigma_new
    iter = iter + 1
  }
  beta_hat_new <<- as.vector(beta_hat_new)
  print("===========================")
  print(lambda_new)
  print(beta_hat_new[1:4])
  print("===========================")
  return(list(sigma_hat = sigma_new, lambda_hat = lambda_new, beta_hat = beta_hat_new, error_hat = resid))
}



main <- function(n, s0, Sigma, c, seeds, sigma = 1, iterations = 100){
  p <- nrow(Sigma)
  len_CI <- matrix(0, iterations, p)
  betaInCI <- matrix(0, iterations, p)
  for(i in 1:iterations){
    set.seed(seeds[i])
    beta <- c(runif(s0, 0, c), rep(0, p - s0))
    MyData <- getData(n, beta, Sigma, sigma)
    lambdaj <- getLambda(MyData$X, MyData$Y, 10)
    ThetaAndOmega <- getThetaLasso(MyData$X, MyData$Y, lambdaj)
    parameters <- getsigma(MyData$X, MyData$Y)
    b_hat <- parameters$beta_hat + ThetaAndOmega$Theta_lasso %*% t(MyData$X) %*% parameters$error_hat/n
    l <- 1.96 * parameters$sigma_hat * sqrt(ThetaAndOmega$Omega_diag_hat / n)
    CI <<- cbind(b_hat - l, b_hat + l)
    len_CI[i, ]  <- t(CI[, 2] - CI[, 1])
    betaInCI[i, ] <- (beta > CI[, 1]) * (beta < CI[, 2])
    print(paste(as.character(i/iterations * 100), "% completed"))
  }
  return(list(len_CI = len_CI, betaInCI = betaInCI))
}



iterations = 100
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