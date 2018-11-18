#
# calculates cca information of all data for head/headv/heada vs f0 f0v f0a rmsEnergy rmsEnergyv rmsEnergya
#
library(stringr)
calculateCCA<-function(input1,input2,input3, v)
{
  print(str(input1))
  print(str(input2))
  print(str(input3))
  print(str(v))
  inputMatrix<-matrix(c(input1,input2,input3),ncol=3)
  print(str(inputMatrix))
  return (stats::cancor(inputMatrix,v)$cor)
}

calculateCCAS<-function(feature)
{
  df<-data.frame(ccaHeadF0=calculateCCA(feature$pitch,feature$yaw,feature$roll,feature$f0))
  df$ccaHeadRMSEnergy<-calculateCCA(feature$pitch,feature$yaw,feature$roll,feature$RMSEnergy)
  df$ccaHeadF0R<-calculateCCA(feature$pitch,feature$yaw,feature$roll,sample(feature$f0))
  df$ccaHeadRMSEnergyR<-calculateCCA(feature$pitch,feature$yaw,feature$roll,sample(feature$RMSEnergy))
  
  df$ccaVHeadF0<-calculateCCA(feature$vpitch,feature$vyaw,feature$vroll,feature$f0)
  df$ccaVHeadRMSEnergy<-calculateCCA(feature$vpitch,feature$vyaw,feature$vroll,feature$RMSEnergy)
  df$ccaVHeadF0R<-calculateCCA(feature$vpitch,feature$vyaw,feature$vroll,sample(feature$f0))
  df$ccaVHeadRMSEnergyR<-calculateCCA(feature$vpitch,feature$vyaw,feature$vroll,sample(feature$RMSEnergy))
  
  df$ccaVHeadVF0<-calculateCCA(feature$vpitch,feature$vyaw,feature$vroll,feature$vf0)
  df$ccaVHeadVRMSEnergy<-calculateCCA(feature$vpitch,feature$vyaw,feature$vroll,feature$vRMSEnergy)
  df$ccaVHeadVF0R<-calculateCCA(feature$vpitch,feature$vyaw,feature$vroll,sample(feature$vf0))
  df$ccaVHeadVRMSEnergyR<-calculateCCA(feature$vpitch,feature$vyaw,feature$vroll,sample(feature$vRMSEnergy))
  
  df$ccaAHeadF0<-calculateCCA(feature$apitch,feature$ayaw,feature$aroll,feature$f0)
  df$ccaAHeadRMSEnergy<-calculateCCA(feature$apitch,feature$ayaw,feature$aroll,feature$RMSenergy)
  df$ccaAHeadF0R<-calculateCCA(feature$apitch,feature$ayaw,feature$aroll,sample(feature$f0))
  df$ccaAHeadRMSEnergyR<-calculateCCA(feature$apitch,feature$ayaw,feature$aroll,sample(feature$RMSenergy))
  
  df$ccaAHeadAF0<-calculateCCA(feature$apitch,feature$ayaw,feature$aroll,feature$af0)
  df$ccaAHeadARMSEnergy<-calculateCCA(feature$apitch,feature$ayaw,feature$aroll,feature$aRMSEnergy)
  df$ccaAHeadAF0R<-calculateCCA(feature$apitch,feature$ayaw,feature$aroll,sample(feature$af0))
  df$ccaAHeadARMSEnergyR<-calculateCCA(feature$apitch,feature$ayaw,feature$aroll,sample(feature$aRMSEnergy))
  return(df)
}

improM<-list()
improF<-list()
scriptM<-list()
scriptF<-list()
for (i in 1:5){
  improM[[i]]<-calculateCCAS(improMFeaturesTrimmed[[i]])
  improF[[i]]<-calculateCCAS(improFFeaturesTrimmed[[i]])
  scriptM[[i]]<-calculateCCAS(scriptMFeaturesTrimmed[[i]])
  scriptF[[i]]<-calculateCCAS(scriptFFeaturesTrimmed[[i]])
  write.table(improM[[i]], file=paste0("improMCCAHead",i,".csv"),sep=",")
  write.table(improF[[i]], file=paste0("improFCCAHead",i,".csv"),sep=",")
  write.table(scriptM[[i]], file=paste0("scriptMCCAHead",i,".csv"),sep=",")
  write.table(scriptF[[i]], file=paste0("scriptFCCAHead",i,".csv"),sep=",")
}