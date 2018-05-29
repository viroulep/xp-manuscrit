library(ggplot2)
library(plyr)
library(lattice)
library(reshape)

wholeframe = read.table("./all_data.dat", header=TRUE)

pd = position_dodge(width=.1)
#melted = melt(framsum, id.vars=c("GFlops", "Progname", "WSselect", "WSpush", "Runtime", "Threads", "Std", "Nxp"))
#print(framsum)




pdf(paste("graph_all_cholesky_idchire.pdf", sep = ''), width = 10, height=6)


wholeframe$runtime = factor(wholeframe$runtime, levels=c("libgomp", "clang", "libkomp"), labels=c("libgomp", "clang", "libkomp"))

frame_all_cholesky = subset(wholeframe, (size == 8192 | size == 32768) & program == "dpotrf_taskdep")
myplot = ggplot(frame_all_cholesky, aes(x=threads, y = gflops))
myplot = myplot + geom_line(aes(color=runtime, group=interaction(size, runtime)))
myplot = myplot + geom_point(aes(shape=factor(size), color=runtime, group=interaction(size, runtime)))
myplot = myplot + guides(colour = guide_legend(override.aes = list(shape = NA)))
#myplot = myplot + guides(colour = guide_legend(title="Taille"))
#myplot = myplot + geom_errorbar(position=position_dodge(0.9), aes(color=runtime, ymin=gflops-(2*std/iterations), ymax=gflops+(2*std/iterations), width=.1))
#myplot = myplot + facet_wrap(~program, ncol=1)
myplot = myplot + ylab("Performance (GFlops)")
myplot = myplot + xlab("Nombre de threads")
#myplot = myplot + ggtitle("Performances de Cholesky sur 64 threads, N=8192")
myplot = myplot + theme(legend.position=c(.25, .75), text = element_text(size=16))
myplot = myplot + scale_colour_discrete(name="Support exécutif", labels=c("libGOMP", "libOMP", "libKOMP (Affinity)"))
myplot = myplot + scale_shape_manual(name="Taille de matrice (taille de bloc)", values=c(4, 19), labels=c("8192 (256)", "32768 (512)"))
print(myplot)
dev.off()


frame_comp_threads=subset(wholeframe, size == 32768)

pdf(paste("graph_qr_cholesky_vs_threads.pdf", sep = ''), width = 10, height=6)

levels(frame_comp_threads$program) <- c("QR", "Cholesky")

myplot = ggplot(frame_comp_threads, aes(x=threads, y = gflops))
myplot = myplot + geom_line(aes(color=runtime))
#myplot = myplot + geom_errorbar(position=position_dodge(0.9), aes(color=interaction(WSselect, WSpush, Taskprio), ymin=GFlops-(2*Std/Nxp), ymax=GFlops+(2*Std/Nxp), width=.1))
myplot = myplot + facet_grid(~program, scales="free_y")
myplot = myplot + geom_point(size=2,aes(color=runtime), shape=19)
myplot = myplot + theme(legend.position=c(.85, .20), text = element_text(size=16))
myplot = myplot + scale_colour_discrete(name="Support exécutif", labels=c("libGOMP", "libOMP", "libKOMP (Affinity)"))
myplot = myplot + ylab("Performance (Gflops)")
myplot = myplot + xlab("Nombre de threads")

print(myplot)
dev.off()
