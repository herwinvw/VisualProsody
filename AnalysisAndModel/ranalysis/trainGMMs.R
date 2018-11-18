library(mixtools)
features<-read.csv("scriptFFeaturesTrimmed1.csv")
#features<-scriptFFeatures[[1]]
#features<-features[features$session=="Ses01F_script01_1",]
#features<-sample(features)
pitch<-normalize(features$pitch)
f0<-normalize(features$f0)
RMSenergy<-normalize(features$RMSenergy)
pitchFeatureMatrix<-matrix(c(pitch[f0>0],f0[f0>0],RMSenergy[f0>0]),ncol=3)

#gmmPitch.boot <- boot.comp(pitchFeatureMatrix,max.comp=15,mix.type="mvnormalmix",
#                       maxit=400,epsilon=0.01)
timing<-system.time({
gmmPitch <- mvnormalmixEM(pitchFeatureMatrix,k=2,maxit=100,epsilon=0.01,verb=TRUE)
})