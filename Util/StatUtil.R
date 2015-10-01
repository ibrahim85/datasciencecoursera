plotBinomPower <- function(p1,...)
{
    results <- getBinomPower(p1,...)
    plot(results[,"n"],results[,"power"],xlab="N",ylab="Power")
}

nForBinomPow <- function(pow,p1,...)
{
    results <- getBinomPower(p1,...)
    overPow <- results[results[,"power"]>=pow,c("n","power")]
    if(nrow(overPow)==0) return(-1)
    index <- which.min(overPow[,"n"])
    overPow[index,"n"]
}

getBinomPower <- function(p1,sampleRange=10:1000,alpha=.05,p0=.5)
{
    thresholds <- qbinom(1-alpha,sampleRange,p0)
    pow <- 1-pbinom(thresholds-1,sampleRange,p1)
    cbind(n=sampleRange,power=pow)
}

plotBinomSampleByProb <- function(power=.8,probs=seq(.52,.65,.01))
{
    plot(probs,sapply(probs,function(x) nForBinomPow(power,x)),xlab="P",ylab="N")
}
