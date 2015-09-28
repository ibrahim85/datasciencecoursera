pollutantmean <- function(directory,pollutant,id=1:332){
    partialvect <- NA
    for (num in id){
        buffer <- paste(rep.int("0",3-nchar(num)),collapse="")
        filepath <- paste(directory,"/",buffer,num,".csv",sep="")
        frame <- read.csv(filepath)
        partialvect <- c(partialvect,frame[[pollutant]])
    }
    mean(partialvect,na.rm = TRUE)
}