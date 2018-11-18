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

makebuckets<-function(l, numbuckets)
{
  min <- min(l)
  max <- max(l)
  step <- (max-min)/(numbuckets-1)
  return (seq(min,max,step))
}

getClosestBucketIndex<-function(bucket, value)
{
  min <- bucket[1]
  step <- bucket[2]-bucket[1]
  index <-1+round((value-min)/step)  
  if (index<1) index<-1
  if (index>length(bucket))index<-length(bucket)
  return (index)
}

numbuckets <- 100
f0buckets <- makebuckets(features.train$f0, numbuckets)
print(paste0("f0 step size: ",f0buckets[2]-f0buckets[1], " Hz"))
rmsEnergybuckets <- makebuckets(features.train$RMSenergy, numbuckets)
print(paste0("rmsEnergy step size: ",rmsEnergybuckets[2]-rmsEnergybuckets[1]))
pitchBuckets <- makebuckets(features.train$pitch, numbuckets)
print(paste0("pitch step size: ",pitchBuckets[2]-pitchBuckets[1], " degrees"))
yawBuckets <- makebuckets(features.train$yaw, numbuckets)
print(paste0("yaw step size: ",yawBuckets[2]-yawBuckets[1], " degrees"))
rollBuckets <- makebuckets(features.train$roll, numbuckets)
print(paste0("roll step size: ",rollBuckets[2]-rollBuckets[1], " degrees"))
vBuckets <- makebuckets(features.train$v, numbuckets)
print(paste0("v step size: ",vBuckets[2]-vBuckets[1], " degrees/frame"))
aBuckets <- makebuckets(features.train$a, numbuckets)
print(paste0("a step size: ",aBuckets[2]-aBuckets[1], " degrees/frame^2"))
buckets<-list(pitchBuckets,yawBuckets,rollBuckets,vBuckets,aBuckets)

foreach (i=1:5) %dopar%
{
  library(mixtools)  
  print(paste0("constructing ",label[i]," table."))
  bucket <- buckets[[i]]
  clabel<-label[i]
  Pfeature <- expand.grid(m=bucket,f0=f0buckets, rmsEnergy=rmsEnergybuckets,P=0)
  f<-featureMatrix[[i]]
  for (j in 1:nrow(f))
  {
    m<-f[j,1]
    f0<-f[j,2]
    e<-f[j,3]
    index <- getClosestBucketIndex(bucket,m)+(getClosestBucketIndex(f0buckets,f0)-1)*numbuckets+(getClosestBucketIndex(rmsEnergybuckets,e)-1)*numbuckets*numbuckets
    Pfeature$P[index]<-Pfeature$P[index]+1  
  }
  Pfeature$P<-Pfeature$P/nrow(f)
  #mixture<-mvnormalmixEM(featureMatrix[[i]],k=k,maxit=1000,epsilon=0.01)
  #writeGMMToXML(mixture, filename=paste0("gmmVoiced",label[i],k,".xml"))
  saveRDS(Pfeature, file = paste0("tableVoiced",label[i],".rda"))
  #print(paste0("loglike on training ",label[i], " k= ",k," ",mixture$loglik))
}