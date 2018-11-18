#
# Gathers per actor cca information
# No longer used??
#
actorsScript<-data.frame(Actor=character(), avgCCAHeadF0=numeric(), 
                        avgCCAHeadRMSEnergy=numeric(), 
                        avgCCABrowsF0=numeric(), 
                        avgCCABrowsRMSEnergy=numeric())
for (i in 1:5)
{
  f0Head<-mean(scriptM[[i]]$ccaHeadF0,na.rm=TRUE)
  rmsEnergyHead<-mean(scriptM[[i]]$ccaHeadRMSEnergy,na.rm=TRUE)
  f0Brows<-mean(scriptM[[i]]$ccaBrowsF0,na.rm=TRUE)
  rmsEnergyBrows<-mean(scriptM[[i]]$ccaBrowsRMSEnergy,na.rm=TRUE)
  name<-paste0("M",i)
  actorsScript<-rbind(actorsScript, data.frame(name, f0Head, rmsEnergyHead, f0Brows, rmsEnergyBrows))
}

for (i in 1:5)
{
  f0Head<-mean(scriptF[[i]]$ccaHeadF0,na.rm=TRUE)
  rmsEnergyHead<-mean(scriptF[[i]]$ccaHeadRMSEnergy,na.rm=TRUE)
  f0Brows<-mean(scriptF[[i]]$ccaBrowsF0,na.rm=TRUE)
  rmsEnergyBrows<-mean(scriptF[[i]]$ccaBrowsRMSEnergy,na.rm=TRUE)
  name<-paste0("F",i)
  actorsScript<-rbind(actorsScript, data.frame(name, f0Head, rmsEnergyHead, f0Brows, rmsEnergyBrows))
}


actorsImpro<-data.frame(Actor=character(), avgCCAHeadF0=numeric(), 
                         avgCCAHeadRMSEnergy=numeric(), 
                         avgCCABrowsF0=numeric(), 
                         avgCCABrowsRMSEnergy=numeric())
for (i in 1:5)
{
  f0Head<-mean(improM[[i]]$ccaHeadF0,na.rm=TRUE)
  rmsEnergyHead<-mean(improM[[i]]$ccaHeadRMSEnergy,na.rm=TRUE)
  f0Brows<-mean(improM[[i]]$ccaBrowsF0,na.rm=TRUE)
  rmsEnergyBrows<-mean(improM[[i]]$ccaBrowsRMSEnergy,na.rm=TRUE)
  name<-paste0("M",i)
  actorsImpro<-rbind(actorsImpro, data.frame(name, f0Head, rmsEnergyHead, f0Brows, rmsEnergyBrows))
}

for (i in 1:5)
{
  f0Head<-mean(improF[[i]]$ccaHeadF0,na.rm=TRUE)
  rmsEnergyHead<-mean(improF[[i]]$ccaHeadRMSEnergy,na.rm=TRUE)
  f0Brows<-mean(improF[[i]]$ccaBrowsF0,na.rm=TRUE)
  rmsEnergyBrows<-mean(improF[[i]]$ccaBrowsRMSEnergy,na.rm=TRUE)
  name<-paste0("F",i)
  actorsImpro<-rbind(actorsImpro, data.frame(name, f0Head, rmsEnergyHead, f0Brows, rmsEnergyBrows))
}