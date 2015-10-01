library(dplyr)
getWeekLogit <- function(formula,weeks=seq(17),noNA=TRUE) {
    # Runs logit regression on NFL data and stores results to global variable logit
    #
    # Args:
    #   formula: See ?glm
    #   weeks: Vector of weeks to regress
    #   noNA: Logical TRUE to exclude rows with no winner yet, FALSE to include rows with no winner
    #
    # Returns:
    #   The summary of the logit regression
    assign("weeksFrame",read.csv("NFL/Data/2015AllWeeks.csv"),envir = .GlobalEnv)
    assign("weeksFrame",weeksFrame[weeksFrame$Week %in% weeks,],envir = .GlobalEnv)
    if (noNA) assign("weeksFrame",select(weeksFrame[!is.na(weeksFrame$Winner),],Winner:X14VTotal),envir = .GlobalEnv)
    assign("logit", glm(formula, family=binomial(link="logit"),data=weeksFrame),envir = .GlobalEnv)
    summary(logit)
}