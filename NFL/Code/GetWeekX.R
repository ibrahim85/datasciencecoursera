library(dplyr)
library(combinat)

getNFLModel <- function(formula,weeks=seq(2,17),noNA=TRUE,family=gaussian) {
    # Runs regression on NFL data and stores results to global variable model
    #
    # Args:
    #   formula: See ?glm
    #   weeks: Vector of weeks to regress
    #   noNA: Logical TRUE to exclude rows with no winner yet, FALSE to include rows with no winner
    #   family: See ?glm
    #
    # Returns:
    #   The summary of the GLM regression
    assign("weeksFrame",read.csv("~/datasciencecoursera/NFL/Data/2015LastWeek.csv"),envir = .GlobalEnv)
    assign("weeksFrame",weeksFrame[weeksFrame$Week %in% weeks,],envir = .GlobalEnv)
    assign("weeksFrame",weeksFrame[,-c(1,2,3)],envir = .GlobalEnv)
    if (noNA) assign("weeksFrame",weeksFrame[!is.na(weeksFrame$Winner),],envir = .GlobalEnv)
    assign("model", glm(formula, family=family,data=weeksFrame),envir = .GlobalEnv)
    summary(model)
}

getModel <- function(frame,formula,family=gaussian){
    # Runs regression and stores results to global variable model
    #
    # Args:
    #   frame: Data frame to regress
    #   formula: See ?glm
    #   family: See ?glm
    #
    # Returns:
    #   The summary of the GLM regression
    frame <- frame[!is.na(frame$Winner),]
    assign("model", glm(formula, family=family,data=frame),envir = .GlobalEnv)
    summary(model)
}

cleanWeeks <- function(frame){
    cleanWeeks <- frame[,c(seq(11),24,25,26,29)]
    assign("cleanWeekFrame",cleanWeeks[,c(-1)],envir = .GlobalEnv)
}

sortModels <- function(frame,response,limit=Inf,family=gaussian){
    # Runs every possible regression on a data frame for a specified response variable.
    # Sorts results based on log likelihood.
    #
    # Args:
    #   frame: Data frame to regress
    #   response: Response variable to predict
    #   limit: Limit to number of predictors to use
    #   family: See ?glm
    #
    frame <- cleanWeeks(frame)
    names <- names(frame)
    predictorNames <- names(frame)[names(frame)!=response] #treat all columns as predictors except response
    numPredictors <- min(limit,length(predictorNames))
    if(sum(sapply(seq(numPredictors),function(x){choose(length(predictorNames),x)}))>10000) return("Too many combinations")
    comboList <- list()

    for(m in seq(numPredictors)){ #build list of possible formulae
        combos <- matrix(combn(predictorNames,m),nrow=m) #Produce all combinations of m predictors
        mPredictors <- apply(combos,2,function(combo){apply(matrix(combo),2,paste,collapse="+")}) #Collapse combinations to formula syntax (e.g. "X+Y+Z")
        for(formula in mPredictors){
            comboList <- c(comboList,formula)
        }
    }
    
    getLogLik <- function(x){ #returns log likelihood of model
        glm <- glm(paste(response,x,sep="~"),family=family,data=frame)
        logLik(glm)[1]
    }
    
    getGLMP <- function(x){ #returns mean p-value of coefficients
        glm <- glm(paste(response,x,sep="~"),family=family,data=frame)
        coef <- coef(summary(glm))
        meanPValue <- mean(coef[-1,"Pr(>|z|)"]) #exclude intercept
    }
    
    modelMatrix <- do.call("rbind",sapply(comboList,FUN=function(x){c(x,getLogLik(x))},simplify = FALSE))
    modelFrame <- as.data.frame(modelMatrix,stringsAsFactors=FALSE)
    names(modelFrame) <- c("Formula","LogLik")
    class(modelFrame$LogLik) <- "numeric"
    assign("modelFrame",arrange(modelFrame,desc(LogLik)),envir = .GlobalEnv) #return data frame sorted by log likelihood
}
