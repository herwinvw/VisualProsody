library(mixtools)

#setup parallel processing
library(doParallel)
cl<-makeCluster(8,outfile="");
registerDoParallel(cl)

features<-read.csv("scriptFFeaturesTrimmed1.csv")
features<-features[features$f0==0,]
features<-sample(features)
n<-nrow(features)
features.train<-features[1:floor(0.6*n),]
features.cv<-features[(floor(0.6*n)+1):floor(0.8*n),]
features.test<-features[1+floor(0.8*n):n,]

constructFeatureMatrix<-function(f)
{
  pitch<-f$pitch
  RMSenergy<-f$RMSenergy
  return(matrix(c(pitch,RMSenergy),ncol=2))
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

result<-foreach (k=2:11) %dopar%
{
  library(mixtools)
  source("loglikenormalmix.r")
  source("mvdnormalmix.r")
  ptm<-proc.time()
  
  print(paste0("learning gmm with ",k, " mixtures"))
  mixture <- mvnormalmixEM(trainingMatrix,k=k,maxit=400,epsilon=0.01)
  loglikes.cv <- loglike.normalmix(cvMatrix,mixture=mixture)
  print(paste0("loglike on training, k= ",k," ",mixture$loglik))
  print(paste0("loglike on cv k= ",k, " ",loglikes.cv))
  
  ptmdiff<-proc.time()-ptm    
  df<-data.frame(k, mixture$loglik, loglikes.cv, ptmdiff[1], ptmdiff[2], ptmdiff[3])
  names(df)<-c("gaussians","loglik_training","loglik_cv","usertime","systemtime","elapsedtime")
  df
  #list(mixture, loglikes.cv)
}
df<-do.call("rbind",result)
write.csv(df,file="cvinfo.csv", row.names=FALSE)
stopCluster(cl)