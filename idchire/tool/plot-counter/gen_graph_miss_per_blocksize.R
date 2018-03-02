library(ggplot2)
library(plyr)
library(lattice)
library(reshape)

datagemm = read.table("./summarized_small_local.dat", header=TRUE)


sum_datagemm = ddply(datagemm, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, gflops = mean(GFlops), CacheMiss = mean(L3_miss), ReadL3 = mean(L3_read)*20/100000, WriteL3 = mean(L3_write)*20/5000)

#print(sum_datagemm)
pdf(paste("dgemm_local_miss.pdf", sep = ''), width = 10, height=6)
myplot=ggplot(sum_datagemm, aes(x=total_cores, y=CacheMiss))
myplot=myplot+geom_line(aes(colour=factor(Blocksize)))
myplot = myplot + scale_colour_discrete(name="Taille (% utilisation L3)", labels=c("224 (48%)", "256 (63%)", "288 (80%)"))
#myplot=myplot+geom_line(aes(y=gflops, colour=factor(Blocksize)))
#myplot=myplot+geom_line(data=sum_datagemm,aes(x=total_cores, y=gflops), color="steelblue")
#myplot=myplot+geom_line(data=sum_datagemm,aes(x=total_cores, y=CacheMiss), color="steelblue", linetype="dotted")
#myplot=myplot+geom_line(data=sum_datagemm,aes(x=total_cores, y=ReadL3), color="steelblue", linetype="dotdash")
#myplot=myplot+geom_line(data=sum_datagemm,aes(x=total_cores, y=WriteL3), color="steelblue", linetype="dashed")

#myplot=myplot+ylim(0, 20)
myplot=myplot+ylab("L3 cache miss")
myplot=myplot+xlab("Nombre d'exécutions concurrentes")
#myplot=myplot+ggtitle("With OpenBLAS")
print(myplot)
dev.off()
quit()

