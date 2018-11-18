createPBTable <- function(name) 
{
  t<-readRDS(paste0(name,".rda"))
  features<-mapply(function(f0,rmsEnergy,m,P) new(visualprosody.Feature, f0=f0,rmsEnergy=rmsEnergy, m=m, P=P), 
                 t$f0, t$rmsEnergy, t$m, t$P)
  table<-new(visualprosody.Table, features=features)
  serialize(table, paste0(name,".pb"))
}

library(doParallel)
cl<-makeCluster(8,outfile="");
registerDoParallel(cl)
tablenames<-c("tableVoicedpitch","tableVoicedyaw","tableVoicedroll","tableVoicedv","tableVoiceda")
foreach (i=1:5) %dopar%
{
  library(RProtoBuf)
  readProtoFiles("table.proto")
  createPBTable(tablenames[i])
}