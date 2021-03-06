%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not modify this file since it was automatically generated from:
% 
%  fitPrincipalCurve.R
% 
% by the Rdoc compiler part of the R.oo package.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{fitPrincipalCurve}
\alias{fitPrincipalCurve}

\alias{fitPrincipalCurve.matrix}

\title{Fit a principal curve in K dimensions}

\description{
  Fit a principal curve in K dimensions.
}

\usage{
\method{fitPrincipalCurve}{matrix}(X, ..., verbose=FALSE)
}

\arguments{
 \item{X}{An NxK \code{\link[base]{matrix}} (K>=2) where the columns represent the dimension.}
 \item{...}{Other arguments passed to \code{\link[princurve]{principal.curve}}.}
 \item{verbose}{A \code{\link[base]{logical}} or a \code{\link[R.utils]{Verbose}} object.}
}

\value{
  Returns a principal.curve object (which is a \code{\link[base]{list}}).
  See \code{\link[princurve]{principal.curve}} for more details.
}

\section{Missing values}{
 The estimation of the normalization function will only be made
 based on complete observations, i.e. observations that contains no \code{\link[base]{NA}}
 values in any of the channels.
}

\author{Henrik Bengtsson}

\references{
[1] Hastie, T. and Stuetzle, W, \emph{Principal Curves}, JASA, 1989.\cr
[2] H. Bengtsson, A. Ray, P. Spellman and T.P. Speed, \emph{A single-sample method for normalizing and combining full-resolutioncopy numbers from multiple platforms, labs and analysis methods}, Bioinformatics, 2009.
 \cr
}

\examples{

# Simulate data from the model y <- a + bx + x^c + eps(bx)
J <- 1000
x <- rexp(J)
a <- c(2,15,3)
b <- c(2,3,4)
c <- c(1,2,1/2)
bx <- outer(b,x)
xc <- t(sapply(c, FUN=function(c) x^c))
eps <- apply(bx, MARGIN=2, FUN=function(x) rnorm(length(b), mean=0, sd=0.1*x))
y <- a + bx + xc + eps
y <- t(y)

# Fit principal curve through (y_1, y_2, y_3)
fit <- fitPrincipalCurve(y, verbose=TRUE)

# Flip direction of 'lambda'?
rho <- cor(fit$lambda, y[,1], use="complete.obs")
flip <- (rho < 0)
if (flip) {
  fit$lambda <- max(fit$lambda, na.rm=TRUE)-fit$lambda
}


# Backtransform (y_1, y_2, y_3) to be proportional to each other
yN <- backtransformPrincipalCurve(y, fit=fit)

# Same backtransformation dimension by dimension
yN2 <- y
for (cc in 1:ncol(y)) {
  yN2[,cc] <- backtransformPrincipalCurve(y, fit=fit, dimensions=cc)
}
stopifnot(identical(yN2, yN))


xlim <- c(0, 1.04*max(x))
ylim <- range(c(y,yN), na.rm=TRUE)


# Pairwise signals vs x before and after transform
layout(matrix(1:4, nrow=2, byrow=TRUE))
par(mar=c(4,4,3,2)+0.1)
for (cc in 1:3) {
  ylab <- substitute(y[c], env=list(c=cc))
  plot(NA, xlim=xlim, ylim=ylim, xlab="x", ylab=ylab)
  abline(h=a[cc], lty=3)
  mtext(side=4, at=a[cc], sprintf("a=\%g", a[cc]),
        cex=0.8, las=2, line=0, adj=1.1, padj=-0.2)
  points(x, y[,cc])
  points(x, yN[,cc], col="tomato")
  legend("topleft", col=c("black", "tomato"), pch=19,
                    c("orignal", "transformed"), bty="n")
}
title(main="Pairwise signals vs x before and after transform", outer=TRUE, line=-2)


# Pairwise signals before and after transform
layout(matrix(1:4, nrow=2, byrow=TRUE))
par(mar=c(4,4,3,2)+0.1)
for (rr in 3:2) {
  ylab <- substitute(y[c], env=list(c=rr))
  for (cc in 1:2) {
    if (cc == rr) {
      plot.new()
      next
    }
    xlab <- substitute(y[c], env=list(c=cc))
    plot(NA, xlim=ylim, ylim=ylim, xlab=xlab, ylab=ylab)
    abline(a=0, b=1, lty=2)
    points(y[,c(cc,rr)])
    points(yN[,c(cc,rr)], col="tomato")
    legend("topleft", col=c("black", "tomato"), pch=19,
                      c("orignal", "transformed"), bty="n")
  }
}
title(main="Pairwise signals before and after transform", outer=TRUE, line=-2)
}

\seealso{
  \code{\link{backtransformPrincipalCurve}}().
  \code{\link[princurve]{principal.curve}}.
}
\keyword{methods}
