processHead<-function(filename){
  head<-read.csv(file=filename,head=FALSE,sep="",strip.white=TRUE,skip=2,col.names=c("Frame", "Time", "pitch", "roll", "yaw", "tra_x", "tra_y", "tra_z"))
  return(head)                                                                                    
}