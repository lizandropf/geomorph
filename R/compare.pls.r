#' Comparisons of Effect Sizes from Partial Least Squares
#'
#' Function performs an analysis to compare the effect sizes of two or more PLS effects
#'
#' The function statistically compares the effect sizes of two or more PLS analyses.  Typically, this
#' function might be used to compare levels of integration between two or more samples, each measuring morphological 
#' integration between different modules.  In such cases, the PLS correlation coefficient, r, is not a good
#' measure of integration effect, as its expected value is dependent on both the number of specimens and number 
#' of variables (Adams and Collyer 2016).  This analysis calculates effect sizes as standard deviates, z, and 
#' performs two-sample z-tests, using the pooled standard error from the sampling distributions of the PLS analyses.
#'  
#'  To use this function, simply perform \code{\link{two.b.pls}}, \code{\link{integration.test}}, or 
#'  \code{\link{phylo.integration}} on as many samples as desired.  Any number of objects of class "pls" can be input.
#'  
#'  Similar versions of this function will designed for alternative test statistics, in the future. 
#' 
#' @param ... saved analyses of class, "pls"
#' @keywords analysis
#' @export
#' @author Michael Collyer
#' @return An object of class, "compare.pls", returns a list of the following
#' \item{sample.z}{A vector of effect sizes for each sample.}
#' \item{sample.r.sd}{A vector of standard deviations for each sampling distribution.}
#' \item{pairwise.z}{A matrix of pariwise, two-sample z scores betwen all pairs of effect sizes.}
#' \item{pairwise.p}{A matrix of corresponding P-values.}
#' @references Adams, D.C and M.L. Collyer. 2016. On the comparison of the strength of morphological 
#' integration across morphometric datasets. Evolution (in press)
#' @examples
#' # Example of comparative morphological intgration between pupfish head and body shapes
#' 
#'  data(pupfish) # GPA previously performed
#'   
#'  group <- factor(paste(pupfish$Pop, pupfish$Sex, sep = "."))
#'  levels(group)
#'   
#'  tail.LM <- c(1:3, 5:9, 18:38)
#'  head.LM <- (1:56)[-tail.LM]
#' 
#'  tail.coords <- pupfish$coords[tail.LM,,]
#'  head.coords <- pupfish$coords[head.LM,,]
#' 
#'  # Subset by group
#'  tail.coords.gp <- coords.subset(tail.coords, group)
#'  head.coords.gp <- coords.subset(head.coords, group)
#' 
#'  integ.tests <- Map(function(x,y) integration.test(x, y), head.coords.gp, tail.coords.gp)
#' 
#'  integ.tests$Marsh.F
#'  integ.tests$Marsh.M
#'  integ.tests$Sinkhole.F
#'  integ.tests$Sinkhole.M
#' 
#'  group.Z <- compare.pls(integ.tests)
#'  summary(group.Z)
#' 
#'  # Sexual dimorphism in morpholigical intrgartion in one population
#'  # but not the other
#' 
#'  # can also list different PLS analyses, seprately
#' 
#'  compare.pls(MF = integ.tests$Marsh.F, MM = integ.tests$Marsh.M)
#' 
 compare.pls <- function(...){
   dots <- list(...)
   if(length(dots) == 1) n <- length(dots[[1]]) else n <- length(dots)
   if(n == 1) stop("At least two objects of class pls are needed")
   if(length(dots) == 1) {
     list.names <- names(dots[[1]]) 
     dots <- lapply(1:n, function(j) dots[[1]][[j]])
     names(dots) <- list.names
     } else list.names <- names(dots)
   if(length(dots) < 2) stop("At least two objects of class pls are needed")
   is.pls <- function(x) class(x) == "pls"
   sdn <- function(x) sqrt(sum((x-mean(x))^2)/length(x))
   list.check <- sapply(1:length(dots), function(j) any(is.pls(dots[[j]])))
   if(any(list.check == FALSE)) stop("Not all objects are class pls")
   k <- length(list.check)
   if(is.null(list.names)) list.names <- as.list(substitute(list(...)))[-1L]
   k.combn <- combn(k,2)
   list.drs <- sapply(1:k, function(j) dots[[j]]$r.pls - mean(dots[[j]]$random.r[-1]))
   list.sds <- sapply(1:k, function(j) sdn(dots[[j]]$random.r[-1]))
   list.zs <- sapply(1:k, function(j) effect.size(dots[[j]]$random.r, center=TRUE))
   z12 <- sapply(1:ncol(k.combn), function(j){
     a <- k.combn[1,j]; b <- k.combn[2,j]
     r1 <- list.drs[a]; r2 <- list.drs[b]; sd1 <- list.sds[a]; sd2 <- list.sds[b]
     abs(r1-r2)/sqrt(sd1^2+sd2^2)
   })
   z12.p <- sapply(1:length(z12), function(j) 1-pnorm(z12[[j]]))
   d <- rep(0,k); names(d) <- list.names
   D <-dist(d)
   z12.pw <- p12.pw <- D
   for(i in 1:length(z12)) z12.pw[i] <-z12[i]
   for(i in 1:length(z12)) p12.pw[i] <-z12.p[i]
   names(list.zs) <- names(list.sds) <-list.names
   pairwise.z <- as.matrix(z12.pw)
   pairwise.P <- as.matrix(p12.pw)
   diag(pairwise.P) <- 1
   
   out <- list(sample.z = list.zs,
               sample.r.sd = list.sds,
               pairwise.z = pairwise.z,
               pairwise.P = pairwise.P)
   class(out) <- "compare.pls"
   out
 }
 