resample <- function(x,t) {
  #
  # Resample time series `x`, assumed to have unit time intervals, at time `t`.
  # Uses quadratic interpolation.
  #
  # from http://stats.stackexchange.com/questions/31666/how-can-i-align-synchronize-two-signals
  n <- length(x)
  if (n < 3) stop("First argument to resample is too short; need 3 elements.")
  i <- median(c(2, floor(t+1/2), n-1)) # Clamp `i` to the range 2..n-1
  u <- t-i
  x[i-1]*u*(u-1)/2 - x[i]*(u+1)*(u-1) + x[i+1]*u*(u+1)/2
}