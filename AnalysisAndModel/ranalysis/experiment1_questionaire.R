library(ggplot2)
library(plyr)
library(reshape2)
theme_set(theme_gray(base_size = 22))
exp<-read.csv("experiment/experiment1_results.csv",sep=";",dec = ",")
exp<-rename(exp,c("QUESTNNR"="Condition"))
exp$Condition <- revalue(exp$Condition, c("NM"="none", "BL"="mocap", "Yu"="offline", "Her"="online"))
exp$Condition = factor(exp$Condition, level=c("none", "mocap","offline","online"))
exp <- melt(exp, variable.name ="question", value.name="rating",
            measure.vars = c("Warmth","Competence","Humanlikeness"))
print(ggplot(exp, aes(x=Condition,y=rating))+
        theme(axis.text.x=element_text(angle=90))+
        facet_grid(. ~ question)+
        geom_boxplot()
)