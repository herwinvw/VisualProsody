getFeatures<-function(dir, session, sentence){  
  print(sentence)
  hfile <- paste0(dir, "MOCAP_head/",session,"/",sentence,".txt")
  head<-processHead(hfile)
  pfile <- paste0(dir,"wav/",session,"/",sentence)
  prosodyAcf <- processProsody(paste0(pfile,".wavAcf.csv"))
  
  #sample_length<-0.25*length(head$yaw);#resample to 25 Hz
  
  #f0 <- resampleTo(prosodyAcf$F0_sma, sample_length)
  #rmsEnergy <- resampleTo(prosodyAcf$pcm_RMSenergy_sma, sample_length)
  sample_length<-length(head$pitch)
  f0 <- resampleTo(prosodyAcf$F0_sma, sample_length)
  rmsEnergy <- resampleTo(prosodyAcf$pcm_RMSenergy_sma, sample_length)
  
  #roll<-resampleTo(head$roll, sample_length)
  #pitch<-resampleTo(head$pitch, sample_length)
  #yaw<-resampleTo(head$yaw, sample_length)
  roll<-head$roll
  pitch<-head$pitch
  yaw<-head$yaw
  
  
  N<-length(pitch)
  
  v <- (pitch[3:N]-pitch[2:(N-1)])^2+
       (yaw[3:N]-yaw[2:(N-1)])^2+
       (roll[3:N]-roll[2:(N-1)])^2
  v <- sqrt(v)
  a <- (pitch[3:N]-2*pitch[2:(N-1)]+pitch[1:(N-2)])^2+
       (yaw[3:N]-2*yaw[2:(N-1)]+yaw[1:(N-2)])^2+
       (roll[3:N]-2*roll[2:(N-1)]+roll[1:(N-2)])^2
  a<-sqrt(a)
  
  features<-data.frame(rep(session,N-2),pitch[3:N],yaw[3:N],roll[3:N],v,a,f0[3:N],rmsEnergy[3:N])
  names(features)<-c("session", "pitch","yaw","roll","v","a","f0","RMSenergy")
  
  return(features)
}