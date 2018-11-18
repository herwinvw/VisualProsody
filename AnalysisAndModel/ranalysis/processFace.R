processFace<-function(filename){
  header<-read.csv(filename,header=TRUE,sep="",nrows=0,strip.white=TRUE)
  face<-read.csv(filename,header=FALSE,skip=2,sep="",strip.white=TRUE)
  #f <- readLines(filename)
  #names(face)<-unlist(strsplit(paste(f[1:2],collapse=" "),split=" "))
  head<-names(header)[1:2]
  for (h in names(header[3:length(header)])){
    head<-c(head, paste0(h,"x"),paste0(h,"y"),paste0(h,"z"))
  }
  names(face)<-head
  return(face)
}