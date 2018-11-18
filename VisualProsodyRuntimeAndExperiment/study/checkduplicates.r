exp1<-read.csv2("experiment1/comprehension_filtered_fromoo.csv")
exp2<-read.csv2("experiment2/experiment2_filter_testquestions.csv")
exp3<-read.csv2("experiment3/experiment3_uniqueranking.csv")
workers1<-as.character(exp1$IN01_01)
workers2<-as.character(exp2$IN01_01)
workers3<-as.character(exp3$IN01_01)
duplicatew3<-intersect(workers3,c(workers1,workers2))
duplicatew2<-intersect(workers2,workers1)

print(paste("Duplicate/total in experiment 2:", length(duplicatew2),"/", length(workers2)))
print(paste("Duplicate/total in experiment 3:", length(duplicatew3),"/",length(workers3)))

print("Duplicate workers in experiment 2:")
print(duplicatew2)

print("Duplicate workers in experiment 3:")
print(duplicatew3)