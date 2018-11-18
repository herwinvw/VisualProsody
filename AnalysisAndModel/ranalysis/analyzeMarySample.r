source("processMaryProsody.r")
source("processProsody.r")
draw<-function(maryContour,smileContour,title)
{
  plot(maryContour$F0[1:1000],type="l",ylab="F0 (Hz)",xlab="Sample#",main=title)
  lines(smileContour$F0_sma[1:1000],type="l",col="red")
  #legend(x="center",legend=c("MaryTTS","OpenSMILE"),lty=c(1,1),lwd=c(2.5,2.5),
  #       col=c("black","red"),bty="n")
  
}
contour<-processMaryProsody("maryttssample/contour.csv")
prosody<-processProsody("maryttssample/welcome.wavAcf.csv")
contourHSMM<-processMaryProsody("maryttssample/contour_hsmm.csv")
prosodyHSMM<-processProsody("maryttssample/welcome_hsmm.wavAcf.csv")
draw(contour, prosody, "MaryTTS Unit selection (black) vs OpenSMILE f0(red)")
draw(contourHSMM, prosodyHSMM, "MaryTTS HSMM (black) vs OpenSMILE f0 (red)")