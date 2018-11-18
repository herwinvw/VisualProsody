processSyllables<-function(filename){
  syllables<-read.csv(file=filename,head=TRUE,sep="",strip.white=TRUE)
  #transform timing to seconds, taking into account the 20ms reported delay
  syllables$SFrm<-(syllables$SFrm+2)/100
  syllables$EFrm<-(syllables$EFrm+2)/100
  return(syllables)
}