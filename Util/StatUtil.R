#
#CALCUATIONS
#

getBinomErrorProbs <- function(success,trials,p1,p0=.5,alpha=.05, alternative = c("two.sided")) {
    # Computes Type I and II error probabilities
    # for a binomial test with the given success and failure rate
    #
    # Args:
    #   success: Number of successful trials
    #   trials: Total number of trials
    #   p1: Probability to be assumed in H1 (alternative hypothesis)
    #   p0: Probability to be assumed in H0 (null hypothesis)
    #   alpha: Alpha value (Type I threshold) to be used in calculation of beta
    #   alternative: See ?binom.test
    #
    # Returns:
    #   Vector with Type I error first and Type II error second
    error1 <- binom.test(success,trials,p0,alternative)$p.value
    power <- getBinomPower(p1,trials,alpha,p0)
    error2 <- 1-unname(power[,"power"]) #unname to remove "power" from return value
    c(Type1=error1,Type2=error2)
}

minBinomSuccessAndSample <- function(alpha=.05, power=.8, p0=.5, p1=.6, two.sided=TRUE) {
    # Computes the minimum requisite sample size and succes rate
    # for a binomial test to have acceptable Type I and II error probabilities
    #
    # Args:
    #   alpha:  Type I error threshold
    #   power:  1 - Type II error threshold
    #   p0: Probability to be assumed in H0 (null hypothesis)
    #   p1: Probability to be assumed in H1 (alternative hypothesis)
    #   two.sided: Logical TRUE if two-sided test, FALSE if one-sided
    #
    # Returns:
    #   Vector with number of successes first and number of trials second
    sides <- 1+two.sided #2 if TRUE, 1 if FALSE
    trials <- nForBinomPow(power,p1,alpha=alpha,p0=p0)
    success <- qbinom(1-alpha/sides,trials,p0)
    c(Success=success,Trials=trials)
}

nForBinomPow <- function(power,p1,...) {
    # Finds the minimum sample size needed to achieve a given power in a binomial test.
    #
    # Args:
    #   power:  The desired power (1 - Type II error probability)
    #   p1: Probability to be assumed in H1 (alternative hypothesis)
    #   ...:    See getBinomPower documentation
    # Returns:
    #   Minimum sample size needed to achieve a given power in a binomial test.
    #   Returns -1 if sampleRange (see getBinomPower) is not large enough to achieve power.
    results <- getBinomPower(p1,...)
    overPow <- results[results[,"power"]>=power,c("n","power")]
    if(nrow(overPow)==0) return(-1)
    index <- which.min(overPow[,"n"])
    overPow[index,"n"]
}

getBinomPower <- function(p1,sampleRange=10:1000,alpha=.05,p0=.5) {
    # Computes the power of a binomial test over a range of sample sizes
    #
    # Args:
    #   p1: Probability to be assumed in H1 (alternative hypothesis)
    #   sampleRange: Vector of N samples sizes
    #   alpha: Alpha value (Type I error probabilty) 
    #   p0: Probability to be assumed in H0 (null hypothesis)
    #
    # Returns:
    #   Matrix of N rows with sample size in column 1 and power in column 2
    thresholds <- qbinom(1-alpha,sampleRange,p0)
    power <- 1-pbinom(thresholds-1,sampleRange,p1)
    cbind(n=sampleRange,power=power)
}

getHarmonicMean <- function(x){
    # Computes the harmonic mean of a numeric vector
    #
    # Args:
    #   x: Numeric vector
    1/mean(1/x)
}

getGeometricMean <- function(x){
    # Computes the geometric mean of a numeric vector
    #
    # Args:
    #   x: Numeric vector
    prod(x)^(1/length(x))
}

#
#PLOTS
#

plotBinomPower <- function(p1,...) {
    # Plots the power of a binomial test as a function of the sample size.
    #
    # Args:
    #   p1: Probability to be assumed in H1 (alternative hypothesis)
    #   ...: See getBinomPower documentation
    results <- getBinomPower(p1,...)
    plot(results[,"n"],results[,"power"],xlab="N",ylab="Power")
}

plotBinomSampleByProb <- function(power=.8,probs=seq(.52,.65,.01),threshold=NULL,...) {
    # Plots the minimum sample size needed for a binomial test to achieve a given power
    # as a function of the probability to be assumed in H1 (alternative hypothesis)
    #
    # Args:
    #   power: The desired power (1 - Type II error probability)
    #   probs: Vector of probabilities to assume in H1
    #   threshold: List with $p and $n components specifying
    #              vertical and horizontal lines to draw on plot
    #   ...: See getBinomPower. Note - first parameter (p1) specified (as x) outside of ...
    # 
    # Be aware nForBinomPow will return -1 if sampleRange is not sufficiently large for desired power
    plot(probs,sapply(probs,function(x) nForBinomPow(power,x,...)),xlab="P",ylab="N")
    if(!is.null(threshold$p)) abline(v=threshold$p)
    if(!is.null(threshold$n)) abline(h=threshold$n)
}

plotNormPowerBySample <- function(mean0=0,mean1=1,sd=1,alpha=.05,range=1:100){
    quant <- qnorm(1-alpha,mean0,sd/sqrt(range))
    power <- 1 - pnorm(quant,mean1,sd/sqrt(range))
    plot(range,power)
}

principalComp <- function(frame){
    #Performs PCA on a clean data frame and returns the confusion matrix
    testIndex <- createDataPartition(frame[,1], p = 0.50,list=FALSE)
    training <- frame[-testIndex,]
    testing <- frame[testIndex,]
    preProc <- preProcess(training[,-1],method="pca")
    trainPC <- predict(preProc,training[,-1])
    modelFit <- train(training[,1]~.,method="glm",data=trainPC)
    testPC <- predict(preProc,testing[,-1])
    confusionMatrix(testing[,1],predict(modelFit,testPC))
}
