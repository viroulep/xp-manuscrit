library(ggplot2)
library(plyr)
library(dplyr)
library(lattice)
library(reshape)

datafile = commandArgs(TRUE)[1]
wholeframe = read.table(datafile, header=TRUE, fill=TRUE)
wholeframe = subset(wholeframe, (Blocksize == 256 | Blocksize == 224 | Blocksize == 288) & Access == "local" & PAPI_L3_TCM >= 0 & PAPI_L3_DCR >= 0 & PAPI_L3_DCW >= 0)
#shrinked=select(wholeframe, -(PAPI_L3_TCM:time_ms))
shrinked=select(wholeframe, -(time_ms))

summary <- function(df, n_threads) {
  tmpdf = subset(df, total_cores==n_threads)
  #return (ddply(tmpdf, c("Exp", "Blocksize", "Access", "total_cores", "kernel","thread"), summarize, GFlops = mean(gflops), Std=sd(gflops), Nxp=length(Exp)))
  return (ddply(tmpdf, c("Exp", "Blocksize", "Access", "total_cores", "kernel","thread"), summarize, GFlops = mean(gflops), Std=sd(gflops), Nxp=length(Exp), L3_miss=mean(PAPI_L3_TCM), L3_read=mean(PAPI_L3_DCR), L3_write=mean(PAPI_L3_DCW)))
}

basedf = summary(shrinked, 1)
for (t in 2:192) {
  print(paste("Doing ", t))
  tmp = summary(shrinked, t)
  basedf = rbind(basedf, tmp)
}

write.table(basedf, "summarized_small_local.dat")
