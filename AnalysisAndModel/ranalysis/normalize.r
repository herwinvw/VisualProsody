normalize<-function(x){
  y <- x-mean(x)
  return(y/(max(y)-min(y)))
}