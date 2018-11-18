tablePlot<-function(x,f0,pitch,P)
{
  library(ggplot2)  
  pitchLim<-range(0,x[,1])
  f0Lim<-range(0,x[,2])
  df<-data.frame(pitch,f0,P)
  df<-df%>%group_by(pitch,f0)%>%summarize(d=sum(P))
  print(ggplot(df,aes(f0,pitch,z=d))        
        +xlim(f0Lim)
        +ylim(pitchLim)
        +stat_contour(geom="polygon", aes(fill=..level..),bins=50))
}
histPlot<-function(f0,pitch,mux,muy, lambda)
{
  library(ggplot2)  
  df<-data.frame(f0,pitch)
  dfmu<-data.frame(mux,muy,lambda)
  print(ggplot(df,aes(f0,pitch))
        +stat_binhex(bins=50)
        +geom_point(data=dfmu,aes(mux,muy),color="red",size=lambda*100,shape=1))
}

histPlot2<-function(rmsEnergy,pitch,mux,muy, lambda)
{
  library(ggplot2)  
  df<-data.frame(rmsEnergy,pitch)
  dfmu<-data.frame(mux,muy,lambda)
  print(ggplot(df,aes(rmsEnergy,pitch))
        +stat_binhex(bins=50)
        +geom_point(data=dfmu,aes(mux,muy),color="red",size=lambda*100,shape=1))
}

modelplot<-function(x, mu,sigma,lambda,mux,muy)
{
  library(mixtools)
  library(dplyr)
  library(ggplot2)
  pitchLim<-range(0,x[,1])
  f0Lim<-range(0,x[,2])
  rmsEnergyLim<-range(0,x[,3])
  dfmu<-data.frame(mux,muy,lambda)
  
  N<-200
  pitchSeq<-seq(from=pitchLim[1],to=pitchLim[2], length.out=N)
  f0Seq<-seq(from=f0Lim[1],to=f0Lim[2], length.out=N)
  rmsSeq<-seq(from=rmsEnergyLim[1],to=rmsEnergyLim[2], length.out=N)
  samples<-expand.grid(pitch=pitchSeq, f0=f0Seq, rmsEnergy=rmsSeq)
  samples$pitch = as.numeric(samples$pitch)
  samples$f0 = as.numeric(samples$f0)
  samples$rmsEnergy = as.numeric(samples$rmsEnergy)
  sampleMatrix<-matrix(c(samples$pitch,samples$f0,samples$rmsEnergy),ncol=3)
  density<-rep(0,N^3)
  for (i in 1:length(lambda))
  {
    density<-density+lambda[[i]]*dmvnorm(sampleMatrix,mu=mu[[i]],sigma=sigma[[i]])
  }
  samples$density=density
  print(paste("minimum density:",min(density),"log:",log(min(density))))
  print(paste("maximum density:",max(density),"log:",log(max(density))))
  
  df<-samples%>%group_by(pitch,f0)%>%summarize(d=mean(density))
  print(ggplot(df,aes(f0,pitch,z=d))
        +xlim(f0Lim)
        +ylim(pitchLim)
        +stat_contour(geom="polygon", aes(fill=..level..),bins=50)
        +geom_point(data=dfmu,aes(mux,muy,z=NULL),color="red",size=lambda*100,shape=1))
  #print(ggplot(df,aes(f0,pitch))
  #      +geom_point(aes(colour=d),size=1.5,shape=15)
  #      +geom_point(data=dfmu,aes(mux,muy),color="red",size=lambda*100,shape=1))
}

modelplot2<-function(x, mu,sigma,lambda,mux,muy)
{
  library(mixtools)
  library(dplyr)
  library(ggplot2)  
  pitchLim<-range(0,x[,1])
  rmsEnergyLim<-range(0,x[,2])
  dfmu<-data.frame(mux,muy,lambda)
  
  N<-200
  pitchSeq<-seq(from=pitchLim[1],to=pitchLim[2], length.out=N)
  rmsSeq<-seq(from=rmsEnergyLim[1],to=rmsEnergyLim[2], length.out=N)
  
  samples<-expand.grid(pitch=pitchSeq, rmsEnergy=rmsSeq)
  samples$pitch = as.numeric(samples$pitch)
  samples$rmsEnergy = as.numeric(samples$rmsEnergy)
  sampleMatrix<-matrix(c(samples$pitch,samples$rmsEnergy),ncol=2)
  density<-rep(0,N^2)
  for (i in 1:length(lambda))
  {
    density<-density+lambda[[i]]*dmvnorm(sampleMatrix,mu=mu[[i]],sigma=sigma[[i]])
  }
  samples$density=density
  print(paste("minimum density:", min(density)))
  print(paste("maximum density:",max(density)))
  
  print(ggplot(samples,aes(rmsEnergy,pitch,z=density))
        +xlim(rmsEnergyLim)
        +ylim(pitchLim)
        +stat_contour(geom="polygon", aes(fill=..level..),bins=50)
        +geom_point(data=dfmu,aes(mux,muy,z=NULL),color="red",size=lambda*100,shape=1))
  print(ggplot(samples,aes(rmsEnergy,pitch))
        +geom_point(aes(colour=density),size=1.5,shape=15)
        +geom_point(data=dfmu,aes(mux,muy),color="red",size=lambda*100,shape=1))
}


