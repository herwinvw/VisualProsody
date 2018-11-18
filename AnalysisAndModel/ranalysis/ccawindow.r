library(dplyr)
library(signal)
library(ggplot2)
# 
# features<-readRDS("scriptFFeaturesTrimmed1.rda")
# features<-rbind(features,readRDS("scriptFFeaturesTrimmed2.rda"))
# features<-rbind(features,readRDS("scriptFFeaturesTrimmed3.rda"))
# features<-rbind(features,readRDS("scriptFFeaturesTrimmed4.rda"))
# features<-rbind(features,readRDS("scriptFFeaturesTrimmed5.rda"))

features<-(readRDS("scriptMFeaturesTrimmed1.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed2.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed3.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed4.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed5.rda"))

#features<-features%>%group_by(sentence)%>%dplyr::filter(sum(f0)>0)
#features<-features[features$f0>0,]
sentences<-unique(features$sentence)

WINDOWSIZE = 120*2
#WINDOWSIZE = 120
calcCCAWindow<-function(features)
{
  N<-nrow(features)
  lags<-1:min(WINDOWSIZE,N-1)  
  values=rep(NA,WINDOWSIZE*2+1)
  
  #positive lag
  for(i in lags)
  {
    features1<-features[1:(N-i),]#1..N-1 till 1..N-WINDOWSIZE
    features2<-features[(i+1):N,]#2..N till 1+WINDOWSIZE..N
    f0<-features1$f0
    headMatrix<-matrix(c(features2$pitch,features2$yaw,features2$roll), ncol=3)
    if(sum(f0)>0 && length(f0)>10)
    {
      values[WINDOWSIZE+i+1]=stats::cancor(headMatrix,f0)$cor  #WINDOWSIZE+2..2*WINDOWSIZE+1 (windowsize items)
    }        
  }
  #no lag
  headMatrix<-matrix(c(features$pitch,features$yaw,features$roll), ncol=3)
  f0<-features$f0
  if(sum(f0)>0  && length(f0)>10)
  {
    values[WINDOWSIZE+1]=stats::cancor(headMatrix,f0)$cor
  }
  
  #negative lag
  for(i in lags)
  {
    features2<-features[1:(N-i),]
    features1<-features[(i+1):N,]
    f0<-features1$f0
    headMatrix<-matrix(c(features2$pitch,features2$yaw,features2$roll), ncol=3)
    if(sum(f0)>0  && length(f0)>10)
    {
      values[i]=stats::cancor(headMatrix,f0)$cor  #1..WINDOWSIZE (windowsize items)
    }        
  }
  return(values)
}

ccas<-c()
for (s in sentences)
{
  features1<-dplyr::filter(features, sentence==s)
  ccas<-c(ccas,calcCCAWindow(features1))
}
ccaMatrix<-matrix(ccas,nrow=WINDOWSIZE*2+1)
ccaMeans<-rowMeans(ccaMatrix,na.rm=T)
print(paste("max cca value:",max(ccaMeans,na.rm=T),"index:",1000*(which.max(ccaMeans)-(WINDOWSIZE+1))/120,"ms"))
print(paste("value at 0 lag: ",ccaMeans[WINDOWSIZE+1]))
motionlag<-1:(WINDOWSIZE*2+1)-(WINDOWSIZE+1)
motionlag<-motionlag/120
plot(x=motionlag,ccaMeans,type="l")