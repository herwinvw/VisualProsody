library(dplyr)
features<-readRDS("scriptFFeaturesTrimmed1.rda")
sentenceId<-"Ses01F_script01_3_F034"
selection<-features%>%filter(sentence==sentenceId)
rpySelection<-selection%>%select(one_of("roll","pitch","yaw","f0","RMSenergy"))
write.csv(rpySelection,file=paste0("synthesissamples/",sentenceId,".csv"),row.names=FALSE)

library(dplyr)
features<-readRDS("scriptFFeaturesTrimmed2.rda")
sentenceId<-"Ses02F_script01_3_F028"
selection<-features%>%filter(sentence==sentenceId)
rpySelection<-selection%>%select(one_of("roll","pitch","yaw","f0","RMSenergy"))
write.csv(rpySelection,file=paste0("synthesissamples/",sentenceId,".csv"),row.names=FALSE)