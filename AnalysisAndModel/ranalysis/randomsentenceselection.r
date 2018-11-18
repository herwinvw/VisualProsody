library(dplyr)

features<-readRDS("scriptFFeaturesTrimmed1.rda")
features<-rbind(features,readRDS("scriptFFeaturesTrimmed2.rda"))
features<-rbind(features,readRDS("scriptFFeaturesTrimmed3.rda"))
features<-rbind(features,readRDS("scriptFFeaturesTrimmed4.rda"))
features<-rbind(features,readRDS("scriptFFeaturesTrimmed5.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed1.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed2.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed3.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed4.rda"))
features<-rbind(features,readRDS("scriptMFeaturesTrimmed5.rda"))
features<-rbind(features,readRDS("improFFeaturesTrimmed1.rda"))
features<-rbind(features,readRDS("improFFeaturesTrimmed2.rda"))
features<-rbind(features,readRDS("improFFeaturesTrimmed3.rda"))
features<-rbind(features,readRDS("improFFeaturesTrimmed4.rda"))
features<-rbind(features,readRDS("improFFeaturesTrimmed5.rda"))
features<-rbind(features,readRDS("improMFeaturesTrimmed1.rda"))
features<-rbind(features,readRDS("improMFeaturesTrimmed2.rda"))
features<-rbind(features,readRDS("improMFeaturesTrimmed3.rda"))
features<-rbind(features,readRDS("improMFeaturesTrimmed4.rda"))
features<-rbind(features,readRDS("improMFeaturesTrimmed5.rda"))

MEANMAXYAW <- 5
MEANMINYAW <- -5
MEANMAXPITCH <- 4
MEANMINPITCH <- -4
MEANMAXROLL <- 6
MEANMINROLL <- -6

MAXYAW <- 15
MINYAW <- -15
MAXPITCH <- 8
MINPITCH <- -8
MAXROLL <- 12
MINROLL <- -12

#MAXVEL<-100
#MAXACC<-100
MAXVEL <- 2
MAXACC <-0.5

duration <- 3.687;
features<-features[sample(nrow(features)),]
sentences<-features %>%
  group_by(sentence)%>%
  dplyr::filter(length(f0)>120*duration) %>%
  dplyr::filter(mean(yaw)<MEANMAXYAW)  %>%
  dplyr::filter(mean(yaw)>MEANMINYAW)  %>%
  dplyr::filter(mean(pitch)<MEANMAXPITCH)  %>%
  dplyr::filter(mean(pitch)>MEANMINPITCH)  %>%
  dplyr::filter(mean(roll)<MEANMAXROLL)  %>%
  dplyr::filter(mean(roll)>MEANMINROLL)  %>%
  dplyr::filter(max(yaw)<MAXYAW)  %>%
  dplyr::filter(min(yaw)>MINYAW)  %>%
  dplyr::filter(max(pitch)<MAXPITCH)  %>%
  dplyr::filter(min(pitch)>MINPITCH)  %>%
  dplyr::filter(max(roll)<MAXROLL)  %>%
  dplyr::filter(min(roll)>MINROLL)  %>%
  dplyr::filter(max(v)<MAXVEL)  %>%
  dplyr::filter(max(a)<MAXACC)  %>%
  select(sentence)
selected_sentences<-unique(sentences$sentence)
print(selected_sentences)