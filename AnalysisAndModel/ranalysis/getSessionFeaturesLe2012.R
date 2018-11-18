getSessionFeaturesLe2012<-function(dir, gender, type){
    #("pitch","yaw","roll","v","a","f0","RMSenergy")
    features<-data.frame(session=character(),pitch=numeric(), yaw=numeric(), roll=numeric(), 
                            v=numeric(), a=numeric(),
                            f0=numeric(),RMSenergy=numeric(),loudness=numeric()
                            )
    
    sessions <- list.files(paste0(dir,"/MOCAP_head"),pattern=paste0("Ses.*",gender,"_",type,".*"))
    for (session in sessions){
      files<-list.files(paste0(dir,"MOCAP_head/",session),
                        pattern=paste0(".*",gender,"_.*_",gender,".*txt"))
      files<-gsub(".txt", "", files)  
      for (sentence in files){
        f<-getFeaturesLe2012(dir, session, sentence)
        features <- rbind(features,f)        
      }
    }
    
    return(features)
  }