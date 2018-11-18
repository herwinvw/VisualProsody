library(mixtools)

#setup parallel processing
library(doParallel)
cl<-makeCluster(8,outfile="");
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
  pitch<-f$pitch
  f0<-f$f0
  RMSenergy<-f$RMSenergy
  return(matrix(c(pitch,f0,RMSenergy),ncol=3))
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

maxmixtures=8
result<-foreach (k=8:maxmixtures) %dopar%
{
  library(mixtools)
  source("loglikenormalmix.r")
  source("mvdnormalmix.r")

  print(paste0("learning gmm with ",k, " mixtures"))
  mixture <- mvnormalmixEM(trainingMatrix,k=k,maxit=1000,epsilon=0.01)
  loglikes.cv <- loglike.normalmix(cvMatrix,mixture=mixture)
  print(paste0("loglike on training ",mixture$loglik," for k ",k))
  print(paste0("loglike on cv ", loglikes.cv," for k ",k))

  write.table(mixture$loglik, file=paste0("willie_loglike_voiced_training_",k,".csv"),col.names=FALSE,row.names=FALSE)
  write.table(loglikes.cv, file=paste0("willie_loglike_voiced_cv_",k,".csv"),col.names=FALSE,row.names=FALSE)
}
