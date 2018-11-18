plotcv<-function(cv, features, title)
{
features<-features[features$f0>0,]
N<-length(features$f0) 
plot(c(cv$gaussians,cv$gaussians), c(cv$loglik_cv/(N*0.2),cv$loglik_training/(N*0.6)),type="n",main=title,xlab="#mixtures",xaxt="n",ylab="avg. log likelihood")
lines(cv$gaussians, cv$loglik_cv/(N*0.2),col="red",type="l")
lines(cv$gaussians, cv$loglik_cv/(N*0.2),col="red",type="p")
lines(cv$gaussians, cv$loglik_training/(N*0.6),col="black",type="l")
lines(cv$gaussians, cv$loglik_training/(N*0.6),col="black",type="p")
axis(side="1", 2:15)
abline(h=max(cv$loglik_cv,na.rm=TRUE)/(N*0.2),col="blue")
legend(x="bottomright",legend=c("cross validation","training"),lty=c(1,1),lwd=c(2.5,2.5),
       col=c("red","black"),bty="n")
}

plotcvtime<-function(cv, title)
{
  plot(cv$gaussians, (cv$usertime+cv$systemtime)/(60*60), xlab="#mixtures", ylab="training duration (hours)", main=title,)
  lines(cv$gaussians, (cv$usertime+cv$systemtime)/(60*60))
  axis(side="1", 2:15)
}

features<-read.csv("scriptFFeaturesTrimmed1.csv")
cv<-read.csv("cvinfov.csv")
plotcv(cv, features,"Voiced GMM cross validation, velocity")
plotcvtime(cv, "Training duration of GMMs for velocity")