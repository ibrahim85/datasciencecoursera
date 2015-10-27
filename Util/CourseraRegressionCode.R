library(manipulate)

myHist <- function(mu){
    mse <- mean((galton$child-mu)^2)
    g <- ggplot(galton, aes(x=child))+geom_histogram(fill="salmon",colour="black",binwidth=1)
    g <- g + geom_vline(xintercept=mu, size=3)
    g <- g + ggtitle(paste("mu = ",mu,", MSE= ",round(mse,2),sep=""))
    g
}

#manipulate(myHist(mu),mu=slider(62,74,step=0.5))

myPlot <- function(beta){
    y <- galton$child - mean(galton$child)
    x <- galton$parent - mean(galton$parent)
    freqData <- as.data.frame(table(x, y))
    names(freqData) <- c("child", "parent", "freq")
    freqData$child <- as.numeric(as.character(freqData$child))
    freqData$parent <- as.numeric(as.character(freqData$parent))
    
    g <- ggplot(filter(freqData, freq > 0), aes(x = parent, y = child))
    g <- g  + scale_size(range = c(2, 20), guide = "none" )
    g <- g + geom_point(colour="grey50", aes(size = freq+20, show_guide = FALSE))
    g <- g + geom_point(aes(colour=freq, size = freq))
    g <- g + scale_colour_gradient(low = "lightblue", high="white")                     
    g <- g + geom_abline(intercept = 0, slope = beta, size = 3)
    mse <- mean( (y - beta * x) ^2 )
    g <- g + ggtitle(paste("beta = ", beta, "mse = ", round(mse, 3)))
    g
}
#manipulate(myPlot(beta), beta = slider(0.6, 1.2, step = 0.02))

regress <- function(){
    x <- galton$parent
    y <- galton$child
    beta1 <- cor(x,y) * sd(y) / sd(x)
    beta0 <- mean(y) - beta1 * mean(x)
    rbind(c(beta0,beta1),coef(lm(y~x)))
}