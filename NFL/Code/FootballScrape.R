library(XML)
scrapeDVOA <- function()
{
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
    nflFrame
    filePath <- "~/datasciencecoursera/NFL/Data/2015Week3.csv"
    write.csv(nflFrame,filePath,row.names = FALSE)
    #temp  <- read.csv(filePath,stringsAsFactors = FALSE)
}

scrapeOdds <- function()
{
    
}