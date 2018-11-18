#calculates CCA values for a single session
ccaSession<-function(dir, gender, type){
  ccaCombined<-data.frame(Sentence=character(), ccaHeadF0=numeric(), ccaHeadF0R=numeric(), 
                       ccaHeadRMSEnergy=numeric(), ccaHeadRMSEnergyR=numeric(),
                       ccaBrowsF0=numeric(),ccaBrowsF0R=numeric(), 
                       ccaBrowsRMSEnergy=numeric(),ccaBrowsRMSEnergyR=numeric())
  
  sessions <- list.files(paste0(dir,"/MOCAP_head"),pattern=paste0("Ses.*",gender,"_",type,".*"))
  for (session in sessions){
    files<-list.files(paste0(dir,"MOCAP_head/",session),
                      pattern=paste0(".*",gender,"_.*_",gender,".*txt"))
    files<-gsub(".txt", "", files)  
    for (sentence in files){
      pfile <- paste0(dir, "ForcedAlignment/",session,"/",sentence,".phseg")
      if(file.exists(pfile))
      {
        cca<-ccaSentenceTrimmed(dir, session, sentence)
        ccaCombined <- rbind(ccaCombined,cca)  
      }
      else
      {
        warning(paste0("Missing forced alignment information file ",pfile))
      }
    }
  }
  
  return(ccaCombined)
}
  