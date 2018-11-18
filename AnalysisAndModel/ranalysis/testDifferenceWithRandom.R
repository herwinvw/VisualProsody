test<-function(x,y,description)
{
  test<-t.test(x, y, alternative="greater")
  print(description)
  if(test$p.value<1e-60)
  {
    print(paste0("significantly bigger than random t=",test$statistic, " p=",test$p.value))
  }
  else
  {
    print("------------------------------------------------------no significant difference in means")
  }
}

for (i in 1:5){
  test(improM[[i]]$ccaHeadF0, improM[[i]]$ccaHeadF0R,
       paste0("t-test improM",i," ccaHeadF0"))  
  test(improM[[i]]$ccaHeadRMSEnergy, improM[[i]]$ccaHeadRMSEnergyR,
       paste0("t-test improM",i, " ccaHeadRMSEnergy"))  
  test(improM[[i]]$ccaBrowsF0, improM[[i]]$ccaBrowsF0R,
       paste0("t-test improM",i, " ccaBrowsF0"))
  test(improM[[i]]$ccaBrowsRMSEnergy, improM[[i]]$ccaBrowsRMSEnergyR,
       paste0("t-test improM",i, " ccaBrowsRMSEnergy"))
}

for (i in 1:5){
  test(scriptM[[i]]$ccaHeadF0, scriptM[[i]]$ccaHeadF0R,
       paste0("t-test scriptM",i," ccaHeadF0"))  
  test(scriptM[[i]]$ccaHeadRMSEnergy, scriptM[[i]]$ccaHeadRMSEnergyR,
       paste0("t-test scriptM",i, " ccaHeadRMSEnergy"))  
  test(scriptM[[i]]$ccaBrowsF0, scriptM[[i]]$ccaBrowsF0R,
       paste0("t-test scriptM",i, " ccaBrowsF0"))
  test(scriptM[[i]]$ccaBrowsRMSEnergy, scriptM[[i]]$ccaBrowsRMSEnergyR,
       paste0("t-test scriptM",i, " ccaBrowsRMSEnergy"))
}

for (i in 1:5){
  test(improF[[i]]$ccaHeadF0, improF[[i]]$ccaHeadF0R,
       paste0("t-test improF",i," ccaHeadF0"))  
  test(improF[[i]]$ccaHeadRMSEnergy, improF[[i]]$ccaHeadRMSEnergyR,
       paste0("t-test improF",i, " ccaHeadRMSEnergy"))  
  test(improF[[i]]$ccaBrowsF0, improF[[i]]$ccaBrowsF0R,
       paste0("t-test improF",i, " ccaBrowsF0"))
  test(improF[[i]]$ccaBrowsRMSEnergy, improF[[i]]$ccaBrowsRMSEnergyR,
       paste0("t-test improF",i, " ccaBrowsRMSEnergy"))
}

for (i in 1:5){
  test(scriptF[[i]]$ccaHeadF0, scriptF[[i]]$ccaHeadF0R,
       paste0("t-test scriptF",i," ccaHeadF0"))  
  test(scriptF[[i]]$ccaHeadRMSEnergy, scriptF[[i]]$ccaHeadRMSEnergyR,
       paste0("t-test scriptF",i, " ccaHeadRMSEnergy"))  
  test(scriptF[[i]]$ccaBrowsF0, scriptF[[i]]$ccaBrowsF0R,
       paste0("t-test scriptF",i, " ccaBrowsF0"))
  test(scriptF[[i]]$ccaBrowsRMSEnergy, scriptF[[i]]$ccaBrowsRMSEnergyR,
       paste0("t-test scriptF",i, " ccaBrowsRMSEnergy"))
}
