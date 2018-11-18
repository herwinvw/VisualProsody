#
#tests the cca of impro vs scripted
#
library(ggplot2)
source("combinedata.R")
test<-function(x,y,description)
{
  score = 0
  test<-t.test(x, y, alternative="less")
  print(description)
  if(test$p.value<0.05)
  {
    print(test)
    score = 1
  }
  else
  {
    print("no significant difference in means")
  }
  test<-t.test(x, y, alternative="greater")
  if(test$p.value<0.05)
  {
    print("--------------------------------------------------->impro has significantly higher cca")
  }
  return(score)
}

scoresM<-rep(0,5)
for (i in 1:5){
  scoresM[i]<-scoresM[i]+test(improM[[i]]$ccaHeadF0, scriptM[[i]]$ccaHeadF0,
    paste0("t-test improM",i," scriptM",i, " ccaHeadF0"))  
  scoresM[i]<-scoresM[i]+test(improM[[i]]$ccaHeadRMSEnergy, scriptM[[i]]$ccaHeadRMSEnergy,
       paste0("t-test improM",i," scriptM",i, " ccaHeadRMSEnergy"))  
  scoresM[i]<-scoresM[i]+test(improM[[i]]$ccaBrowsF0, scriptM[[i]]$ccaBrowsF0,
       paste0("t-test improM",i," scriptM",i, " ccaBrowsF0"))
  scoresM[i]<-scoresM[i]+test(improM[[i]]$ccaBrowsRMSEnergy, scriptM[[i]]$ccaBrowsRMSEnergy,
       paste0("t-test improM",i," scriptM",i, " ccaBrowsRMSEnergy"))
}

scoresF<-rep(0,5)
for (i in 1:5){
  scoresF[i]<-scoresF[i]+test(improF[[i]]$ccaHeadF0, scriptF[[i]]$ccaHeadF0,
       paste0("t-test improF",i," scriptF",i, " ccaHeadF0"))  
  scoresF[i]<-scoresF[i]+test(improF[[i]]$ccaHeadRMSEnergy, scriptF[[i]]$ccaHeadRMSEnergy,
       paste0("t-test improF",i," scriptF",i, " ccaHeadRMSEnergy"))  
  scoresF[i]<-scoresF[i]+test(improF[[i]]$ccaBrowsF0, scriptF[[i]]$ccaBrowsF0,
       paste0("t-test improF",i," scriptF",i, " ccaBrowsF0"))
  scoresF[i]<-scoresF[i]+test(improF[[i]]$ccaBrowsRMSEnergy, scriptF[[i]]$ccaBrowsRMSEnergy,
       paste0("t-test improF",i," scriptF",i, " ccaBrowsRMSEnergy"))
}
print("scores M:")
print(scoresM)
print("scores F:")
print(scoresF)

sig<-c()
for (i in 1:5){
  if(test(improM[[i]]$ccaHeadF0, scriptM[[i]]$ccaHeadF0,paste0("t-test improM",i," scriptM",i, " ccaHeadF0")))
  {
    sig<-c(sig,paste0("M",i))
  }
}

for (i in 1:5){
  if(test(improF[[i]]$ccaHeadF0, scriptF[[i]]$ccaHeadF0,paste0("t-test improF",i," scriptF",i, " ccaHeadF0")))
  {
    sig<-c(sig,paste0("F",i))
  }
}


print(ggplot(combined,aes(actorId,ccaHeadF0))+geom_boxplot(aes(fill = type))+annotate("text", label="*", size=12,x=sig,y=0))