library(mixtools)
source("writeGMMToXML.r")

features<-read.csv("scriptFFeaturesTrimmed1.csv")
features<-features[features$f0>0,]
features<-sample(features)
n<-nrow(features)
features.train<-features[1:floor(0.6*n),]

constructPitchFeatureMatrix<-function(f)
{
  return(matrix(c(f$pitch,f$f0,f$RMSenergy),ncol=3))
}

constructYawFeatureMatrix<-function(f)
{
  return(matrix(c(f$yaw,f$f0,f$RMSenergy),ncol=3))
}

constructRollFeatureMatrix<-function(f)
{
  return(matrix(c(f$roll,f$f0,f$RMSenergy),ncol=3))
}

constructVFeatureMatrix<-function(f)
{
  return(matrix(c(f$v,f$f0,f$RMSenergy),ncol=3))
}

constructAFeatureMatrix<-function(f)
{
  return(matrix(c(f$a,f$f0,f$RMSenergy),ncol=3))
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
cl<-makeCluster(2,outfile="");
registerDoParallel(cl)

k<-11
#foreach (i=1:5) %dopar%
foreach (i=4:5) %dopar%
{
  library(mixtools)  
  print(paste0("learning ",label[i]," gmm with ",k, " mixtures"))
  mixture<-mvnormalmixEM(featureMatrix[[i]],k=k,maxit=1000,epsilon=0.01)
  writeGMMToXML(mixture, filename=paste0("gmmVoiced",label[i],k,".xml"))
  saveRDS(mixture, file = paste0("gmmVoiced",label[i],k,".rda"))
  print(paste0("loglike on training ",label[i], " k= ",k," ",mixture$loglik))
}