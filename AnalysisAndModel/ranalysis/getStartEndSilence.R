getStartEndSilence<-function(dir, session, sentence){
  pfile <- paste0(dir, "ForcedAlignment/",session,"/",sentence,".phseg")
  phonemes<-processPhonemes(pfile)
  start <- 0
  N <- length(phonemes$EFrm)
  end <- phonemes$EFrm[N]
  
  i<-1
  while(length(grep(pattern="^SIL",phonemes$Phone[i]))==1 && (i<N))
  {
    start<-phonemes$EFrm[i]
    i<-i+1
  }
  
  i<-N
  while(length(grep(pattern="^SIL",phonemes$Phone[i]))==1 && (i>1))
  {
    end<-phonemes$SFrm[i]
    i<-i-1
  }
  return(c(start,end))
}  