plotgmmhist<-function(x,mu,sigma,lambda)
{
  mux<-c()
  muy<-c()
  for (i in 1:length(mu))
  {
    mux<-c(mux,mu[[i]][2])
    muy<-c(muy,mu[[i]][1])
  } 
  
  modelplot(x,mu,sigma,lambda,mux,muy)
  histPlot(x[,2],x[,1],mux,muy,lambda)    
}

plotgmmhist2<-function(x,mu,sigma,lambda)
{
  mux<-c()
  muy<-c()
  for (i in 1:length(mu))
  {
    mux<-c(mux,mu[[i]][2])
    muy<-c(muy,mu[[i]][1])
  } 
  
  modelplot2(x,mu,sigma,lambda,mux,muy)
  histPlot2(x[,2],x[,1],mux,muy,lambda)    
}

gmmVoicedYaw11<-readRDS("gmmVoicedpitch11.rda")
plotgmmhist(gmmVoicedYaw11$x,gmmVoicedYaw11$mu,gmmVoicedYaw11$sigma,gmmVoicedYaw11$lambda)
tableYaw<-readRDS("tableVoicedpitch.rda")
tablePlot(gmmVoicedYaw11$x,tableYaw$f0,tableYaw$m,tableYaw$P)

#gmmVoicedYaw11<-readRDS("gmmVoicedyaw11.rda")
#plotgmmhist(gmmVoicedYaw11$x,gmmVoicedYaw11$mu,gmmVoicedYaw11$sigma,gmmVoicedYaw11$lambda)
#tableYaw<-readRDS("tableVoicedyaw.rda")
#tablePlot(gmmVoicedYaw11$x,tableYaw$f0,tableYaw$m,tableYaw$P)

#gmmVoicedYaw11<-readRDS("gmmVoicedroll11.rda")
#plotgmmhist(gmmVoicedYaw11$x,gmmVoicedYaw11$mu,gmmVoicedYaw11$sigma,gmmVoicedYaw11$lambda)
#tableYaw<-readRDS("tableVoicedroll.rda")
#tablePlot(gmmVoicedYaw11$x,tableYaw$f0,tableYaw$m,tableYaw$P)

#gmmVoicedYaw11<-readRDS("gmmVoicedv11.rda")
#plotgmmhist(gmmVoicedYaw11$x,gmmVoicedYaw11$mu,gmmVoicedYaw11$sigma,gmmVoicedYaw11$lambda)
#tableYaw<-readRDS("tableVoicedv.rda")
#tablePlot(gmmVoicedYaw11$x,tableYaw$f0,tableYaw$m,tableYaw$P)

#gmmVoicedYaw11<-readRDS("gmmVoiceda11.rda")
#plotgmmhist(gmmVoicedYaw11$x,gmmVoicedYaw11$mu,gmmVoicedYaw11$sigma,gmmVoicedYaw11$lambda)
#tableYaw<-readRDS("tableVoiceda.rda")
#tablePlot(gmmVoicedYaw11$x,tableYaw$f0,tableYaw$m,tableYaw$P)


#gmmVoicedYaw11<-readRDS("gmmVoicedCVfiltered_A11.rda")
#plotgmmhist(gmmVoicedYaw11$x,gmmVoicedYaw11$mu,gmmVoicedYaw11$sigma,gmmVoicedYaw11$lambda)

#gmmVoicedYaw11<-readRDS("gmmVoicedpitch11.rda")
#plotgmmhist(gmmVoicedYaw11$x,gmmVoicedYaw11$mu,gmmVoicedYaw11$sigma,gmmVoicedYaw11$lambda)

#gmmUnVoicedYaw2<-readRDS("gmmUnVoiceda6.rda")
#plotgmmhist2(gmmUnVoicedYaw2$x,gmmUnVoicedYaw2$mu,gmmUnVoicedYaw2$sigma,gmmUnVoicedYaw2$lambda)