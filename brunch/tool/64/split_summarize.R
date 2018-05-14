library(ggplot2)
library(plyr)
library(dplyr)
library(lattice)
library(reshape)

datafile = commandArgs(TRUE)[1]
wholeframe = read.table(datafile, header=TRUE, fill=TRUE)
wholeframe = subset(wholeframe, PAPI_TOT_CYC > 0 & PAPI_REF_CYC > 0)
shrinked=select(wholeframe, -(time_ms))

summary <- function(df, n_threads) {
  tmpdf = subset(df, total_cores==n_threads)
  return (ddply(tmpdf, c("Exp", "Blocksize", "Access", "total_cores", "kernel","thread"), summarize, GFlops = mean(gflops), cycles=mean(PAPI_TOT_CYC), cycles_ref=mean(PAPI_REF_CYC), Std=sd(gflops), Nxp=length(Exp)))
}

basedf = summary(shrinked, 1)
for (t in 2:96) {
  print(paste("Doing ", t))
  tmp = summary(shrinked, t)
  basedf = rbind(basedf, tmp)
}

write.table(basedf, paste("summarized", datafile, sep="_"), sep=" ")
