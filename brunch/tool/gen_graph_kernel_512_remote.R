library(ggplot2)
library(plyr)
library(lattice)
library(reshape)

subset_ddply <- function(df, bs) {
  tmpdf = subset(df, Blocksize==bs)
  return (ddply(tmpdf, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=sd(GFlops), Nxp=length(Exp)))
}

framegemm = read.table("./summarized_all_data_dgemm.dat", header=TRUE)
avg_dgemm = subset_ddply(framegemm, 512)
avg_dgemm_small = subset_ddply(framegemm, 256)

#frametrsm = read.table("./summarized_all_data_dtrsm.dat", header=TRUE)
#avg_dtrsm = subset_ddply(frametrsm, 512)

framepotrf = read.table("./summarized_all_data_dpotrf.dat", header=TRUE)
avg_dpotrf = subset_ddply(framepotrf, 512)

#framesyrk = read.table("./summarized_all_data_dsyrk.dat", header=TRUE)
#avg_dsyrk = subset_ddply(framesyrk, 512)

combined = rbind(avg_dgemm, avg_dpotrf)
combined_small = rbind(avg_dgemm, avg_dgemm_small)

pd = position_dodge(width=.1)



#Graph for distribution


pdf("kernel_512_remote_brunch.pdf", width = 10, height=6)


myplot = ggplot(combined, aes(x=total_cores, y = thread_avg))
#myplot = myplot + geom_bar(stat="identity", position=position_dodge())
myplot = myplot + geom_point(aes(colour=kernel, shape=Access))
myplot = myplot + geom_line(aes(colour=kernel, group=interaction(kernel, Access)))
myplot = myplot + scale_shape_manual(name="Accès", values=c(19, 4), labels=c("Local", "Distant"))
myplot = myplot + expand_limits(y=0)
myplot = myplot + guides(colour=guide_legend(override.aes=list(shape=NA)))
#myplot = myplot + facet_wrap(~Blocksize, ncol=2)
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
myplot = myplot + theme(legend.position=c(0.85, 0.15), text=element_text(size=16))
#myplot = myplot + ggtitle("kernel perf wrt total concurrent exec")
myplot = myplot + ylab("Perf (Gflops)")
myplot = myplot + xlab("Nombre d'exécutions concurrentes")
myplot = myplot + labs(colour="Noyau")

print(myplot)
dev.off()

pdf("kernel_dgemm_remote_brunch.pdf", width = 10, height=6)


myplot = ggplot(combined_small, aes(x=total_cores, y = thread_avg))
#myplot = myplot + geom_bar(stat="identity", position=position_dodge())
myplot = myplot + geom_point(aes(colour=as.factor(Blocksize), shape=Access))
myplot = myplot + geom_line(aes(colour=as.factor(Blocksize), group=interaction(Blocksize, Access)))
myplot = myplot + scale_shape_manual(name="Accès", values=c(19, 4), labels=c("Local", "Distant"))
myplot = myplot + expand_limits(y=0)
myplot = myplot + guides(colour=guide_legend(override.aes=list(shape=NA)))
#myplot = myplot + facet_wrap(~Blocksize, ncol=2)
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
myplot = myplot + theme(legend.position=c(0.85, 0.15), text=element_text(size=16))
#myplot = myplot + ggtitle("kernel perf wrt total concurrent exec")
myplot = myplot + ylab("Perf (Gflops)")
myplot = myplot + xlab("Nombre d'exécutions concurrentes")
myplot = myplot + labs(colour="Taille de matrice")

print(myplot)
dev.off()
quit()

