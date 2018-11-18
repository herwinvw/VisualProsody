createTimeSeriesDataFrame<-function(x,label,seriesLabel)
{
  df = data.frame(1:length(x),x,rep(label,length(x)))
  names(df)<-c("frame",seriesLabel,"label")
  return(df)
}

library(ggplot2)  
library(stringr)
source("getStartEndSilence.R")
source("processPhonemes.r")
dir<-"../corpus/IEMOCAP_full_release/Session1/sentences/"
sentenceId<-"Ses01F_script01_3_F034"
session<-"Ses01F_script01_3"
headData<-read.csv(paste0("synthesissamples/",sentenceId,".csv"))
headSession2Synth<-read.csv(paste0("synthesissamples/","Ses02F_script01_3_F028_head.csv"))
headDataSession2<-read.csv(paste0("synthesissamples/","Ses02F_script01_3_F028.csv"))

#headTTSHannah<-read.csv(paste0("synthesissamples/",sentenceId,"_hannah_head",".csv"))
headTTSHannah<-read.csv(paste0("synthesissamples/",sentenceId,"_hannah_head_BFGS",".csv"))
#headTTSPrudenceHSMM<-read.csv(paste0("synthesissamples/",sentenceId,"_dfki-prudence-hsmm_head",".csv"))
#headTTSPrudenceHSMM<-read.csv(paste0("synthesissamples/",sentenceId,"_dfki-prudence-hsmm_head_conjgradweka",".csv"))
headTTSPrudenceHSMM<-read.csv(paste0("synthesissamples/",sentenceId,"_dfki-prudence-hsmm_head_BFGS",".csv"))
#headTTSPrudenceHSMM<-read.csv(paste0("synthesissamples/",sentenceId,"_cmu-bdl-hsmm_head",".csv"))

headRealVoiceSynt<-read.csv(paste0("synthesissamples/",sentenceId,"_head",".csv"))
voicePrudence<-read.csv(paste0("synthesissamples/",sentenceId,"_dfki-prudence-hsmm.wavAcf",".csv"))
#voicePrudence<-read.csv(paste0("synthesissamples/",sentenceId,"_cmu-bdl-hsmm.wavAcf",".csv"))
voiceHannah<-read.csv(paste0("synthesissamples/",sentenceId,"_hannah.wavAcf",".csv"))

trim<-getStartEndSilence(dir, session, sentenceId)
trim <- (trim+2)/100
trim <-trim*120
headRealVoiceSynt<-headRealVoiceSynt[trim[1]:trim[2],]

trim<-getStartEndSilence("../corpus/IEMOCAP_full_release/Session2/sentences/", "Ses02F_script01_3", "Ses02F_script01_3_F028")
trim <- (trim+2)/100
trim <-trim*120
headSession2Synth<-headSession2Synth[trim[1]:trim[2],]

df<-createTimeSeriesDataFrame(headData$pitch,"Actor1 (mocap)","pitch")
df<-rbind(df,createTimeSeriesDataFrame(headDataSession2$pitch,"Actor2 (mocap)","pitch"))
df<-rbind(df,createTimeSeriesDataFrame(headRealVoiceSynt$pitch,"Actor1 (synthesized)","pitch"))
df<-rbind(df,createTimeSeriesDataFrame(headSession2Synth$pitch,"Actor2 (synthesized)","pitch"))
df<-rbind(df,createTimeSeriesDataFrame(headTTSHannah$pitch,"CereTTS Hannah","pitch"))
df<-rbind(df,createTimeSeriesDataFrame(headTTSPrudenceHSMM$pitch,"MaryTTS Prudence (HSMM)","pitch"))
print(
ggplot(df,aes(x=frame, y=pitch,col=label))
+geom_line()
)

df<-createTimeSeriesDataFrame(headData$yaw,"Actor1 (mocap)","yaw")
df<-rbind(df,createTimeSeriesDataFrame(headDataSession2$yaw,"Actor2 (mocap)","yaw"))
df<-rbind(df,createTimeSeriesDataFrame(headRealVoiceSynt$yaw,"Actor1 (synthesized)","yaw"))
df<-rbind(df,createTimeSeriesDataFrame(headSession2Synth$yaw,"Actor2 (synthesized)","yaw"))
df<-rbind(df,createTimeSeriesDataFrame(headTTSHannah$yaw,"CereTTS Hannah","yaw"))
df<-rbind(df,createTimeSeriesDataFrame(headTTSPrudenceHSMM$yaw,"MaryTTS Prudence (HSMM)","yaw"))
print(
  ggplot(df,aes(x=frame, y=yaw,col=label))
  +geom_line()
)

df<-createTimeSeriesDataFrame(headData$roll,"Actor1 (mocap)","roll")
df<-rbind(df,createTimeSeriesDataFrame(headDataSession2$roll,"Actor2 (mocap)","roll"))
df<-rbind(df,createTimeSeriesDataFrame(headRealVoiceSynt$roll,"Actor1 (synthesized)","roll"))
df<-rbind(df,createTimeSeriesDataFrame(headSession2Synth$roll,"Actor2 (synthesized)","roll"))
df<-rbind(df,createTimeSeriesDataFrame(headTTSHannah$roll,"CereTTS Hannah","roll"))
df<-rbind(df,createTimeSeriesDataFrame(headTTSPrudenceHSMM$roll,"MaryTTS Prudence (HSMM)","roll"))
print(
  ggplot(df,aes(x=frame, y=roll,col=label))
  +geom_line()
)

