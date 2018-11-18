getFeaturesTrimmed<-function(dir, session, sentence){  
  library(signal)
  source("discreteSample.R")
  print(sentence)
  hfile <- paste0(dir, "MOCAP_head/",session,"/",sentence,".txt")
  head<-processHead(hfile)
  pfile <- paste0(dir,"wav/",session,"/",sentence)
  prosodyAcf <- processProsody(paste0(pfile,".wavAcf.csv"))
  
  roll<-head$roll
  pitch<-head$pitch
  yaw<-head$yaw
  
  sample_length<-length(pitch)
  #print(paste0("resample from",nrow(prosodyAcf), " to ",sample_length))
  f0 <- discreteSample(prosodyAcf$F0_sma, sample_length)
  rmsEnergy <- discreteSample(prosodyAcf$pcm_RMSenergy_sma, sample_length)
  #f0 <-prosodyAcf$F0_sma[1:sample_length] 
  #rmsEnergy <- prosodyAcf$pcm_RMSenergy_sma[1:sample_length]
  
  trim <- getStartEndSilence(dir,session,sentence)
  trim <- (trim+2)/100
  trimSelector<-(head$Time>trim[1]) & (head$Time<trim[2])
  roll<-roll[trimSelector]
  pitch<-pitch[trimSelector]
  yaw<-yaw[trimSelector]
  
  #low pass filter features
  #bf <- butter(2, 20/120, type="low")
  #pitch<-filtfilt(bf, pitch)
  #roll<-filtfilt(bf, roll)
  #yaw<-filtfilt(bf, yaw)
  
  f0<-f0[trimSelector]
  rmsEnergy<-rmsEnergy[trimSelector]
  
  N<-length(pitch)
  vpitch <- pitch[3:N]-pitch[2:(N-1)]
  vyaw <- yaw[3:N]-yaw[2:(N-1)]
  vroll <- roll[3:N]-roll[2:(N-1)]
  vf0 <- f0[3:N]-f0[2:(N-1)]
  vRMSEnergy <- rmsEnergy[3:N]-rmsEnergy[2:(N-1)]
  
  apitch <-pitch[3:N]-2*pitch[2:(N-1)]+pitch[1:(N-2)]
  ayaw <-yaw[3:N]-2*yaw[2:(N-1)]+yaw[1:(N-2)]
  aroll <-roll[3:N]-2*roll[2:(N-1)]+roll[1:(N-2)]
  af0 <-f0[3:N]-2*f0[2:(N-1)]+f0[1:(N-2)]
  aRMSEnergy <-rmsEnergy[3:N]-2*rmsEnergy[2:(N-1)]+rmsEnergy[1:(N-2)]
  
  v <- (pitch[3:N]-pitch[2:(N-1)])^2+
       (yaw[3:N]-yaw[2:(N-1)])^2+
       (roll[3:N]-roll[2:(N-1)])^2
  v <- sqrt(v)
  a <- (pitch[3:N]-2*pitch[2:(N-1)]+pitch[1:(N-2)])^2+
       (yaw[3:N]-2*yaw[2:(N-1)]+yaw[1:(N-2)])^2+
       (roll[3:N]-2*roll[2:(N-1)]+roll[1:(N-2)])^2
  a<-sqrt(a)
  features<-data.frame(rep(session,N-2),rep(sentence,N-2),pitch[3:N],yaw[3:N],roll[3:N],v,a,f0[3:N],rmsEnergy[3:N],
                       vpitch,vyaw,vroll,vf0,vRMSEnergy,
                       apitch,ayaw,aroll,af0,aRMSEnergy)
  names(features)<-c("session", "sentence","pitch","yaw","roll","v","a","f0","RMSenergy","vpitch","vyaw","vroll","vf0","vRMSEnergy",
                     "apitch","ayaw","aroll","af0","aRMSEnergy")
  
  return(features)
}