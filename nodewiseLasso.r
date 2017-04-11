# Clear the console and remove variables from the cache.
cat('\f')
rm(list = ls())

library(glmnet)



getData <- function(n, p, beta, sigma){
  # Get a n x p matrix as X. Then use model Y = X %*% beta + error to get Y.
  # sigma is the std of error.
  if(n > p){
    print('Warning: the number of observations is greater than dimension')
  }
  s0 <- sum(beta!=0)
  if (s0 > p){
    print('Warning: Dimension should be greater than s0. And we will force the dimension parameter equal to s0')
    p <- s0
  }
  beta <- c(beta, rep(0,p - length(beta)))
  X <- matrix(rnorm(n * p, 0, 4), n, p)
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
  Sigma <- (t(X) %*% X)/n
  T_hat2_inv <- diag(1, p)
  C_hat <- matrix(1, p, p)
  for(i in 1:p){
    gammai <- as.vector(glmnet(X[, -i], X[, i], lambda = lambdaj, family = "gaussian")$beta)
    C_hat[i, -i] <- -gammai
    T_hat2_inv[i, i] <- 1/(mean((X%*%t(C_hat))^2) + lambdaj*sum(abs(gammai)))
  }
  Theta_lasso <- T_hat2_inv %*% C_hat
  error <- Y - X %*% beta_hat
  # test is the difference between (Theta_lasso %*% Sigma) and I
  test <- sum(abs(Theta_lasso %*% Sigma - diag(p)))
  return(list(beta_hat = beta_hat, Theta_lasso = Theta_lasso, Sigma = Sigma, error_hat = error, test = test))
}



MyData <- getData(40, 150, c(1, 0, 3, 2), 1)
lambdas <- getLambda(MyData$X, MyData$Y, 10)
results <- getThetaLasso(MyData$X, MyData$Y, lambdas$lambda, lambdas$lambdaj)
