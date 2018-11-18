getFeaturesLe2012<-function(dir, session, sentence){  
  print(sentence)
  hfile <- paste0(dir, "MOCAP_head/",session,"/",sentence,".txt")
  head<-processHead(hfile)
  
  pfile <- paste0(dir,"wav/",session,"/",sentence)
  prosodyAcf <- processProsody(paste0(pfile,".wavLe2012ReproductionAcf.csv"))
  
  sample_length<-length(prosodyAcf$F0_sma)#resample to 24 fps
  
  #print(paste0("resample to",sample_length))
  
  time<-resampleTo(head$Time,sample_length)
  roll<-resampleTo(head$roll,sample_length)
  pitch<-resampleTo(head$pitch,sample_length)
  yaw<-resampleTo(head$yaw,sample_length)
  f0 <- prosodyAcf$F0_sma
  rmsEnergy <- prosodyAcf$pcm_RMSenergy_sma
  loudness<-prosodyAcf$pcm_loudness_sma
    
  N<-length(pitch)
  
  if(N>3)
  {
    v <- (pitch[3:N]-pitch[2:(N-1)])^2+
         (yaw[3:N]-yaw[2:(N-1)])^2+
         (roll[3:N]-roll[2:(N-1)])^2
    v <- sqrt(v)
    a <- (pitch[3:N]-2*pitch[2:(N-1)]+pitch[1:(N-2)])^2+
         (yaw[3:N]-2*yaw[2:(N-1)]+yaw[1:(N-2)])^2+
         (roll[3:N]-2*roll[2:(N-1)]+roll[1:(N-2)])^2
    a<-sqrt(a)    
    features<-data.frame(rep(session,N-2),pitch[3:N],yaw[3:N],roll[3:N],v,a,f0[3:N],rmsEnergy[3:N], loudness[3:N])    
  }
  else
  {
    features<-data.frame(session=character(),pitch=numeric(), yaw=numeric(), roll=numeric(), 
                         v=numeric(), a=numeric(),
                         f0=numeric(),RMSenergy=numeric(),loudness=numeric()
    ) 
  }
  names(features)<-c("session", "pitch","yaw","roll","v","a","f0","RMSenergy","loudness")
  return(features)
}