library(dplyr)
library(signal)
library(ggplot2)

calcCCAOther<-function(features1,features2)
{
  if(nrow(features1)<nrow(features2))  
  {
    features2<-features2[1:nrow(features1),]
  }
  else
  {
    features1<-features1[1:nrow(features2),]
  }
  f0<-features1$f0
  headMatrix<-matrix(c(features2$pitch,features2$yaw,features2$roll), ncol=3)
  if(length(f0)<10 || sum(f0)==0)
  {
    return (NA)
  }
  return(stats::cancor(headMatrix,f0)$cor)
}

featuresF<-readRDS("scriptFFeaturesTrimmed1.rda")
featuresM<-readRDS("improMFeaturesTrimmed1.rda")
sentencesF<-unique(featuresF$sentence)
sentencesM<-unique(featuresM$sentence)
N<-min(length(sentencesF),length(sentencesM))

features<-readRDS("scriptFFeaturesTrimmed1.rda")
features<-rbind(features,readRDS("scriptFFeaturesTrimmed2.rda"))
features<-rbind(features,readRDS("scriptFFeaturesTrimmed3.rda"))
features<-rbind(features,readRDS("scriptFFeaturesTrimmed4.rda"))
features<-rbind(features,readRDS("scriptFFeaturesTrimmed5.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed1.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed2.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed3.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed4.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed5.rda"))


sentences<-unique(features$sentence)

ccaNext<-rep(0,length(sentences))
ccaSelf<-rep(0,length(sentences))
ccaRandom<-rep(0,length(sentences))
for (i in 1:length(sentences))
{
  sentence1<-sentences[i]
  if(i+1<=length(sentences))
  {
    sentence2<-sentences[i+1]
  }
  else
  {
    sentence2<-sentences[1]
  }
  features1<-dplyr::filter(features, sentence==sentence1)
  features2<-dplyr::filter(features, sentence==sentence2)
  #print(paste(sentence1, nrow(features1), sentence2, nrow(features2)))
  ccaNext[i]<-calcCCAOther(features1,features2)
  ccaSelf[i]<-calcCCAOther(features1,features1)
  ccaRandom[i]<-calcCCAOther(features1,features1[sample(nrow(features1)),])
}

ccaOther<-rep(0,N)
for (i in 1:N)
{
  features1<-dplyr::filter(featuresF, sentence==sentencesF[i])
  features2<-dplyr::filter(featuresM, sentence==sentencesM[i])
  ccaOther[i]<-calcCCAOther(features1,features2)
}

theme_set(theme_gray(base_size = 22))
cat<-factor(c(rep("self",length(ccaSelf)),rep("next sentence",length(ccaNext)),rep("other speaker",length(ccaOther)),rep("random",length(ccaRandom))), level=c("self","next sentence","other speaker","random"))
df<-data.frame(condition=cat,cca=c(ccaSelf,ccaNext,ccaOther,ccaRandom))
print(
  ggplot(df, aes(condition,cca))+geom_boxplot()
)
print(summary(ccaSelf))
print(summary(ccaRandom))