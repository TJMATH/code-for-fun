getData <- function(n, p, beta, sigma, independentrows = True){
  if(n > p){
    print('Warning: the number of observations is greater than dimension')
  }
  s0 <- sum(beta!=0)
  if (s0 > p){
    print('Warning: Dimension should be greater than s0. And we will force the dimension parameter equal to s0')
    p <- s0
  }
  beta <- c(beta, rep(0,p - s0))
  X <- matrix(rnorm(n * p, 0, 1), n, p)
  error <- rnorm(n, 0, sigma)
  Y <- X%*%beta + error
  return(list(X, Y, error))
}

getLambda <- function(Y, X){
  XX <- cbind(1, X)
}

getThetaLasso <- function(Y, X, lambda, lambdaj){
  
}

