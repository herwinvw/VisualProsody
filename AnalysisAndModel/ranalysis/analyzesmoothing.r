smooth<-read.csv("synthesissamples/hawaii_hannah_head_smooth.csv")
nosmooth<-read.csv("synthesissamples/hawaii_hannah_head_nosmooth.csv")
plot(smooth$pitch,type="l",col="red")
lines(nosmooth$pitch)