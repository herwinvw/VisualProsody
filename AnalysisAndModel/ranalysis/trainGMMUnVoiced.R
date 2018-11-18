library(mixtools)
source("writeGMMToXML.r")

features<-read.csv("scriptFFeaturesTrimmed1.csv")
features<-features[features$f0==0,]
features<-sample(features)
n<-nrow(features)
features.train<-features[1:floor(0.6*n),]

constructPitchFeatureMatrix<-function(f)
{
  pitch<-f$pitch
  RMSenergy<-f$RMSenergy
  return(matrix(c(pitch,RMSenergy),ncol=2))
}

constructYawFeatureMatrix<-function(f)
{
  yaw<-f$yaw
  RMSenergy<-f$RMSenergy
  return(matrix(c(yaw,RMSenergy),ncol=2))
}

constructRollFeatureMatrix<-function(f)
{
  roll<-f$roll
  RMSenergy<-f$RMSenergy
  return(matrix(c(roll,RMSenergy),ncol=2))
}

constructVFeatureMatrix<-function(f)
{
  v<-f$v
  RMSenergy<-f$RMSenergy
  return(matrix(c(v,RMSenergy),ncol=2))
}

constructAFeatureMatrix<-function(f)
{
  a<-f$a
  RMSenergy<-f$RMSenergy
  return(matrix(c(a,RMSenergy),ncol=2))
}

featureMatrix <- list(
  constructPitchFeatureMatrix(features.train),
  constructYawFeatureMatrix(features.train),
  constructRollFeatureMatrix(features.train),
  constructVFeatureMatrix(features.train),
  constructAFeatureMatrix(features.train)
)

label<-c("pitch","yaw","roll","v","a")
library(doParallel)
cl<-makeCluster(5,outfile="");
registerDoParallel(cl)

k<-6
foreach (i=1:5) %dopar%
{
  library(mixtools)  
  print(paste0("learning ",label[i]," gmm with ",k, " mixtures"))
  mixture<-mvnormalmixEM(featureMatrix[[i]],k=k,maxit=1000,epsilon=0.01)
  writeGMMToXML(mixture, filename=paste0("gmmUnVoiced",label[i],k,".xml"))
  saveRDS(mixture, file = paste0("gmmUnVoiced",label[i],k,".rda"))
  print(paste0("loglike on training ",label[i], " k= ",k," ",mixture$loglik))
}