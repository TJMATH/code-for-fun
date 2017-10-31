function (x, lambda = NULL, nlambda = ifelse(is.null(lambda),
    100, length(lambda)), lambda.max = 0.8, lambda.min = ifelse(nrow(x) >
    ncol(x), 1e-04, 0.01), sigma = FALSE, perturb = TRUE, standardize = TRUE,
    logspaced = TRUE, linsolver = c("primaldual", "simplex"),
    pdtol = 0.001, pdmaxiter = 50)
# lambda <= 0.8, n>p时下限几乎为零，否则下限为0.01
# sigma ?
# perturb ?
# logspaced ?
# linsolver ?
{
    lpfun <- match.arg(linsolver, c("primaldual", "simplex"))
    # 检查参数
    if (sigma) {
        if (is.matrix(x)) {
            Sigma <- x
        }
        else {
            Sigma <- as.matrix(x)
        }
        p <- ncol(Sigma)
        x <- NULL
    }
    # 如果sigma为TRUE，x作为矩阵赋值给Sigma，p为变量个数，x赋为NULL
    else {
        n <- nrow(x)
        p <- ncol(x)
        if (is.null(lambda)) {
            if (logspaced) {
                lambda <- 10^(seq(log10(lambda.min), log10(lambda.max),
                  length.out = nlambda))
            }
            # 感觉像等比例增长的序列
            else {
                lambda <- seq(lambda.min, lambda.max, length.out = nlambda)
            }
            # 这个就直接是等差增长，不是重点
        }
        # 这一步之后lambda一定非NULL了
        if (standardize)
            x <- scale(x)
        # 是否标准化
        Sigma <- cov(x) * (1 - 1/n)
        # Sigma 是协方差矩阵
    }
    eigvals <- eigen(Sigma, only.values = T)$values
    # 求特征值
    if (is.logical(perturb)) {
        if (perturb) {
            perturb <- max(max(eigvals) - p * min(eigvals), 0)/(p -
                1)
        }
        else {
            perturb <- 0
        }
    }
    Sigma <- Sigma + diag(p) * perturb
    emat <- diag(p)
    Omegalist <- vector("list", nlambda) # ...一个nlambda那么长的列表
    if (lpfun == "simplex") {
        for (jl in 1:nlambda) {
            Omega <- matrix(0, nrow = p, ncol = p)
            lam <- lambda[jl]
            for (j in 1:p) {
                beta <- linprogS(Sigma, emat[, j], lam)
                Omega[, j] <- beta
            }
            Omegalist[[jl]] <- Omega * (abs(Omega) <= abs(t(Omega))) +
                t(Omega) * (abs(Omega) > abs(t(Omega)))
        }
    }
    if (lpfun == "primaldual") {
        Omega0 <- solve(Sigma)
        for (jl in 1:nlambda) {
            Omega <- matrix(0, nrow = p, ncol = p)
            lam <- lambda[jl]
            for (j in 1:p) {
                beta <- linprogPD(Omega0[, j], Sigma, emat[,
                  j], lam, pdtol, pdmaxiter)
                Omega[, j] <- beta
            }
            Omegalist[[jl]] <- Omega * (abs(Omega) <= abs(t(Omega))) +
                t(Omega) * (abs(Omega) > abs(t(Omega)))
        }
    }
    outlist <- list(Omegalist = Omegalist, x = x, lambda = lambda,
        perturb = perturb, standardize = standardize, lpfun = lpfun)
    class(outlist) <- c("clime")
    return(outlist)
}







linprogS <- function(Sigma, e, lambda) {
  p <- nrow(Sigma)
  if (p!=ncol(Sigma)) stop("Sigma should be a square matrix!")

  f.obj <- rep(1, 2*p)
  con1 <- cbind(-Sigma, +Sigma)
  b1 <- lambda - e
  b2 <-  lambda + e
  f.con <- rbind(-diag(2*p), con1, -con1)
  f.dir <- rep("<=", 4*p)
  f.rhs <- c(rep(0,2*p), b1, b2)
  lp.out <- lp("min", f.obj, f.con, f.dir, f.rhs)
  beta <- lp.out$solution[1:p] - lp.out$solution[(p+1):(2*p)]
  if (lp.out$status == 2) warning("No feasible solution!  Try a larger lambda maybe!")
  return(beta)
}
