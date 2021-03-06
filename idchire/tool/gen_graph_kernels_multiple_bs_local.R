library(ggplot2)
library(plyr)
library(lattice)
library(reshape)

subset_ddply <- function(df, bs) {
  tmpdf = subset(df, Access == "local" & Blocksize != "224" & Blocksize != "288")
  return (ddply(tmpdf, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=sd(GFlops), Nxp=length(Exp)))
}

framegemm = read.table("./summarized_all_data_dgemm_idchire.dat", header=TRUE)
avg_dgemm = subset_ddply(framegemm, 256)

#frametrsm = read.table("./summarized_all_data_dtrsm_idchire.dat", header=TRUE)
#avg_dtrsm = subset_ddply(frametrsm, 256)

framepotrf = read.table("./summarized_all_data_dpotrf_idchire.dat", header=TRUE)
avg_dpotrf = subset_ddply(framepotrf, 256)

#framesyrk = read.table("./summarized_all_data_dsyrk_idchire.dat", header=TRUE)
#avg_dsyrk = subset_ddply(framesyrk, 256)

combined = rbind(avg_dgemm, avg_dpotrf)

pd = position_dodge(width=.1)



#Graph for distribution


pdf("kernels_multiple_bs_local_idchire.pdf", width = 10, height=6)


myplot = ggplot(combined, aes(x=total_cores, y = thread_avg))
#myplot = myplot + geom_bar(stat="identity", position=position_dodge())
myplot = myplot + geom_point(aes(shape=kernel, colour=factor(Blocksize)))
myplot = myplot + geom_line(aes(group=interaction(kernel, Blocksize), colour=factor(Blocksize)))
myplot = myplot + expand_limits(y=0)
#myplot = myplot + facet_wrap(~Blocksize, ncol=2)
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
myplot = myplot + theme(legend.position=c(0.75, 0.15), legend.direction="horizontal", text=element_text(size=16))
#myplot = myplot + ggtitle("kernel perf wrt total concurrent exec")
myplot = myplot + ylab("Perf (Gflops)")
myplot = myplot + xlab("Nombre d'exécutions concurrentes")
myplot = myplot + labs(colour="Taille de bloc")
myplot = myplot + guides(colour=guide_legend(override.aes=list(shape=NA)))
myplot = myplot + scale_shape_manual(name="Noyau", values=c(19, 4))

print(myplot)
dev.off()
quit()

