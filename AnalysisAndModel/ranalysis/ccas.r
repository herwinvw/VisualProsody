library(dplyr)
library(signal)
features<-readRDS("scriptFFeaturesTrimmed1.rda")
features<-features[features$f0>0,]
bf <- butter(2, 20/120, type="low")
b <- filtfilt(bf, features$pitch)

N<-200
plot(features$pitch[3:N],type="l")
lines(b[3:N],col="red")
plot(features$vpitch[3:N],type="l")
lines(b[3:N]-b[2:(N-1)],col="red")
plot(features$apitch[3:N],type="l")
lines(b[3:N]-2*b[2:(N-1)]+b[1:(N-2)],col="red")

N<-length(features$pitch)

pitch<-filtfilt(bf, features$pitch)
roll<-filtfilt(bf, features$roll)
yaw<-filtfilt(bf, features$yaw)
#pitch<-features$pitch
#yaw<-features$yaw
#roll<-features$roll

apitch<-pitch[3:N]-2*pitch[2:(N-1)]+pitch[1:(N-2)]
ayaw<-yaw[3:N]-2*yaw[2:(N-1)]+yaw[1:(N-2)]
aroll<-roll[3:N]-2*roll[2:(N-1)]+roll[1:(N-2)]
a<-sqrt(apitch*apitch+ayaw*ayaw+aroll*aroll)
vpitch<-pitch[3:N]-pitch[2:(N-1)]
vyaw<-yaw[3:N]-yaw[2:(N-1)]
vroll<-roll[3:N]-roll[2:(N-1)]
v<-sqrt(vpitch*vpitch+vyaw*vyaw+vroll*vroll)
pitch<-pitch[3:N]
yaw<-yaw[3:N]
roll<-roll[3:N]
f0<-features$f0[3:N]
vf0<-features$vf0[3:N]
af0<-features$af0[3:N]
# bf <- butter(2, 1/6, type="low")
# b <- filtfilt(bf, features$f0)
# plot(features$f0[3:N],type="l")
# lines(b[3:N],col="red")
# plot(features$vf0[3:N],type="l")
# lines(b[3:N]-b[2:(N-1)],col="red")
# plot(features$af0[3:N],type="l")
# lines(b[3:N]-2*b[2:(N-1)]+b[1:(N-2)],col="red")

headMatrix<-matrix(c(pitch,yaw,roll), ncol=3)
ccaHead<-stats::cancor(headMatrix,f0)$cor
ccaHeadR<-stats::cancor(headMatrix,sample(f0))$cor
print(paste("cca head f0", ccaHead))
print(paste("cca head random f0", ccaHeadR))
ccf(pitch,f0)
ccf(sqrt(pitch*pitch+yaw*yaw+roll*roll),f0)

sentence1<-dplyr::filter(features, sentence=="Ses01F_script01_3_F034")
headMatrix<-matrix(c(sentence1$pitch,sentence1$yaw,sentence1$roll), ncol=3)
print(paste("CCA of Ses01F_script01_3_F034",stats::cancor(headMatrix,sentence1$f0)$cor))

time<-1/120*length(sentence1$pitch)
fft1<-fft(sentence1$pitch)
fft2<-fft(sentence1$f0)
magn1 <- Mod(fft1) 
magn2 <- Mod(fft2) 
magn1.1 <- magn1[2:(length(magn1)/20)-1]
magn2.1 <- magn2[2:(length(magn2)/20)-1]
x.axis <- 1:length(magn1.1)/time
plot(x=x.axis,y=magn2.1,type="l",col="red")
lines(x=x.axis,y=magn1.1,type="l")

# features2<-readRDS("scriptFFeaturesTrimmed2.rda")
# features2<-features2[features2$f0>0,]
# sentence2<-dplyr::filter(features2, sentence=="Ses02F_script01_3_F028")
# headMatrix<-matrix(c(sentence2$pitch,sentence2$yaw,sentence2$roll), ncol=3)
# print(paste("CCA of Ses02F_script01_3_F028",stats::cancor(headMatrix,sentence2$f0)$cor))
# 
# X<-19;
# f0test<-sentence1$f0[(X+1):(nrow(headMatrix)+X)]
# print(paste("CCA of Ses02F_script01_3_F028 head on Ses01F_script01_3_F034 f0",stats::cancor(headMatrix,f0test)$cor))

features2<-readRDS("scriptMFeaturesTrimmed5.rda")
features2<-features2[features2$f0>0,]
sentence2<-dplyr::filter(features2, sentence=="Ses05M_script01_1_M028")
headMatrix<-matrix(c(sentence2$pitch,sentence2$yaw,sentence2$roll), ncol=3)
print(paste("CCA of Ses05M_script01_1_M028",stats::cancor(headMatrix,sentence2$f0)$cor))

X<-1;
f0test<-sentence1$f0[(X+1):(nrow(headMatrix)+X)]
print(paste("CCA of Ses02F_script01_3_F028 head on Ses05M_script01_1_M028 f0",stats::cancor(headMatrix,f0test)$cor))

#print(paste("cca head f0, local mean", mean(ccaLocal$ccaSentence)))

headMatrix<-matrix(c(vpitch,vyaw,vroll), ncol=3)
ccaHead<-stats::cancor(headMatrix,f0)$cor
ccaHeadR<-stats::cancor(headMatrix,sample(f0))$cor
print(paste("cca vhead f0", ccaHead))
print(paste("cca vhead random f0", ccaHeadR))
ccf(vpitch,f0)
ccf(v,f0)

headMatrix<-matrix(c(vpitch,vyaw,vroll), ncol=3)
ccaHead<-stats::cancor(headMatrix,vf0)$cor
ccaHeadR<-stats::cancor(headMatrix,sample(vf0))$cor
print(paste("cca vhead vf0", ccaHead))
print(paste("cca vhead random vf0", ccaHeadR))
ccf(vpitch,vf0)
ccf(v,vf0)

ccf(a,af0)
ccf(a,vf0)
ccf(a,f0)

ccf(v,af0)
ccf(pitch,af0)