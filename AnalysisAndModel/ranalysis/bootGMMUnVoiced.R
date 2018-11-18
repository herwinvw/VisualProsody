library(mixtools)
features<-read.csv("scriptFFeaturesTrimmed1.csv")

features<-features[features$f0==0,]

constructFeatureMatrix<-function(f)
{
  pitch<-f$pitch
  RMSenergy<-f$RMSenergy
  return(matrix(c(pitch,RMSenergy),ncol=2))
}

gmmPitch.boot <- boot.comp(constructFeatureMatrix(features),max.comp=15,mix.type="mvnormalmix",
                       maxit=400,epsilon=0.01)