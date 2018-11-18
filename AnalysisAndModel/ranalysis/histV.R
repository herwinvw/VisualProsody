library(ggplot2)
#library(plyr)
theme_set(theme_gray(base_size = 22))
features<-read.csv("scriptFFeaturesTrimmed1.csv")
features$voiced <- features$f0>0
#cdf <- ddply(features, "voiced", summarise, v.mean=median(v))

print(ggplot(features, aes(x=v,colour=voiced))
      +geom_density()+xlim(0,1)
      )
#+geom_vline(data=cdf, aes(xintercept=v.mean,  colour=voiced),
#           linetype="dashed", size=1)
print("Percentage voiced:")
print(sum(features$voiced)/nrow(features))