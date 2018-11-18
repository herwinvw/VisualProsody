processPhonemes<-function(filename){
  f <- readLines(filename)
  rows=length(f)-1;
  elems<- array(dim=c(length(f)-1,4))
  i=1
  for(str in f[1:rows])
  {
    split<-str_split(str,"\\s+")
    split<-split[[1]][which(split[[1]]!="")]
    elem<-c(split[1:3],paste(split[4:length(split)],collapse=" "))
    elems[i,1:4]<-elem;
    i=i+1
  }  
  phonemes<-as.data.frame(elems[2:rows,1:4])
  names(phonemes)<-elems[1,1:4];
  phonemes$Phone<-as.character(phonemes$Phone)
  phonemes$SFrm<-as.numeric(as.character(phonemes$SFrm))
  phonemes$EFrm<-as.numeric(as.character(phonemes$EFrm))
  phonemes$SegAScr<-as.numeric(as.character(phonemes$SegAScr))
  return(phonemes)
}