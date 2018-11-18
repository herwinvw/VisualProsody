#
# calculates cca information of all data
#
library(stringr)
source("ccassession.R")
source("ccasentenceTrimmed.R")
source("processFace.R")
improM<-list()
improF<-list()
scriptM<-list()
scriptF<-list()
for (i in 1:5){
  dir <- paste0("../corpus/IEMOCAP_full_release/Session",i,"/sentences/")
  improM[[i]] <- ccaSession(dir,"M","impro")
  improF[[i]] <- ccaSession(dir,"F","impro")
  scriptM[[i]] <- ccaSession(dir,"M","script")
  scriptF[[i]] <- ccaSession(dir,"F","script")
  write.table(improM[[i]], file=paste0("improMCCA",i,".csv"),sep=",")
  write.table(improF[[i]], file=paste0("improFCCA",i,".csv"),sep=",")
  write.table(scriptM[[i]], file=paste0("scriptMCCA",i,".csv"),sep=",")
  write.table(scriptF[[i]], file=paste0("scriptFCCA",i,".csv"),sep=",")
}