library(doParallel)
cl<-makeCluster(4,outfile="");
registerDoParallel(cl)

result<-foreach (k=2:11) %dopar%
{
  ptm<-proc.time()
  loglik<-k*2
  loglikcv<-k*3
  ptmdiff<-proc.time()-ptm
  
  df<-data.frame(k, loglik, loglikcv, ptmdiff[1], ptmdiff[2], ptmdiff[3])
  names(df)<-c("gaussians","loglik_training","loglik_cv","usertime","systemtime","elapsedtime")
  df
}
df<-do.call("rbind",result)
write.csv(df,file="cvinfotest.csv", row.names=FALSE)