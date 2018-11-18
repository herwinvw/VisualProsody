loglike.normalmix <- function(x,mixture) {
  loglike <- mvdnormalmix(x,mixture,log=TRUE)
  return(sum(loglike))
}