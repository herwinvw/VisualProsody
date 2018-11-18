library(dplyr)
library(signal)
library(ggplot2)
library(CCA)

features<-readRDS("scriptFFeaturesTrimmed1.rda")
# features<-rbind(features,readRDS("scriptFFeaturesTrimmed2.rda"))
# features<-rbind(features,readRDS("scriptFFeaturesTrimmed3.rda"))
# features<-rbind(features,readRDS("scriptFFeaturesTrimmed4.rda"))
# features<-rbind(features,readRDS("scriptFFeaturesTrimmed5.rda"))
# features<-rbind(features,readRDS("scriptMFeaturesTrimmed1.rda"))
# features<-rbind(features,readRDS("scriptMFeaturesTrimmed2.rda"))
# features<-rbind(features,readRDS("scriptMFeaturesTrimmed3.rda"))
# features<-rbind(features,readRDS("scriptMFeaturesTrimmed4.rda"))
# features<-rbind(features,readRDS("scriptMFeaturesTrimmed5.rda"))

#features<-features%>%group_by(sentence)%>%dplyr::filter(sum(f0)>0)
#features<-features[features$f0>100,]
sentences<-unique(features$sentence)

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
  f0Matrix<-matrix(c(features1$f0,features1$vf0,features1$af0), ncol=3)
  if(sum(f0)==0)
  {
    return (NA)
  }
  #return(stats::cancor(headMatrix,f0Matrix,xcenter=T,ycenter=T)$cor[1])  
  return(stats::cancor(headMatrix,f0,xcenter=T,ycenter=T)$cor[1])  
}

ccaOther<-rep(0,length(sentences))
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
  ccaOther[i]<-calcCCAOther(features1,features2)
  ccaSelf[i]<-calcCCAOther(features1,features1)
  ccaRandom[i]<-calcCCAOther(features1,features1[sample(nrow(features1)),])
}

cat<-factor(c(rep("self",length(ccaSelf)),rep("next sentence",length(ccaOther)),rep("random",length(ccaRandom))), level=c("self","next sentence","random"))
df<-data.frame(category=cat,cca=c(ccaSelf,ccaOther,ccaRandom))
print(
  ggplot(df, aes(category,cca))+geom_boxplot()
)
print(summary(ccaRandom))
print(summary(ccaSelf))