features<-read.csv("scriptFFeaturesTrimmed1.csv")
featuresUnvoiced<-features[features$f0==0,]
featuresVoiced<-features[features$f0>0,]
print(summary(featuresUnvoiced$pitch))