exp1<-read.csv("workers/experiment1_workers.csv")
exp2<-read.csv("workers/experiment2_workers.csv")
exp3<-read.csv("workers/experiment3_workers.csv")
exp1<-exp1[exp1$judgments_count>0,]
exp2<-exp2[exp2$judgments_count>0,]
exp3<-exp3[exp3$judgments_count>0,]

exp1so<-read.csv2("experiment1/exp1_finished.csv")
exp2so<-read.csv2("experiment2/exp2_finished.csv")
exp3so<-read.csv2("experiment3/exp3_finished.csv")

workers1<-exp1$worker_id
workers2<-exp2$worker_id
workers3<-exp3$worker_id
duplicatew3<-intersect(workers3,c(workers1,workers2))
duplicatew2<-intersect(workers2,workers1)

print(paste("Duplicate/total in experiment 2(raw):", length(duplicatew2),"/", length(workers2)))
print(paste("Duplicate/total in experiment 3(raw):", length(duplicatew3),"/",length(workers3)))

workers1so<-as.character(exp1so$IN01_01)
workers2so<-as.character(exp2so$IN01_01)
workers3so<-as.character(exp3so$IN01_01)
duplicatew3so<-intersect(workers3so,c(workers1so,workers2so))
duplicatew2so<-intersect(workers2so,workers1so)

print(paste("Duplicate/total in experiment 2(finished):", length(duplicatew2so),"/", length(workers2so)))
print(paste("Duplicate/total in experiment 3(finished):", length(duplicatew3so),"/",length(workers3so)))

#print("Duplicate workers in experiment 2(raw):")
#print(duplicatew2)

#print("Duplicate workers in experiment 3(raw):")
#print(duplicatew3)