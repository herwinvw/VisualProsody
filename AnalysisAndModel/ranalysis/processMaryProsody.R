processMaryProsody<-function(filename){
  prosody<-read.csv(filename,colClasses=c("numeric","numeric","numeric"))
  return(prosody)
}