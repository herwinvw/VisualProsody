library(reshape2)
library(ggplot2)
dir <- "y:/IEMOCAP_full_release/Session5/sentences/"
session <- "Ses05M_impro01/Ses05M_impro01_M019"

pfile <- paste0(dir,"wav/",session)
prosodyAcf <- processProsody(paste0(pfile,".wavAcf.csv"))
prosodyShs <- processProsody(paste0(pfile,".wavShs.csv"))

hfile <- paste0(dir,"MOCAP_head/",session,".txt")
head<-processHead(hfile)

face<-processFace(paste0(dir,"MOCAP_rotated/",session,".txt"))

headMatrix<-matrix(c(head$pitch,head$yaw,head$roll), ncol=3)
faceMatrix<-matrix(c(face$RBRO1x,face$RBRO1y,face$RBRO1z,
                     face$RBRO2x,face$RBRO2y,face$RBRO2z,
                     face$RBRO3x,face$RBRO3y,face$RBRO3z,
                     face$RBRO4x,face$RBRO4y,face$RBRO4z,
                     face$LBRO1x,face$LBRO1y,face$LBRO1z,
                     face$LBRO2x,face$LBRO2y,face$LBRO2z,
                     face$LBRO3x,face$LBRO3y,face$LBRO3z,
                     face$LBRO4x,face$LBRO4y,face$LBRO4z),ncol=8*3)
f0 <- resampleTo(prosodyAcf$F0_sma, length(head$yaw))
rmsEnergy <- resampleTo(prosodyAcf$pcm_RMSenergy_sma, length(head$yaw))
intensity <- resampleTo(prosodyAcf$pcm_intensity_sma, length(head$yaw))
loudness <- resampleTo(prosodyAcf$pcm_loudness_sma, length(head$yaw))
prosodyMatrix <- matrix(c(f0,rmsEnergy),ncol=2)
# doesn't do much
# l <- length(head$pitch)/6                 
# pitch20 <- resampleTo(head$pitch, l)
# yaw20 <- resampleTo(head$yaw,l)
# roll20 <- resampleTo(head$roll,l)
# f020 <- resampleTo(f0,l)
# head20Matrix <- matrix(c(roll20,pitch20,yaw20),ncol=3)
print("CCA correlation brows<->f0:",quote=FALSE)
print(cancor(f0,faceMatrix)$cor)

print("CCA correlation brows<->RMS Energy:",quote=FALSE)
print(cancor(rmsEnergy,faceMatrix)$cor)

print("CCA correlation head<->f0:",quote=FALSE)
print(cancor(headMatrix,f0)$cor)

print("CCA correlation head<->MS Energy:",quote=FALSE)
#intensity[intensity<0]<-0
#intensity <- sqrt (intensity)
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
