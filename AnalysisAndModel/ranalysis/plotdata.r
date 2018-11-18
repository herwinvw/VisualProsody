histPlot<-function(x,y,...)
{
  df=data.frame(x,y)
  plot(df,...)
  h <- hexbin(df)
  plot(h, colramp=rf,...)  
}

gghistPlot<-function(f0,pitch,xlab,ylab)
{
  library(ggplot2)  
  library(hexbin)
  library(RColorBrewer)
  df<-data.frame(f0,pitch)
  rect <- data.frame (
    xmin=-10, xmax=20, ymin=-28, ymax=37)
  #rf <- colorRampPalette(rev(brewer.pal(11,'Spectral')))
  print(ggplot(df,aes(f0,pitch))
        +stat_binhex(bins=25)
        +scale_fill_gradientn(colours=rev(brewer.pal(11,'Spectral')))
        +geom_rect(data=rect, aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),color="red", alpha=0,size=2, inherit.aes = FALSE)
        )
}

theme_set(theme_gray(base_size = 22))
features<-read.csv("scriptFFeaturesTrimmed1.csv")
#features<-features[features$f0>=0,]
pitch<-features$pitch
#pitch<-features$v
#pitch<-features$a
f0<-features$f0
RMSenergy<-features$RMSenergy
gghistPlot(f0,pitch,xlab="f0",ylab="head pitch")
#gghistPlot(RMSenergy,pitch,xlab="RMS energy",ylab="head pitch")


# pitchVoiced<-pitch[f0>0]
# f0Voiced<-f0[f0>0]
# RMSenergyVoiced<-RMSenergy[f0>0]
# gghistPlot(f0Voiced,pitchVoiced,xlab="f0 voiced",ylab="head pitch voiced")
# gghistPlot(RMSenergyVoiced,pitchVoiced,xlab="RMS energy voiced",ylab="head velocity voiced")
# 
# RMSenergyUnvoiced<-RMSenergy[f0<=0]
# pitchUnvoiced<-pitch[f0<=0]
# gghistPlot(RMSenergyUnvoiced,pitchUnvoiced,xlab="RMS energy unvoiced",ylab="head velocity unvoiced")

