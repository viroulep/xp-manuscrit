library(ggplot2)
library(plyr)
library(lattice)
library(reshape)

wholeframe = read.table("./all_data.dat", header=TRUE)

pd = position_dodge(width=.1)
#melted = melt(framsum, id.vars=c("GFlops", "Progname", "WSselect", "WSpush", "Runtime", "Threads", "Std", "Nxp"))
#print(framsum)




pdf(paste("graph_all_cholesky_brunch.pdf", sep = ''), width = 10, height=6)


myplot = ggplot(wholeframe, aes(x=threads, y = gflops))
myplot = myplot + geom_line(aes(color=interaction(size, blocksize, runtime), group=interaction(size, blocksize, runtime)))
myplot = myplot + geom_errorbar(position=position_dodge(0.9), aes(color=interaction(size, blocksize, runtime), ymin=gflops-(2*std/iterations), ymax=gflops+(2*std/iterations), width=.1))
myplot = myplot + ylab("Performance (Gflops)")
myplot = myplot + xlab("Nombre de threads")
#myplot = myplot + ggtitle("Performances de Cholesky sur 64 threads, N=8192")
myplot = myplot + theme(legend.position=c(.90, .25), text = element_text(size=16))
#myplot = myplot + scale_colour_discrete(name="Support exécutif", labels=c("libOMP", "libGOMP", "libKOMP-Affinity", "OmpSs"))
print(myplot)
dev.off()

