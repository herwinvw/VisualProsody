features<-read.csv("scriptFFeaturesTrimmed1.csv")
features<-features[features$f0>0,]
hist(features$pitch,breaks=60,main="Voiced pitch",xlab="pitch")
hist(features$yaw,breaks=60,main="Voiced yaw",xlab="yaw")
hist(features$roll,breaks=60,main="Voiced roll",xlab="roll")