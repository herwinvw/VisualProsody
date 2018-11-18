discreteSample<-function(v,N)
{
  step<-length(v)/N
  result<-rep(0,N)
  for(i in 1:N)
  {
    result[i]<-v[floor(1+(i-1)*step)]
    #print(paste(i,ceiling(1+(i-1)*step),result[i],length(v)))
  }
  return(result)
}