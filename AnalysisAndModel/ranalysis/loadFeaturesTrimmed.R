improMFeaturesTrimmed<-list()
improFFeaturesTrimmed<-list()
scriptMFeaturesTrimmed<-list()
scriptFFeaturesTrimmed<-list()
for (i in 1:5){
  dir <- paste0("../corpus/IEMOCAP_full_release/Session",i,"/sentences/")
  improMFeaturesTrimmed[[i]]<-read.table(file=paste0("improMFeaturesTrimmed",i,".csv"),sep=",",header=TRUE)
  improFFeaturesTrimmed[[i]]<-read.table(file=paste0("improFFeaturesTrimmed",i,".csv"),sep=",",header=TRUE)
  scriptMFeaturesTrimmed[[i]]<-read.table(file=paste0("scriptMFeaturesTrimmed",i,".csv"),sep=",",header=TRUE)
  scriptFFeaturesTrimmed[[i]]<-read.table(file=paste0("scriptFFeaturesTrimmed",i,".csv"),sep=",",header=TRUE)
}