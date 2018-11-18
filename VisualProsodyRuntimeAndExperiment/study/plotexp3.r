library(ggplot2)
library(dplyr)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  require(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- plyr::rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}

exp3<-read.csv2("experiment3/experiment3_removedduplicates.csv")
df<-data.frame(
  rank = c(as.double(exp3$RD01),as.double(exp3$RS01),as.double(exp3$RG01),as.double(exp3$RH01),
           as.double(exp3$RD02),as.double(exp3$RS02),as.double(exp3$RG02),as.double(exp3$RH02),
           as.double(exp3$RD03),as.double(exp3$RS03),as.double(exp3$RG03),as.double(exp3$RH03),
           as.double(exp3$RD04),as.double(exp3$RS04),as.double(exp3$RG04),as.double(exp3$RH04)
           ),
  condition=c(rep("none",N*4),rep("mocap",N*4),rep("online",N*4),rep("offline",N*4)),
  sentence=rep(c(rep("d",N), rep("s",N), rep("g",N),rep("h",N)),4)
  )

#print(
#  ggplot(df, aes(condition,rank))+geom_boxplot()
#)
theme_set(theme_gray(base_size = 28))
df$condition<-factor(df$condition,levels=c("none","mocap","offline","online"))

dfs<-summarySE(df, measurevar="rank", groupvars=c("condition"))
print(
  ggplot(dfs, aes(x=condition,y=rank,fill=condition))+
           geom_bar(position=position_dodge(), stat="identity")+
          scale_fill_brewer(palette="Set1")+
          geom_errorbar(aes(ymin=rank-ci, ymax=rank+ci),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9))
          
          + guides(fill=FALSE)
  +coord_cartesian(ylim=1:4) 
)

df<-df%>%group_by(condition,sentence)%>%summarize(rank=mean(rank))
print(
  ggplot(df, aes(x=condition, y=rank, shape=sentence))+geom_point(size=8)+coord_cartesian(ylim=1:4) +scale_shape_manual(values=c(21:24))
)