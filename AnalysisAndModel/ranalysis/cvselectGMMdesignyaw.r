library(mixtools)

#setup parallel processing
library(doParallel)
cl<-makeCluster(3,outfile="");
registerDoParallel(cl)

features<-read.csv("scriptFFeaturesTrimmed1.csv")
features<-features[features$f0>0,]
features<-sample(features)
n<-nrow(features)
features.train<-features[1:floor(0.6*n),]
features.cv<-features[(floor(0.6*n)+1):floor(0.8*n),]
features.test<-features[1+floor(0.8*n):n,]

constructFeatureMatrix<-function(f)
{
  yaw<-f$yaw
  f0<-f$f0
  RMSenergy<-f$RMSenergy
  return(matrix(c(yaw,f0,RMSenergy),ncol=3))
}

loglikes.cv <- vector(length=10)
mixture<-list()
# k=1 needs special handling
trainingMatrix<-constructFeatureMatrix(features.train)
cvMatrix<-constructFeatureMatrix(features.cv)
mu<-colMeans(trainingMatrix) 
sigma <- cov(trainingMatrix) 
print(paste0("learning gmm with 1 mixture"))
loglikes.cv[1] <- sum(log(dmvnorm(cvMatrix,mu,sigma)))
print(paste0("loglike on training ",sum(log(dmvnorm(trainingMatrix,mu,sigma)))))
print(paste0("loglike on cv ", loglikes.cv[1] ))
write.table(sum(log(dmvnorm(trainingMatrix,mu,sigma))), file=paste0("loglike_voiced_trainingyaw_1.csv"),col.names=FALSE,row.names=FALSE)
write.table(loglikes.cv[1], file=paste0("loglike_voicedyaw_cv_1.csv"),col.names=FALSE,row.names=FALSE)

maxmixtures=15
result<-foreach (k=2:maxmixtures) %dopar%
{
  library(mixtools)
  source("loglikenormalmix.r")
  source("mvdnormalmix.r")

  print(paste0("learning gmm with ",k, " mixtures"))
  mixture <- mvnormalmixEM(trainingMatrix,k=k,maxit=400,epsilon=0.01)
  loglikes.cv <- loglike.normalmix(cvMatrix,mixture=mixture)
  print(paste0("loglike on training (k=",k,"): ",mixture$loglik))
  print(paste0("loglike on cv  (k=",k,"): ", loglikes.cv))

  write.table(mixture$loglik, file=paste0("loglike_voiced_trainingyaw_",k,".csv"),col.names=FALSE,row.names=FALSE)
  write.table(loglikes.cv, file=paste0("loglike_voicedyaw_cv_",k,".csv"),col.names=FALSE,row.names=FALSE)
  
  writeGMMToXML(mixture, filename=paste0("gmmVoicedCV_yaw",k,".xml"))
  saveRDS(mixture, file = paste0("gmmVoicedCV_yaw",k,".rda"))  
}