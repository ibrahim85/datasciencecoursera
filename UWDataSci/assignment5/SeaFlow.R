library(dplyr)
library(ggplot2)
library(party)
library(randomForest)
library(e1071)

quizAnswers <- function(){

    #ANSWER 1 - simply acknowledging instructions
    seaFlow <- read.csv("~/datasciencecoursera/UWDataSci/assignment5/seaflow_21min.csv")
    answers <- c("Yes")
    
    #ANSWER 2 - How many particles labeled "synecho" are in the file provided?
    synechoCount <- length(seaFlow$pop[seaFlow$pop=='synecho'])
    answers <- c(answers,synechoCount)
    
    #ANSWER 3 - What is the 3rd Quantile of the field fsc_small?
    thirdQuant <- quantile(seaFlow$fsc_small)["75%"]
    answers <- c(answers,thirdQuant)
    
    #ANSWER 4 - What is the mean of the variable "time" for your training set?
    seaTrainIndex <- createDataPartition(seaFlow$pop,list=FALSE)
    seaTrain <- seaFlow[seaTrainIndex[,1],]
    seaTest <- seaFlow[!(rownames(seaFlow) %in% seaTrainIndex[,1]),]
    meanTime <- mean(seaTrain$time)
    answers <- c(answers,meanTime)
    
    #ANSWER 5 - In the plot of pe vs. chl_small, the particles labeled ultra should appear
    #to be somewhat "mixed" with two other populations of particles. Which two populations?
    
    #Answer obtained visually
    qplot <- qplot(pe,chl_small,color=pop,data=seaFlow)
    answers <- c(answers,"Pico and Nano")
    
    #ANSWER 6 - Use print(model) to inspect your tree. Which populations, if any,
    #is your tree incapable of recognizing? 
    
    #ANSWER 7 - What is the value of the threshold on the pe field learned in your model?
    
    #ANSWER 8 - Based on your decision tree,
    #which variables appear to be most important in predicting the class population?
    
    #Answers obtained visually
    tree <- rpart(pop~fsc_small+fsc_perp+fsc_big+pe+chl_big+chl_small,data=seaTrain)
    #print(tree)
    
    answers <- c(answers,"Crypto")
    answers <- c(answers,5004)
    answers <- c(answers,"pe and chl_small")
    
    #ANSWER 9 - How accurate was your decision tree on the test data?
    
    #Find max value, and return name of particle
    projPop <- apply(predict(tree,newdata = seaTest),1,function(x){names(x)[which.max(x)]})
    seaTest <- mutate(seaTest,projPop=projPop)
    treeAccuracy <- length(seaTest$pop[seaTest$pop==seaTest$projPop])/length(seaTest$pop)
    answers <- c(answers,treeAccuracy)
    
    #ANSWER 10 - What was the accuracy of your random forest model on the test data?
    
    forest <- randomForest(pop~fsc_small+fsc_perp+fsc_big+pe+chl_big+chl_small,data=seaTrain)
    seaTest <- mutate(seaTest,forPop=predict(forest,newdata = seaTest))
    forestAccuracy <- length(seaTest$pop[seaTest$pop==seaTest$forPop])/length(seaTest$pop)
    answers <- c(answers,forestAccuracy)
    
    #ANSWER 11 - After calling importance(model), you should be able to determine
    #which variables appear to be most important in terms of the gini impurity measure.
    #Which ones are they?
    
    #Answers obtained visually
    import <- importance(forest)
    answers <- c(answers,"pe and chl_small")
    
    #ANSWER 12 - What was the accuracy of your support vector machine model on the test data?
    
    svm <- svm(pop~fsc_small+fsc_perp+fsc_big+pe+chl_big+chl_small,data=seaTrain)
    seaTest <- mutate(seaTest,svmPop=predict(svm,newdata = seaTest))
    svmAccuracy <- length(seaTest$pop[seaTest$pop==seaTest$svmPop])/length(seaTest$pop)
    answers <- c(answers,svmAccuracy)
    
    #ANSWER 13 - Construct a confusion matrix for each of the three methods using the table function. 
    #What appears to be the most common error the models make?
    
    treeTable <- table(pred = seaTest$projPop, true = seaTest$pop)
    forestTable <- table(pred = seaTest$forPop, true = seaTest$pop)
    svmTable <- table(pred = seaTest$svmPop, true = seaTest$pop)
    
    #Answers obtained visually
    answers <- c(answers,"ultra is mistaken for pico, pico is mistaken for ultra, ultra is mistaken for nano, and nano is mistaken for ultra")
    
    #ANSWER 14 - After removing data associated with file_id 208,
    #what was the effect on the accuracy of your svm model?
    
    newSeaTrain <- seaTrain[seaTrain$file_id!=208,]
    newSeaTest <- seaTest[seaTest$file_id!=208,]
    
    svm <- svm(pop~fsc_small+fsc_perp+fsc_big+pe+chl_big+chl_small,data=newSeaTrain)
    newSeaTest <- mutate(newSeaTest,svmPop=predict(svm,newdata = newSeaTest))
    newSvmAccuracy <- length(newSeaTest$pop[newSeaTest$pop==newSeaTest$svmPop])/length(newSeaTest$pop)
    answers <- c(answers,newSvmAccuracy-svmAccuracy)
    
    #ANSWER 15 - The variables in the dataset were assumed to be continuous,
    #but one of them takes on only a few discrete values, suggesting a problem. 
    #Which variable exhibits this problem?
    
    #Answer obtained visually
    #plot(seaTrain$fsc_big)
    
    answers <- c(answers,"fsc_big")
    
    answers
    
}