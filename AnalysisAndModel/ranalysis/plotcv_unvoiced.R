cv<-read.csv("unvoiced_cv.csv")
features<-read.csv("scriptFFeaturesTrimmed1.csv")
features<-features[features$f0==0,]
N<-length(features$f0)
plot(cv$mixtures, cv$loglike.cv/(N*0.2),main="Unvoiced GMM cross validation", xaxt="n", col="red",type="l",xlab="#mixtures", ylab="avg. log likelihood")
lines(cv$mixtures, cv$loglike.cv/(N*0.2),col="red",type="p")
lines(cv$mixtures, cv$loglike.training/(N*0.6),col="black",type="l")
lines(cv$mixtures, cv$loglike.training/(N*0.6),col="black",type="p")
axis(side="1", 1:15)
abline(h=max(cv$loglike.cv/(N*0.2)),col="blue")
legend(x="bottomright",legend=c("cross validation","training"),lty=c(1,1),lwd=c(2.5,2.5),
       col=c("red","black"),bty="n")