processWords<-function(filename){
  f <- readLines(filename)
  words<-read.csv(file=filename,head=TRUE,sep="",nrows=length(f)-2,strip.white=TRUE)
  words$SFrm<-(words$SFrm+2)/100
  words$EFrm<-(words$EFrm+2)/100
  return(words)
}