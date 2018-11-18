# Analysis+visualization of one specific session
#
library(reshape2)
library(ggplot2)
dir <- "y:/IEMOCAP_full_release/Session5/sentences/"
session <- "Ses05M_impro01/Ses05M_impro01_M019"

pfile <- paste0(dir,"wav/",session)
prosodyAcf <- processProsody(paste0(pfile,".wavAcf.csv"))
prosodyShs <- processProsody(paste0(pfile,".wavShs.csv"))

hfile <- paste0(dir,"MOCAP_head/",session,".txt")
head<-processHead(hfile)
headMatrix<-matrix(c(head$pitch,head$yaw,head$roll), ncol=3)
f0 <- resampleTo(prosodyAcf$F0_sma, length(head$yaw))
rmsEnergy <- resampleTo(prosodyAcf$pcm_RMSenergy_sma, length(head$yaw))
intensity <- resampleTo(prosodyAcf$pcm_intensity_sma, length(head$yaw))
loudness <- resampleTo(prosodyAcf$pcm_loudness_sma, length(head$yaw))
prosodyMatrix <- matrix(c(f0,rmsEnergy),ncol=2)

print("CCA correlation head<->RMS energy+f0:",quote=FALSE)
print(cancor(prosodyMatrix,headMatrix)$cor)

print("CCA correlation head<->f0:",quote=FALSE)
print(cancor(headMatrix,f0)$cor)

print("CCA correlation head<->MS Energy:",quote=FALSE)

print(cancor(headMatrix,intensity)$cor)

print("CCA correlation head<->RMS Energy:",quote=FALSE)
print(cancor(headMatrix,rmsEnergy)$cor)

print("CCA correlation head<->loudness:",quote=FALSE)
print(cancor(headMatrix,loudness)$cor)

print("Correlation f0<->intensity:",quote=FALSE)
print(cor(prosodyAcf$F0_sma,y=prosodyAcf$pcm_intensity_sma))

print("Correlation f0<->loudness:",quote=FALSE)
print(cor(prosodyAcf$F0_sma,y=prosodyAcf$pcm_loudness_sma))

print("Correlation f0<->RMS Energy:",quote=FALSE)
print(cor(prosodyAcf$F0_sma,y=prosodyAcf$pcm_RMSenergy_sma))

printdf<-data.frame(head$Time, head$pitch, head$yaw, head$roll, f0, rmsEnergy,loudness)
names(printdf)<-c("Time","pitch","yaw","roll","f0","RMS energy", "loudness")
meltdf <- melt(printdf,id="Time")
ggplot(meltdf,aes(x=Time,y=value,colour=variable))+geom_line()+facet_wrap(~ variable, scales = 'free_y', ncol = 1)
