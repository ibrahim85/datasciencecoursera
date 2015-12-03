#COURSERA PRACTICAL MACHINE LEARNING QUIZ 4

question1 <- function(){
    library(ElemStatLearn)
    require(caret)
    data(vowel.train)
    data(vowel.test)
    set.seed(33833)
    
    forest <- train(as.factor(y)~.,method="rf",data=vowel.train, trControl=trainControl(method="cv"),number=3)
    boost <- train(as.factor(y)~.,method="gbm",data=vowel.train,verbose=FALSE)
    pred1 <- predict(forest,vowel.test)
    pred2 <- predict(boost,vowel.test)
    qplot(pred1,pred2,color=y,data=vowel.test)
    
    predDF <- data.frame(pred1,pred2,y=vowel.test$y)
#     combModelFit <- train(as.factor(y)~.,method="gam",data=predDF)
#     combPred <- predict(combModelFit,predDF)
#     
#     sqrt(sum((pred1-vowel.test$y)^2))
#     sqrt(sum((pred2-vowel.test$y)^2))
#     sqrt(sum((combPred-vowel.test$y)^2))
    #accuracy on agreement
    confusionMatrix(predDF$pred2[predDF$pred1==predDF$pred2],predDF$y[predDF$pred1==predDF$pred2])
}

question2 <- function(){
    library(caret)
    library(gbm)
    set.seed(3433)
    library(AppliedPredictiveModeling)
    data(AlzheimerDisease)
    adData = data.frame(diagnosis,predictors)
    inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
    training = adData[ inTrain,]
    testing = adData[-inTrain,]
    set.seed(62433)
    
    #Train using random forest, boosting, and linear discriminant analysis
    forest <- train(diagnosis~.,method="rf",data=training)
    boost <- train(diagnosis~.,method="gbm",data=training,verbose=FALSE)
    linearD <- train(diagnosis~.,method="lda",data=training)
    pred1 <- predict(forest,testing)
    pred2 <- predict(boost,testing)
    pred3 <- predict(linearD,testing)
    
    #stack predictions and compare
    predDF <- data.frame(pred1,pred2,pred3,diagnosis=testing$diagnosis)
    combModelFit <- train(diagnosis~.,method="rf",data=predDF)
    combPred <- predict(combModelFit,predDF)
    predDF$comb <- combPred
    confusionMatrix(predDF$pred1,predDF$diagnosis)
    confusionMatrix(predDF$pred2,predDF$diagnosis)
    confusionMatrix(predDF$pred3,predDF$diagnosis)
    confusionMatrix(predDF$comb,predDF$diagnosis)
    
}

question3 <- function(){
    set.seed(3523)
    library(AppliedPredictiveModeling)
    data(concrete)
    inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
    training = concrete[ inTrain,]
    testing = concrete[-inTrain,]
    set.seed(233)
    
    lasso <- train(CompressiveStrength~.,method="lasso",data=training)
    plot(enet(as.matrix(concrete[,-9]),as.matrix(concrete[,9]),0))
    
}

question4 <- function(){
    library(lubridate)  # For year() function below
    library(forescast)
    dat = read.csv("~/datasciencecoursera/HW/gaData.csv")
    training = dat[year(dat$date) < 2012,]
    testing = dat[(year(dat$date)) > 2011,]
    
    series <- bats(tstrain)
    fore <- forecast(series,h=100)
    
}

question5 <- function(){
    require(e1071)
    set.seed(3523)
    library(AppliedPredictiveModeling)
    data(concrete)
    inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
    training = concrete[ inTrain,]
    testing = concrete[-inTrain,]
    set.seed(325)
    svm <- svm(CompressiveStrength~.,training)
    pred <- predict(svm,testing)
    RMSE <- sqrt(mean((testing$CompressiveStrength-pred)^2))
}