library(dplyr)

splitFrame <- function(frame) {
    # Randomly splits a data frame by rows into two equal sets for training and testing
    #
    # Args:
    #   frame: Data frame to split
    #
    # Returns:
    #   List containing the two halves of the data frame
    rows <- seq_len(nrow(frame))
    group1 <- sample(rows,length(rows)/2)
    group2 <- rows[!rows %in% group1]
    list(frame[group1,],frame[group2,])
}

addQuantiles <- function(frame,column,probs=seq(0,1,.25)) {
    # Adds a new column to a data frame which gives quantiles for an existing column
    #
    # Args:
    #   frame:  Data frame to add quantiles
    #   column: Column used to create quantiles
    #   probs:  Vector of quantiles to use (see ?quantile)
    # Returns:
    #   Data frame with new column "Quant" of quantiles added
    q <- quantile(column,probs)
    cut <- cut(column, q, labels <- seq(length(probs)-1),include.lowest=TRUE)
    mutate(frame,Quant=cut)
}

getCorrelations <- function(frame, column,use="complete.obs"){
    # Correlates one columns of a data frame with the others.
    #
    # Args:
    #   frame:  Data frame with variables in question
    #   column: Column used as main correlate
    #   use:  See ?cor
    # Returns:
    #   Correlations for every other variable against the specified variable
    # Assumes:
    #   Data frame must be entirely numeric
    correl <- cor(frame,use=use)[-which(names(frame) %in% c(column)),column]
    correl[order(abs(correl),decreasing=TRUE)]
}

normFrame <- function(frame){
    # Returns a normalized data frame
    #
    # Args:
    #   frame:  Data frame to add quantiles
    #
    as.data.frame(scale(frame))
}
