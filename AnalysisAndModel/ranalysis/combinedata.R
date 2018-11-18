#
# Puts all data loaded by calculateccas.r into a single combined frame
#
impro<-data.frame(Sentence=character(), ccaHeadF0=numeric(), ccaHeadF0R=numeric(), 
             ccaHeadRMSEnergy=numeric(), ccaHeadRMSEnergyR=numeric(),
             ccaBrowsF0=numeric(),ccaBrowsF0R=numeric(), 
             ccaBrowsRMSEnergy=numeric(),ccaBrowsRMSEnergyR=numeric())

combined<-data.frame(Sentence=character(), ccaHeadF0=numeric(), ccaHeadF0R=numeric(), 
                  ccaHeadRMSEnergy=numeric(), ccaHeadRMSEnergyR=numeric(),
                  ccaBrowsF0=numeric(),ccaBrowsF0R=numeric(), 
                  ccaBrowsRMSEnergy=numeric(),ccaBrowsRMSEnergyR=numeric())

for(i in 1:5)
{
  impro<-rbind(impro, improM[[i]])
  impro<-rbind(impro, improF[[i]])  
}

improId<-c()
for(i in 1:5)
{
  improId<-c(improId,rep(paste0("M",i),nrow(improM[[i]])))
  improId<-c(improId,rep(paste0("F",i),nrow(improF[[i]])))
}

impro<-cbind(improId,impro)

for(i in 1:5)
{
  combined<-rbind(combined,improM[[i]])  
  combined<-rbind(combined,improF[[i]])
  combined<-rbind(combined,scriptM[[i]])
  combined<-rbind(combined,scriptF[[i]])  
}

actorId<-c()
type<-c()
for(i in 1:5)
{
  actorId<-c(actorId,rep(paste0("M",i),nrow(improM[[i]])))
  actorId<-c(actorId,rep(paste0("F",i),nrow(improF[[i]])))
  actorId<-c(actorId,rep(paste0("M",i),nrow(scriptM[[i]])))
  actorId<-c(actorId,rep(paste0("F",i),nrow(scriptF[[i]])))
  type<-c(type,rep("impro", nrow(improM[[i]])+nrow(improF[[i]])))
  type<-c(type,rep("scripted", nrow(scriptM[[i]])+nrow(scriptF[[i]])))
}
combined<-cbind(type,combined)
combined<-cbind(actorId,combined)