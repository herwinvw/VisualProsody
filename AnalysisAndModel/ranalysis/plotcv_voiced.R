plotcv<-function(cv, features, title)
{
features<-features[features$f0>0,]
N<-length(features$f0) 
plot(c(cv$mixtures,cv$mixtures), c(cv$loglike.cv/(N*0.2),cv$loglike.training/(N*0.6)),type="n",main=title,xlab="#mixtures",xaxt="n",ylab="avg. log likelihood")
lines(cv$mixtures, cv$loglike.cv/(N*0.2),col="red",type="l")
lines(cv$mixtures, cv$loglike.cv/(N*0.2),col="red",type="p")
lines(cv$mixtures, cv$loglike.training/(N*0.6),col="black",type="l")
lines(cv$mixtures, cv$loglike.training/(N*0.6),col="black",type="p")
axis(side="1", 1:15)
abline(h=max(cv$loglike.cv,na.rm=TRUE)/(N*0.2),col="blue")
legend(x="bottomright",legend=c("cross validation","training"),lty=c(1,1),lwd=c(2.5,2.5),
       col=c("red","black"),bty="n")
}
features<-read.csv("scriptFFeaturesTrimmed1.csv")

cv<-read.csv("likelihood_voiced_cv.csv")
plotcv(cv, features,"Voiced GMM cross validation, pitch")

#cv<-read.csv("likelihoodyaw_cv.csv")
#plotcv(cv, features,"Voiced GMM cross validation, yaw")

cv<-read.csv("likelihooda_cv.csv")
plotcv(cv,features,"Voiced GMM cross validation, acceleration")

cv<-read.csv("likelihoodafiltered_cv.csv")
plotcv(cv,features,"Voiced GMM cross validation, acceleration (filtered)")

cv<-read.csv("likelihoodv_cv.csv")
plotcv(cv,features,"Voiced GMM cross validation, velocity")