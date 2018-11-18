resampleTo<-function(x, n){
  # Resample time series `x`, assumed to have unit time intervals, to a new vector with length n
  return(sapply(1:n, function(t) resample(x, t/n*length(x))))
}
  