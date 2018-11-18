# This script reads a CSV file in GNU R.
# While reading this file, comments will be created for all variables.
# The comments for values will be stored as attributes (attr) as well.

tmpImportFile <- file.choose()

data<-read.table(
  file=tmpImportFile, fileEncoding="UTF-8",
  header = FALSE, sep = "\t", quote = "\"",
  dec = ".", row.names = "CASE",
  col.names = c(
    "CASE","SERIAL","REF","QUESTNNR","MODE","STARTED","IN01_01","IN02_01","IN03",
    "IN04_01","QU01","QU02","QU03","QU04","QU05","QU06","QU07","QU08","RA01_01",
    "RA01_02","RA01_03","RA01_04","RA01_05","RA01_06","RA01_07","RA01_08","RA01_09",
    "RA01_10","RA01_11","RA01_12","RA01_13","RA01_14","RA01_15","RA01_16","RA01_17",
    "RA01_18","RA01_21","RA01_22","RA01_23","RA02_01","TIME001","TIME002","TIME003",
    "TIME004","TIME005","TIME006","TIME007","TIME008","TIME009","TIME010","TIME011",
    "TIME_SUM","MAILSENT","LASTDATA","FINISHED","LASTPAGE","MAXPAGE","MISSING",
    "MISSREL","DEG_MISS","DEG_TIME","DEGRADE"
  ),
  as.is = TRUE,
  colClasses = c(
    "integer","character","character","character","character","POSIXct","character",
    "character","factor","character","factor","factor","factor","factor","factor",
    "factor","factor","factor","integer","integer","integer","integer","integer",
    "integer","integer","integer","integer","integer","integer","integer","integer",
    "integer","integer","integer","integer","integer","integer","integer","integer",
    "character","integer","integer","integer","integer","integer","integer",
    "integer","integer","integer","integer","integer","integer","POSIXct","POSIXct",
    "logical","integer","integer","integer","integer","integer","integer","integer"
  ),
  skip = 1,
  check.names = TRUE, fill = TRUE,
  strip.white = FALSE, blank.lines.skip = TRUE,
  comment.char = "",
  na.strings = ""
)

rm(tmpImportFile)

attr(data, "project")<-"armandia"
attr(data, "description")<-"Armandia"
attr(data, "date")<-"2015-02-24 16:22:37"
attr(data, "server")<-"https://www.soscisurvey.de"

