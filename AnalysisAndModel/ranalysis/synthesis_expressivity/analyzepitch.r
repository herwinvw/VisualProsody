library(ggplot2) 
library(dplyr)


addToDF<-function(df, dfAdd, rate)
{
  N <- nrow(dfAdd)
  v <-c(0, (dfAdd$pitch[2:N]-dfAdd$pitch[1:(N-1)])^2+
          (dfAdd$yaw[2:N]-dfAdd$yaw[1:(N-1)])^2+
          (dfAdd$roll[2:N]-dfAdd$roll[1:(N-1)])^2)
  dfNewRows <- data.frame(rate=rep(rate, nrow(dfAdd)), frame=1:nrow(dfAdd), dfAdd, v=v)
  return(rbind(df,dfNewRows))
}

xlowhead<-read.csv("synthesis_expressivity/hawaii_pitch_xlow_hannah_head.csv")
lowhead<-read.csv("synthesis_expressivity/hawaii_pitch_low_hannah_head.csv")
normalhead<-read.csv("synthesis_expressivity/hawaii_pitch_medium_hannah_head.csv")
highhead<-read.csv("synthesis_expressivity/hawaii_pitch_high_hannah_head.csv")
xhighhead<-read.csv("synthesis_expressivity/hawaii_pitch_xhigh_hannah_head.csv")

df<-data.frame(rate=character(), frame=numeric(), pitch=numeric(), yaw=numeric(), roll=numeric(),v=numeric)
df<-addToDF(df, xlowhead,"xlow")
df<-addToDF(df, lowhead,"low")
df<-addToDF(df, normalhead,"default")
df<-addToDF(df, highhead,"high")
df<-addToDF(df, xhighhead,"xhigh")

print(
  ggplot(df,aes(x=frame,y=pitch,color=rate))+geom_line()
)
print(
  ggplot(df,aes(x=frame,y=v,color=rate))+geom_line()
)
varextension <- df %>% group_by(rate) %>% summarize(var(pitch)+var(yaw)+var(roll))
varextensionpitch <- df %>% group_by(rate) %>% summarize(var(pitch))
meanvelocity <- df %>% group_by(rate) %>% summarize(mean(v))