library(dplyr)
library(signal)
library(ggplot2)

featuresF<-readRDS("scriptFFeaturesTrimmed1.rda")
featuresF<-rbind(featuresF,readRDS("scriptFFeaturesTrimmed2.rda"))
featuresF<-rbind(featuresF,readRDS("scriptFFeaturesTrimmed3.rda"))
featuresF<-rbind(featuresF,readRDS("scriptFFeaturesTrimmed4.rda"))
featuresF<-rbind(featuresF,readRDS("scriptFFeaturesTrimmed5.rda"))

featuresM<-readRDS("improMFeaturesTrimmed1.rda")
featuresM<-rbind(featuresM,readRDS("improMFeaturesTrimmed2.rda"))
featuresM<-rbind(featuresM,readRDS("improMFeaturesTrimmed3.rda"))
featuresM<-rbind(featuresM,readRDS("improMFeaturesTrimmed4.rda"))
featuresM<-rbind(featuresM,readRDS("improMFeaturesTrimmed5.rda"))

sentencesF<-unique(featuresF$sentence)
sentencesM<-unique(featuresM$sentence)
N<-min(length(sentencesF),length(sentencesM))

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
  if(sum(f0)==0 || length(f0)<10)
  {
    return (NA)
  }
  return(stats::cancor(headMatrix,f0)$cor)
}

ccaOther<-rep(0,N)
ccaSelf<-rep(0,N)
ccaRandom<-rep(0,N)
for (i in 1:N)
{
  features1<-dplyr::filter(featuresF, sentence==sentencesF[i])
  features2<-dplyr::filter(featuresM, sentence==sentencesM[i])
  
  #print(paste(sentence1, nrow(features1), sentence2, nrow(features2)))
  ccaOther[i]<-calcCCAOther(features1,features2)
  ccaSelf[i]<-calcCCAOther(features1,features1)
  ccaRandom[i]<-calcCCAOther(features1,features1[sample(nrow(features1)),])
}

cat<-factor(c(rep("self",length(ccaSelf)),rep("other actor and scenario",length(ccaOther)),rep("random",length(ccaRandom))), level=c("self","other actor and scenario","random"))
df<-data.frame(category=cat,cca=c(ccaSelf,ccaOther,ccaRandom))
print(
  ggplot(df, aes(category,cca))+geom_boxplot()
)