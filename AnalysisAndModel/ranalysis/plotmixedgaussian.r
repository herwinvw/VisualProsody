y<-rnorm(5000,mean=-5,sd=0.1)+rnorm(5000,mean=5,sd=0.1)
hist(y)
x<- -10:10
y<-0.5*dnorm(x,mean=-5,sd=2)+0.5*dnorm(x,mean=5,sd=2)
plot(x,y)