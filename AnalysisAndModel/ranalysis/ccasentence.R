ccaSentence<-function(dir, session, sentence){  
  print(sentence)
  hfile <- paste0(dir, "MOCAP_head/",session,"/",sentence,".txt")
  head<-processHead(hfile)
  headMatrix<-matrix(c(head$pitch,head$yaw,head$roll), ncol=3)

  face<-processFace(paste0(dir,"/MOCAP_rotated/",session,"/",sentence,".txt"))
  faceMatrix<-matrix(c(face$RBRO1x,face$RBRO1y,face$RBRO1z,
                     face$RBRO2x,face$RBRO2y,face$RBRO2z,
                     face$RBRO3x,face$RBRO3y,face$RBRO3z,
                     face$RBRO4x,face$RBRO4y,face$RBRO4z,
                     face$LBRO1x,face$LBRO1y,face$LBRO1z,
                     face$LBRO2x,face$LBRO2y,face$LBRO2z,
                     face$LBRO3x,face$LBRO3y,face$LBRO3z,
                     face$LBRO4x,face$LBRO4y,face$LBRO4z),ncol=8*3)

  pfile <- paste0(dir,"wav/",session,"/",sentence)
  prosodyAcf <- processProsody(paste0(pfile,".wavAcf.csv"))
  f0 <- resampleTo(prosodyAcf$F0_sma, length(head$yaw))
  rmsEnergy <- resampleTo(prosodyAcf$pcm_RMSenergy_sma, length(head$yaw))

  #only voiceless sound, skip
  if(identical(f0,rep(0,length(f0))))
  {
    return(data.frame(Sentence=character(), ccaHeadF0=numeric(), ccaHeadF0R=numeric(), 
                      ccaHeadRMSEnergy=numeric(), ccaHeadRMSEnergyR=numeric(),
                      ccaBrowsF0=numeric(),ccaBrowsF0R=numeric(), 
                      ccaBrowsRMSEnergy=numeric(),ccaBrowsRMSEnergyR=numeric()))
  }
  ccaHeadF0 <- stats::cancor(headMatrix,f0)$cor
  ccaHeadF0R <-stats::cancor(headMatrix,sample(f0))$cor
  ccaHeadRMSEnergy <- stats::cancor(headMatrix,rmsEnergy)$cor
  ccaHeadRMSEnergyR <- stats::cancor(headMatrix,sample(rmsEnergy))$cor
  
  completeFace <- complete.cases(faceMatrix)
  faceMatrix<-faceMatrix[completeFace, , drop=FALSE]
  if(nrow(faceMatrix)>0 && !identical(f0[completeFace],rep(0,length(f0[completeFace])))){
    ccaBrowsF0 <- stats::cancor(faceMatrix,f0[completeFace])$cor
    ccaBrowsF0R <- stats::cancor(faceMatrix,sample(f0[completeFace]))$cor    
    ccaBrowsRMSEnergy <- stats::cancor(faceMatrix,rmsEnergy[completeFace])$cor
    ccaBrowsRMSEnergyR <- stats::cancor(faceMatrix,sample(rmsEnergy[completeFace]))$cor
  }
  else{
    ccaBrowsF0<-NA
    ccaBrowsRMSEnergy<-NA
    ccaBrowsF0R<-NA
    ccaBrowsRMSEnergyR<-NA
  }
  
  df<-data.frame(sentence, ccaHeadF0, ccaHeadF0R, ccaHeadRMSEnergy, ccaHeadRMSEnergyR,
                 ccaBrowsF0,ccaBrowsF0R, ccaBrowsRMSEnergy, ccaBrowsRMSEnergyR)
  names(df)<-c("Sentence","ccaHeadF0", "ccaHeadF0R","ccaHeadRMSEnergy", "ccaHeadRMSEnergyR",
               "ccaBrowsF0", "ccaBrowsF0R", "ccaBrowsRMSEnergy", "ccaBrowsRMSEnergyR")
  return(df)
}