complete <- function(directory,id=1:332){
    partialSum <- 0
    answerFrame=NULL
    for (num in id){
        buffer <- paste(rep.int("0",3-nchar(num)),collapse="")
        filepath <- paste(directory,"/",buffer,num,".csv",sep="")
        frame <- read.csv(filepath)
        partialSum <- sum(rowSums(is.na(frame))==0)
        answerFrame <- rbind(answerFrame,data.frame(id=num,nobs=partialSum))
    }
    answerFrame
}