# Variable und Value Labels
data$IN03<-factor(data$IN03, levels=c("1","2"), labels=c("Female","Male"), ordered=FALSE)
data$QU01<-factor(data$QU01, levels=c("1","2"), labels=c("Yes","No"), ordered=FALSE)
data$QU02<-factor(data$QU02, levels=c("1","2"), labels=c("Yes","No"), ordered=FALSE)
data$QU03<-factor(data$QU03, levels=c("1","2"), labels=c("Train","Plane"), ordered=FALSE)
data$QU04<-factor(data$QU04, levels=c("1","2"), labels=c("Yes","No"), ordered=FALSE)
data$QU05<-factor(data$QU05, levels=c("1","2"), labels=c("Yes","No"), ordered=FALSE)
data$QU06<-factor(data$QU06, levels=c("1","2"), labels=c("Yes","No"), ordered=FALSE)
data$QU07<-factor(data$QU07, levels=c("1","2"), labels=c("Yes","No"), ordered=FALSE)
data$QU08<-factor(data$QU08, levels=c("1","2"), labels=c("Yes","No"), ordered=FALSE)
attr(data$RA01_01,"1")<-"not appropriate"
attr(data$RA01_01,"7")<-"very appropriate"
attr(data$RA01_02,"1")<-"not appropriate"
attr(data$RA01_02,"7")<-"very appropriate"
attr(data$RA01_03,"1")<-"not appropriate"
attr(data$RA01_03,"7")<-"very appropriate"
attr(data$RA01_04,"1")<-"not appropriate"
attr(data$RA01_04,"7")<-"very appropriate"
attr(data$RA01_05,"1")<-"not appropriate"
attr(data$RA01_05,"7")<-"very appropriate"
attr(data$RA01_06,"1")<-"not appropriate"
attr(data$RA01_06,"7")<-"very appropriate"
attr(data$RA01_07,"1")<-"not appropriate"
attr(data$RA01_07,"7")<-"very appropriate"
attr(data$RA01_08,"1")<-"not appropriate"
attr(data$RA01_08,"7")<-"very appropriate"
attr(data$RA01_09,"1")<-"not appropriate"
attr(data$RA01_09,"7")<-"very appropriate"
attr(data$RA01_10,"1")<-"not appropriate"
attr(data$RA01_10,"7")<-"very appropriate"
attr(data$RA01_11,"1")<-"not appropriate"
attr(data$RA01_11,"7")<-"very appropriate"
attr(data$RA01_12,"1")<-"not appropriate"
attr(data$RA01_12,"7")<-"very appropriate"
attr(data$RA01_13,"1")<-"not appropriate"
attr(data$RA01_13,"7")<-"very appropriate"
attr(data$RA01_14,"1")<-"not appropriate"
attr(data$RA01_14,"7")<-"very appropriate"
attr(data$RA01_15,"1")<-"not appropriate"
attr(data$RA01_15,"7")<-"very appropriate"
attr(data$RA01_16,"1")<-"not appropriate"
attr(data$RA01_16,"7")<-"very appropriate"
attr(data$RA01_17,"1")<-"not appropriate"
attr(data$RA01_17,"7")<-"very appropriate"
attr(data$RA01_18,"1")<-"not appropriate"
attr(data$RA01_18,"7")<-"very appropriate"
attr(data$RA01_21,"1")<-"not appropriate"
attr(data$RA01_21,"7")<-"very appropriate"
attr(data$RA01_22,"1")<-"not appropriate"
attr(data$RA01_22,"7")<-"very appropriate"
attr(data$RA01_23,"1")<-"not appropriate"
attr(data$RA01_23,"7")<-"very appropriate"
attr(data$FINISHED,"F")<-"Canceled"
attr(data$FINISHED,"F")<-"Finished"
comment(data$SERIAL)<-"Serial number (if provided)"
comment(data$REF)<-"Reference (if provided in link)"
comment(data$QUESTNNR)<-"Questionnaire that has been used in the interview"
comment(data$MODE)<-"Interview mode"
comment(data$STARTED)<-"Time the interview has started"
comment(data$IN01_01)<-"CF_ID: [01]"
comment(data$IN02_01)<-"age: [01]"
comment(data$IN03)<-"gender"
comment(data$IN04_01)<-"Intro: login code"
comment(data$QU01)<-"shopping"
comment(data$QU02)<-"shopping2"
comment(data$QU03)<-"hawaii"
comment(data$QU04)<-"hawaii2"
comment(data$QU05)<-"garage"
comment(data$QU06)<-"garage2"
comment(data$QU07)<-"dentist"
comment(data$QU08)<-"dentist2"
comment(data$RA01_01)<-"likert scale: pleasant"
comment(data$RA01_02)<-"likert scale: sensitive"
comment(data$RA01_03)<-"likert scale: friendly"
comment(data$RA01_04)<-"likert scale: likeable"
comment(data$RA01_05)<-"likert scale: affable"
comment(data$RA01_06)<-"likert scale: approachable"
comment(data$RA01_07)<-"likert scale: sociable"
comment(data$RA01_08)<-"likert scale: dedicated"
comment(data$RA01_09)<-"likert scale: trustworthy"
comment(data$RA01_10)<-"likert scale: thorough"
comment(data$RA01_11)<-"likert scale: helpful"
comment(data$RA01_12)<-"likert scale: intelligent"
comment(data$RA01_13)<-"likert scale: organized"
comment(data$RA01_14)<-"likert scale: expert"
comment(data$RA01_15)<-"likert scale: active"
comment(data$RA01_16)<-"likert scale: humanlike"
comment(data$RA01_17)<-"likert scale: fun-loving"
comment(data$RA01_18)<-"likert scale: lively"
comment(data$RA01_21)<-"likert scale: english-speaking"
comment(data$RA01_22)<-"likert scale: blond"
comment(data$RA01_23)<-"likert scale: dark-haired"
comment(data$RA02_01)<-"feedback: [01]"
comment(data$TIME001)<-"Time spent on page 1"
comment(data$TIME002)<-"Time spent on page 2"
comment(data$TIME003)<-"Time spent on page 3"
comment(data$TIME004)<-"Time spent on page 4"
comment(data$TIME005)<-"Time spent on page 5"
comment(data$TIME006)<-"Time spent on page 6"
comment(data$TIME007)<-"Time spent on page 7"
comment(data$TIME008)<-"Time spent on page 8"
comment(data$TIME009)<-"Time spent on page 9"
comment(data$TIME010)<-"Time spent on page 10"
comment(data$TIME011)<-"Time spent on page 11"
comment(data$TIME_SUM)<-"Time spent overall (except outliers)"
comment(data$MAILSENT)<-"Time when the invitation mailing was sent (non-anonymous recipients, only)"
comment(data$LASTDATA)<-"Time when the data was most recently updated"
comment(data$FINISHED)<-"Status (has the interview been finished?)"
comment(data$LASTPAGE)<-"Last page that the participant has handled in the questionnaire"
comment(data$MAXPAGE)<-"Hindmost page handled by the participant"
comment(data$MISSING)<-"Missing answers in percent"
comment(data$MISSREL)<-"Missing answers (weighted by relevance)"
comment(data$DEG_MISS)<-"Degradation points for missing answers"
comment(data$DEG_TIME)<-"Degradation points for being very fast"
comment(data$DEGRADE)<-"Degradation points overall"