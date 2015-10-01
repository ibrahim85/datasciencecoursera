library(dplyr)

splitFrame <- function(frame)
{
    rows <- seq_len(nrow(frame))
    group1 <- sample(rows,length(rows)/2)
    group2 <- rows[!rows %in% group1]
    assign("splitFrame",list(frame[group1,],frame[group2,]),envir=.GlobalEnv)
}

addQuantiles <- function(frame,column,probs=seq(0,1,.25))
{
    q <- quantile(column,probs)
    cut <- cut(column, q, labels <- seq(length(probs)-1),include.lowest=TRUE)
    mutate(frame,Quant=cut)
}