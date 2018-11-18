source("processMaryProsody.R")
source("processProsody.r")
draw<-function(inproContour,smileContour,title)
{
  plot(inproContour$F0,type="l",ylab="F0 (Hz)",xlab="Sample#",main=title)
  lines(smileContour$F0_sma,type="l",col="red")
  #legend(x="center",legend=c("MaryTTS","OpenSMILE"),lty=c(1,1),lwd=c(2.5,2.5),
  #       col=c("black","red"),bty="n")
  
}
contour<-processMaryProsody("inprosample/welcome_inpro.csv")
prosody<-processProsody("inprosample/welcome.wavAcf.csv")
#prosody<-processProsody("inprosample/welcome.wavAcf_maxpitch900.csv")
startIndex <-1
for (i in 1:nrow(prosody))
{
  if(prosody$F0_sma[i]>1)
  {
    startIndex<-i
    break
  }
}

endIndex <-1
for (i in nrow(prosody):1)
{
  if(prosody$F0_sma[i]>1)
  {
    endIndex<-i
    break
  }
}
startIndex<-startIndex
draw(contour, prosody[startIndex:endIndex,], "Inpro (black) vs OpenSMILE f0(red)")
