library(dplyr)
getWeekProbit <- function(equation,includeWeek1=FALSE)
{
    assign("weeksFrame",read.csv("NFL/Data/2015AllWeeks.csv"),envir = .GlobalEnv)
    if (!includeWeek1) weeksFrame <- weeksFrame[weeksFrame$Week>2,]
    weekXClean <- select(weeksFrame[!is.na(weeksFrame$Winner),],Winner:X14VTotal)
    #weekXClean <- select(weeksFrame[weeksFrame$Week==2,],Winner:X14VTotal)
    assign("probit", glm(equation, family=binomial(link="probit"),data=weekXClean),envir = .GlobalEnv)
    summary(probit)
}