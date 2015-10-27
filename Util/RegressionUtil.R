plotConfandPredict <- function(x,y,confLevel=.95,predictLevel=.95){
    # Plots the line of best fit along with confidence and prediction intervals for two variables.
    #
    # Args:
    #   x: The predictor variable
    #   y: The outcome variable
    #   confLevel: The level of confidence for the confidence interval
    #   predictLevel: The level of confidence for the prediction interval
    # Returns:
    #   Stores interval data as xyIntervals in the global environment
    fit <- lm(y~x)
    newx=data.frame(x=seq(min(x),max(x),length=100))
    pConf  <- data.frame(predict(fit,newdata=newx,interval=("confidence"),level=confLevel))
    pPredict  <- data.frame(predict(fit,newdata=newx,interval=("prediction"),level=predictLevel))
    pConf$interval <- "confidence"
    pPredict$interval <- "prediction"
    pConf$x <- newx$x
    pPredict$x <- newx$x
    data <- rbind(pConf,pPredict)
    assign("xyIntervals",data,envir = .GlobalEnv)
    names(data)[1]="y"
    gg <- ggplot(data,aes(x,y)) +
          geom_ribbon(aes(ymin=lwr,ymax=upr,fill=interval),alpha=.2) +
          geom_line() +
          geom_point(data=data.frame(x=x,y=y),aes(x,y))
    gg
}