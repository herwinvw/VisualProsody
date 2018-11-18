library(ggplot2)
library(plyr)
library(dplyr)

source("discreteSample.R")
getCCA<-function(appointment,condition)
{
  head<-read.csv(paste0("stimuli/",condition,"/",appointment,"_hannah_head.csv"))
  voice<-read.csv(paste0("stimuli/speech/",appointment,"_hannah.wavAcf.csv"))
  f0<-voice$F0_sma
  roll<-discreteSample(head$roll,length(f0))
  pitch<-discreteSample(head$pitch,length(f0))
  yaw<-discreteSample(head$yaw,length(f0))
  headMatrix<-matrix(c(roll,pitch,yaw), ncol=3)
  cor<-stats::cancor(headMatrix,f0)$cor
  #print(paste("all",appointment, condition, cor))
  return(cor)
}

getCCAVoiced<-function(appointment,condition)
{
  head<-read.csv(paste0("stimuli/",condition,"/",appointment,"_hannah_head.csv"))
  voice<-read.csv(paste0("stimuli/speech/",appointment,"_hannah.wavAcf.csv"))
  f0<-voice$F0_sma
  roll<-discreteSample(head$roll,length(f0))
  pitch<-discreteSample(head$pitch,length(f0))
  yaw<-discreteSample(head$yaw,length(f0))
  headMatrix<-matrix(c(roll,pitch,yaw), ncol=3)
  roll<-roll[f0>0]
  pitch<-pitch[f0>0]
  yaw<-yaw[f0>0]
  f0<-f0[f0>0]
  headMatrix<-matrix(c(roll,pitch,yaw), ncol=3)
  cor<-stats::cancor(headMatrix,f0)$cor
  #print(paste("voiced",appointment, condition, cor))
  return(cor)
}

ccas<-data.frame(condition=c(rep("baseline",5),rep("herwin",5),rep("yu",5)), 
                sentence=rep(c("dentist","garage","hawaii","shopping","login"),3),
                cca=rep(0,15))
for (i in 1:15)
{
  ccas[i,]$cca<-getCCA(ccas[i,]$sentence, ccas[i,]$condition)
}

ccasVoiced<-data.frame(condition=c(rep("baseline",5),rep("herwin",5),rep("yu",5)), 
                       sentence=rep(c("dentist","garage","hawaii","shopping","login"),3),
                 cca=rep(0,15))
for (i in 1:15)
{
  ccasVoiced[i,]$cca<-getCCAVoiced(ccas[i,]$sentence, ccas[i,]$condition)
}
write.csv(ccas, file="cca_stimuli.csv")
write.csv(ccasVoiced, file="cca_voiced_stimuli.csv")

ccasVoiced$voiced<-rep("voiced",15)
ccas$voiced<-rep("all",15)
ccas<-rbind(ccas,ccasVoiced)

ccas$condition<-mapvalues(ccas$condition, from = c("baseline","herwin","yu"), to=c("mocap", "online", "offline"))
ccas$sentence<-mapvalues(ccas$sentence, from=c("dentist","garage","hawaii","login","shopping"), to=c("d","g","h","l","s"))
ccas$condition<-factor(ccas$condition, levels(ccas$condition)[c(1,3,2)])
theme_set(theme_gray(base_size = 22))

df<-ccas%>%group_by(condition,voiced)%>%summarize(mcca=mean(cca))
# print(
#   ggplot(ccas, aes(x=appointment,y=cca,colour=voiced))
#   +facet_grid(.~condition)
#   +geom_point(size=10)  
#   +geom_hline(data=df, aes(yintercept=mcca,colour=voiced))
#   +geom_hline(data=df, aes(yintercept=0.48))
#   +geom_hline(data=df, aes(yintercept=0.11))
# )

ccas<-dplyr::filter(ccas,voiced=="all")
df<-dplyr::filter(df,voiced=="all")
print(
  ggplot(ccas, aes(x=sentence,y=cca))
  +facet_grid(.~condition)
  +geom_point(size=4)  
  +geom_hline(data=df, aes(yintercept=mcca,colour="blue"))
  +geom_hline(data=df, aes(yintercept=0.48))
  +geom_hline(data=df, aes(yintercept=0.11))
)


