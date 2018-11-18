library(ggplot2) 
library(dplyr)
library(TSA)
library(signal)

addToDF<-function(df, dfAdd, rate)
{
  N <- nrow(dfAdd)
  v <-c(0, (dfAdd$pitch[2:N]-dfAdd$pitch[1:(N-1)])^2+
    (dfAdd$yaw[2:N]-dfAdd$yaw[1:(N-1)])^2+
    (dfAdd$roll[2:N]-dfAdd$roll[1:(N-1)])^2)
  dfNewRows <- data.frame(rate=rep(rate, nrow(dfAdd)), frame=1:nrow(dfAdd), dfAdd, v=v)
  return(rbind(df,dfNewRows))
}

xslowhead<-read.csv("synthesis_expressivity/hawaii_xslow_hannah_head.csv")
slowhead<-read.csv("synthesis_expressivity/hawaii_slow_hannah_head.csv")
normalhead<-read.csv("synthesis_expressivity/hawaii_hannah_head.csv")
fasthead<-read.csv("synthesis_expressivity/hawaii_fast_hannah_head.csv")
xfasthead<-read.csv("synthesis_expressivity/hawaii_xfast_hannah_head.csv")

df<-data.frame(rate=character(), frame=numeric(), pitch=numeric(), yaw=numeric(), roll=numeric(),v=numeric)
df<-addToDF(df, xslowhead,"xslow")
df<-addToDF(df, slowhead,"slow")
df<-addToDF(df, normalhead,"default")
df<-addToDF(df, fasthead,"fast")
df<-addToDF(df, xfasthead,"xfast")

print(
  ggplot(df,aes(x=frame,y=pitch,color=rate))+geom_line()
)
print(
  ggplot(df,aes(x=frame,y=v,color=rate))+geom_line()
)
varextension <- df %>% group_by(rate) %>% summarize(var(pitch)+var(yaw)+var(roll))
varextensionpitch <- df %>% group_by(rate) %>% summarize(var(pitch))
meanvelocity <- df %>% group_by(rate) %>% summarize(mean(v))

#bf<-butter(3,10/120,type="low")
#pitch<-filtfilt(bf, xslowhead$pitch)

periodogram(xslowhead$pitch)
periodogram(slowhead$pitch)
periodogram(normalhead$pitch)
periodogram(fasthead$pitch)
periodogram(xfasthead$pitch)
#spectrum(xslowhead$pitch, f=120)
#spectrum(xfasthead$pitch, f=120)

#fftpitch <- df %>% group_by(rate) %>% summarize(Mod(fft(pitch))[2:length(pitch)/2])
plot(x=(1:39)/120, y=Mod(fft(xslowhead$pitch))[2:40],type='l')
plot(x=(1:39)/120, y=Mod(fft(slowhead$pitch))[2:40],type='l')
plot(x=(1:39)/120, y=Mod(fft(normalhead$pitch))[2:40],type='l')
plot(x=(1:39)/120, y=Mod(fft(fasthead$pitch))[2:40],type='l')
plot(x=(1:39)/120, y=Mod(fft(xfasthead$pitch))[2:40],type='l')
#plot(Mod(fft(2000+sin(1:1000)))[2:1000],type='l')