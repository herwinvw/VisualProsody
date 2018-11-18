#test merged CCA of all actors and types vs cca in random condition
source("combinedata.r")
print("t-test cca head-F0")
print(t.test(combined$ccaHeadF0,combined$ccaHeadF0R))
print("------------------------------------------------")

print("t-test cca head-RMS energy")
print(t.test(combined$ccaHeadRMSEnergy,combined$ccaHeadRMSEnergyR))
print("------------------------------------------------")

print("t-test cca brows-f0 energy")
print(t.test(combined$ccaBrowsF0,combined$ccaBrowsF0R))
print("------------------------------------------------")

print("t-test cca brows-RMS energy")
print(t.test(combined$ccaBrowsRMSEnergy,combined$ccaBrowsRMSEnergyR))
print("------------------------------------------------")

boxplot(data.frame(combined$ccaHeadF0,combined$ccaHeadF0R),names=c("cca(f0,head) real","cca(f0,head) random"),col=c("green","red"))