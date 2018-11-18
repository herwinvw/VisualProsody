getSessionFeaturesTrimmed<-function(dir, gender, type){
    features<-data.frame()
    
    sessions <- list.files(paste0(dir,"/MOCAP_head"),pattern=paste0("Ses.*",gender,"_",type,".*"))
    for (session in sessions){
      files<-list.files(paste0(dir,"MOCAP_head/",session),
                        pattern=paste0(".*",gender,"_.*_",gender,".*txt"))
      files<-gsub(".txt", "", files)  
      for (sentence in files){
        pfile <- paste0(dir, "ForcedAlignment/",session,"/",sentence,".phseg")
        if(file.exists(pfile))
        {
          f<-getFeaturesTrimmed(dir, session, sentence)
          features <- rbind(features,f)
        }
        else
        {
          warning(paste0("Missing forced alignment information file ",pfile))
        }
      }
    }
    
    return(features)
  }