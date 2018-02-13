library(ggplot2)
library(plyr)
library(lattice)
library(reshape)

#subset(titi_frame, select_node(0, thread) & (total_cores == 24 | total_cores == 96))
select_node <- function(node, thread) {
  return (node == thread%%4)
}

load_ddply <- function(prefix, suffix) {

  framegemm = read.table(paste(prefix, "dgemm", suffix, sep=""), header=TRUE)
  avg_dgemm = ddply(framegemm, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=mean(Std), Nxp=mean(Nxp))

  #frametrsm = read.table(paste(prefix, "dtrsm", suffix, sep=""), header=TRUE)
  #avg_dtrsm = ddply(frametrsm, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=sd(GFlops), Nxp=length(Exp))

  framepotrf = read.table(paste(prefix, "dpotrf", suffix, sep=""), header=TRUE)
  avg_dpotrf = ddply(framepotrf, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=mean(Std), Nxp=mean(Nxp))

  #framesyrk = read.table(paste(prefix, "dsyrk", suffix, sep=""), header=TRUE)
  #avg_dsyrk = ddply(framesyrk, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=sd(GFlops), Nxp=length(Exp))

  #return(rbind(avg_dgemm, avg_dsyrk, avg_dtrsm, avg_dpotrf))
  return(rbind(avg_dgemm, avg_dpotrf))

}

pd = position_dodge(width=.1)

combined_mkl=subset(load_ddply("./summarized_all_data_", "_mkl.dat"), Access=="local")
combined_mkl$blas = "mkl"
head(combined_mkl)
combined_atlas=subset(load_ddply("../tool-atlas/summarized_all_data_", "_atlas.dat"), Access=="local" & Blocksize == 256)
combined_atlas$blas = "atlas"
titi=load_ddply("../tool/summarized_all_data_", ".dat")
combined_openblas=subset(titi, Access=="local" & Blocksize == 256)
combined_openblas$blas = "openblas"
subset(titi, kernel=="dgemm" & total_cores == 96 | total_cores == 24)
combined = rbind(combined_mkl, combined_openblas, combined_atlas)

#Graph for distribution


pdf("big_thing_mkl.pdf", width = 10, height=10)


myplot = ggplot(combined, aes(x=total_cores, y = thread_avg))
#myplot = myplot + geom_bar(stat="identity", position=position_dodge())
myplot = myplot + geom_point(aes(colour=kernel, shape=blas))
#myplot = myplot + geom_ribbon(aes(colour=kernel, group=interaction(kernel, blas), ymax=thread_avg+2*Std/Nxp, ymin=thread_avg-2*Std/Nxp))
myplot = myplot + geom_line(aes(colour=kernel, group=interaction(kernel, blas)))
#myplot = myplot + geom_point(data=combined_mkl, aes(colour=kernel), shape=3)
#myplot = myplot + geom_line(data=combined_mkl, aes(colour=kernel))
#myplot = myplot + geom_point(data=combined_openblas, aes(colour=kernel), shape=5)
#myplot = myplot + geom_line(data=combined_openblas, aes(colour=kernel))
myplot = myplot + expand_limits(y=0)
myplot = myplot + guides(colour = guide_legend(override.aes = list(shape = NA)))
#myplot = myplot + scale_colour_discrete(name="Support exécutif", labels=c("libOMP", "libGOMP", "libKOMP-Affinity"))
#myplot = myplot + scale_shape_manual(name="Taille de matrice", values=c(1, 3, 5), labels=c("a","b","c"))
myplot = myplot + facet_wrap(~Blocksize, ncol=2)
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
myplot = myplot + theme(legend.position=c(0.75, 0.25))
myplot = myplot + ggtitle("Evolution of the average time for each Cholesky's kernel (brunch)")
myplot = myplot + ylab("Perf (Gflops)")
myplot = myplot + xlab("Number of threads")

print(myplot)
dev.off()

pdf("comparaison_atlas_openblas_mkl_256_local.pdf", width = 10, height=8)


myplot = ggplot(combined, aes(x=total_cores, y = thread_avg))
#myplot = myplot + geom_bar(stat="identity", position=position_dodge())
myplot = myplot + geom_point(aes(colour=kernel, shape=blas))
#myplot = myplot + geom_ribbon(aes(colour=kernel, group=interaction(kernel, blas), ymax=thread_avg+2*Std/Nxp, ymin=thread_avg-2*Std/Nxp))
myplot = myplot + geom_line(aes(colour=kernel, group=interaction(kernel, blas)))
myplot = myplot + expand_limits(y=0)
myplot = myplot + scale_shape_manual(name="BLAS", values=c(19, 4, 0))
myplot = myplot + guides(colour = guide_legend(override.aes = list(shape = NA)))
#myplot = myplot + scale_colour_discrete(name="Support exécutif", labels=c("libOMP", "libGOMP", "libKOMP-Affinity"))
#myplot = myplot + scale_shape_manual(name="Taille de matrice", values=c(1, 3, 5), labels=c("a","b","c"))
myplot = myplot + facet_wrap(~Blocksize, ncol=2)
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
myplot = myplot + theme(legend.position=c(0.75, 0.1), text=element_text(size=16), legend.direction="horizontal")
#myplot = myplot + ggtitle("Evolution of the average time for each Cholesky's kernel (brunch)")
myplot = myplot + ylab("Perf (Gflops)")
myplot = myplot + labs(colour="Noyau")
myplot = myplot + xlab("Nombre d'exécutions concurrentes")

print(myplot)
dev.off()
quit()