df<-createTimeSeriesDataFrame(headData$f0,"Actor","f0")
df<-rbind(df,createTimeSeriesDataFrame(headDataSession2$f0,"Actor 2","f0"))
df<-rbind(df,createTimeSeriesDataFrame(voiceHannah$F0_sma,"CereTTS Hannah","f0"))
df<-rbind(df,createTimeSeriesDataFrame(voicePrudence$F0_sma,"MaryTTS Prudence (HSMM)","f0"))
print(
   ggplot(df,aes(x=frame,y=f0))
   +facet_grid(label ~ .)
   +geom_line()
)

df<-createTimeSeriesDataFrame(headData$RMSenergy,"Actor","RMSEnergy")
df<-rbind(df,createTimeSeriesDataFrame(headDataSession2$RMSenergy,"Actor 2","RMSEnergy"))
df<-rbind(df,createTimeSeriesDataFrame(voiceHannah$pcm_RMSenergy_sma,"CereTTS Hannah","RMSEnergy"))
df<-rbind(df,createTimeSeriesDataFrame(voicePrudence$pcm_RMSenergy_sma,"MaryTTS Prudence (HSMM)","RMSEnergy"))
print(
  ggplot(df,aes(x=frame,y=RMSEnergy))
  +facet_grid(label ~ .)
  +geom_line()
)

headDataVoiced<-headData[headData$f0>0,]
voiceHannahVoiced<-voiceHannah[voiceHannah$F0_sma>0,]
voicePrudenceVoiced<-voicePrudence[voicePrudence$F0_sma>0,]
headDataSession2Voiced<-headDataSession2[headDataSession2$f0>0,]
print("---------f0 real data---------------",quote=FALSE)
print(summary(headDataVoiced$f0))
print("------------------------------------",quote=FALSE)
print("---------f0 real data actor2--------",quote=FALSE)
print(summary(headDataSession2Voiced$f0))
print("------------------------------------",quote=FALSE)
print("---------f0 ceretts Hannah-----------",quote=FALSE)
print(summary(voiceHannahVoiced$F0_sma))
print("------------------------------------",quote=FALSE)
print("---------f0 MaryTTS Prudense HSMM---",quote=FALSE)
print(summary(voicePrudenceVoiced$F0_sma))
print("------------------------------------",quote=FALSE)


print("---------RMS Energy real data---------------",quote=FALSE)
print(summary(headDataVoiced$RMSenergy))
print("------------------------------------",quote=FALSE)
print("---------RMS Energy real data actor 2-------",quote=FALSE)
print(summary(headDataSession2Voiced$RMSenergy))
print("------------------------------------",quote=FALSE)
print("---------RMS Energy ceretts Hannah-----------",quote=FALSE)
print(summary(voiceHannahVoiced$pcm_RMSenergy_sma))
print("------------------------------------",quote=FALSE)
print("---------RMS Energy MaryTTS Prudense HSMM---",quote=FALSE)
print(summary(voicePrudenceVoiced$pcm_RMSenergy_sma))
print("------------------------------------",quote=FALSE)

headRealVoiceSynt<-headRealVoiceSynt[headData$f0>0,]
headSession2Synth<-headSession2Synth[headDataSession2$f0>0,]
headTTSHannah<-headTTSHannah[voiceHannah$F0_sma>0,]
headTTSPrudenceHSMM<-headTTSPrudenceHSMM[voicePrudence$F0_sma>0,]

headMatrixData<-matrix(c(headDataVoiced$roll,headDataVoiced$pitch,headDataVoiced$yaw), ncol=3)
headMatrixDataSynth<-matrix(c(headRealVoiceSynt$roll,headRealVoiceSynt$pitch,headRealVoiceSynt$yaw), ncol=3)
headMatrixDataSession2<-matrix(c(headDataSession2Voiced$roll,headDataSession2Voiced$pitch,headDataSession2Voiced$yaw), ncol=3)
headMatrixDataSession2Synth<-matrix(c(headSession2Synth$roll,headSession2Synth$pitch,headSession2Synth$yaw), ncol=3)
headMatrixHannah<-matrix(c(headTTSHannah$roll,headTTSHannah$pitch,headTTSHannah$yaw), ncol=3)
headMatrixPrudence<-matrix(c(headTTSPrudenceHSMM$roll,headTTSPrudenceHSMM$pitch,headTTSPrudenceHSMM$yaw), ncol=3)
print(paste("cca head actor 1",stats::cancor(headMatrixData,headDataVoiced$f0)$cor))
print(paste("cca head actor 1 baseline",stats::cancor(headMatrixData,sample(headDataVoiced$f0))$cor))
print(paste("cca head actor 2",stats::cancor(headMatrixDataSession2,headDataSession2Voiced$f0)$cor))
print(paste("cca head actor 1 synthesized",stats::cancor(headMatrixDataSynth,headDataVoiced$f0)$cor))
print(paste("cca head actor 2 synthesized",stats::cancor(headMatrixDataSession2Synth,headDataSession2Voiced$f0)$cor))
print(paste("cca head CereTTS Hanna",stats::cancor(headMatrixHannah,voiceHannahVoiced$F0_sma)$cor))
print(paste("cca head MaryTTS Prudence HSMM",stats::cancor(headMatrixPrudence,voicePrudenceVoiced$F0_sma)$cor))
#print(paste("cca head MaryTTS Prudence HSMM baseline",stats::cancor(headMatrixPrudence,sample(voicePrudenceVoiced$F0_sma))$cor))