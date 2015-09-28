corr <- function(directory,threshold=0){
    answer <- vector(mode="numeric",length=0)
    for (num in 1:332){
        completeFrame <- complete(directory,num)
        if (completeFrame$nobs[[1]]<=threshold) {next}
        buffer <- paste(rep.int("0",3-nchar(num)),collapse="")
        filepath <- paste(directory,"/",buffer,num,".csv",sep="")
        frame <- read.csv(filepath)
        correlation <- cor(frame$sulfate,frame$nitrate,use="na.or.complete")
        answer <- c(answer,correlation)
    }
    answer
}