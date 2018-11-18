library(mixtools)
features<-read.csv("scriptFFeaturesTrimmed1.csv")

features<-features[features$f0>0,]

constructFeatureMatrix<-function(f)
{
  pitch<-f$pitch
  f0<-f$f0
  RMSenergy<-f$RMSenergy
  return(matrix(c(pitch,f0,RMSenergy),ncol=3))
}

gmmPitch.boot <- boot.comp(constructFeatureMatrix(features),max.comp=15,mix.type="mvnormalmix",
                       maxit=400,epsilon=0.01)