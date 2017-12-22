library(ggplot2)
library(plyr)
library(dplyr)
library(lattice)
library(reshape)

datafile = commandArgs(TRUE)[1]
wholeframe = read.table(datafile, header=TRUE, fill=TRUE)
shrinked=select(wholeframe, -(PAPI_L3_TCM:time_ms))

summary <- function(df, n_threads) {
  tmpdf = subset(df, total_cores==n_threads)
  return (ddply(tmpdf, c("Exp", "Blocksize", "Access", "total_cores", "kernel","thread"), summarize, GFlops = mean(gflops), Std=sd(gflops), Nxp=length(Exp)))
}

basedf = summary(shrinked, 1)
for (t in 2:192) {
  print(paste("Doing ", t))
  tmp = summary(shrinked, t)
  basedf = rbind(basedf, tmp)
}

write.table(basedf, paste("summarized", datafile, sep="_"), sep=" ")
