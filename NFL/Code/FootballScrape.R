library(XML)
scrapeDVOA <- function(week) {
    # Scrapes Football Outsiders website for their up to date DVOA data and saves it to a .csv
    #
    # Args:
    #   week: Number of week the scrape is for. Will be used in file name.
    #
    url <- "http://www.footballoutsiders.com/stats/teameff"
    html <- htmlTreeParse(url,useInternalNodes = TRUE)
    rows <- xpathSApply(html,"//tr",xmlValue)
    teamCol <- 2
    DAVECol <- 5
    OffCol <- 8
    DefCol <- 10
    TotCol <- 3
    STCol <- 12
    nflData <- matrix(nrow=0,ncol=5)
    teams <- matrix(nrow = 0,ncol=1)
    for (row in rows)
        {
            rowVect <- strsplit(row,"\n")
            team <- trimws(rowVect[[1]][teamCol])
            if (team=="") next
            DAVE <- as.numeric(sub("%","",trimws(rowVect[[1]][DAVECol])))
            Off <- as.numeric(sub("%","",trimws(rowVect[[1]][OffCol])))
            Def <- -1*as.numeric(sub("%","",trimws(rowVect[[1]][DefCol])))
            Tot <- as.numeric(sub("%","",trimws(rowVect[[1]][TotCol])))
            ST <- as.numeric(sub("%","",trimws(rowVect[[1]][STCol])))
            teams <- rbind(teams,trimws(rowVect[[1]][teamCol]))
            nflData <- rbind(nflData,c(DAVE,Off,Def,Tot,ST))
        }
    nflFrame <- data.frame(I(teams),nflData)
    names(nflFrame) <- c("Teams","DAVE","Off","Def","Total","ST")
    filePath <- paste("~/datasciencecoursera/NFL/Data/2015Week",week,".csv",sep="")
    write.csv(nflFrame,filePath,row.names = FALSE)
}

scrapeOdds <- function() {
    # Scrapes Scores and Odds website for their NFL betting trends and odds data
    #
    # Args:
    #
    
}