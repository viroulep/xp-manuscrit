library(ggplot2)
library(plyr)
library(dplyr)
library(lattice)
library(reshape)

datafile = commandArgs(TRUE)[1]
bs = commandArgs(TRUE)[2]
cores = commandArgs(TRUE)[3]
wholeframe = read.table(datafile, header=TRUE, fill=TRUE)
shrinked=subset(wholeframe, Blocksize == bs & total_cores == cores)
#shrinked=select(wholeframe, -(PAPI_L3_TCM:time_ms))

write.table(shrinked, paste("selected", bs, cores, datafile, sep="_"), sep=" ")
