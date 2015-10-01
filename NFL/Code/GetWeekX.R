library(dplyr)
getWeekProbit <- function(equation,weeks=seq(17),noNA=TRUE)
{
    assign("weeksFrame",read.csv("NFL/Data/2015AllWeeks.csv"),envir = .GlobalEnv)
    assign("weeksFrame",weeksFrame[weeksFrame$Week %in% weeks,],envir = .GlobalEnv)
    if (noNA) assign("weeksFrame",select(weeksFrame[!is.na(weeksFrame$Winner),],Winner:X14VTotal),envir = .GlobalEnv)
    assign("probit", glm(equation, family=binomial(link="probit"),data=weeksFrame),envir = .GlobalEnv)
    summary(probit)
}