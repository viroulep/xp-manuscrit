library(ggplot2)
library(plyr)
library(lattice)
library(reshape)

datafile = commandArgs(TRUE)[1]
wholeframe = read.table(datafile, header=TRUE)
frame_8k_64 = subset(wholeframe, Size == "8192")
frame_8k_64 = subset(frame_8k_64, Threads == "64")
frame_8k_128 = subset(wholeframe, Size == "8192")
frame_8k_128 = subset(frame_8k_128, Threads == "128")
frame_16k_64 = subset(wholeframe, Size == "16384")
frame_16k_64 = subset(frame_16k_64, Threads == "64")
#wholeframe = subset(wholeframe, Blocksize == "512")
#wholeframe = subset(wholeframe, Placement == "contiguous")
#wholeframe = subset(wholeframe, Numactl == "all")
#print(wholeframe)
#framsum = ddply(wholeframe, c("Runtime","WSselect", "Progname", "WSpush","Size","Blocksize","Threads", "Taskprio"), summarize, GFlops = mean(Gflops), Std = sd(Gflops), Nxp=length(Runtime))
#framsum = ddply(wholeframe, c("Runtime","WSselect", "Progname", "WSpush","Size","Blocksize","Threads"), summarize, GFlops = mean(Gflops))

pd = position_dodge(width=.1)
#melted = melt(framsum, id.vars=c("GFlops", "Progname", "WSselect", "WSpush", "Runtime", "Threads", "Std", "Nxp"))
#print(framsum)




pdf(paste("graph_granularity_8k_64.pdf", sep = ''), width = 10, height=6)


myplot = ggplot(frame_8k_64, aes(x=Blocksize, y = Gflops))
myplot = myplot + geom_line(aes(x=Blocksize, y = Gflops, color=Runtime, group=Runtime))
myplot = myplot + geom_errorbar(position=position_dodge(0.9), aes(color=Runtime, ymin=Gflops-(2*Stddev/Iterations), ymax=Gflops+(2*Stddev/Iterations), width=.1))
myplot = myplot + ylab("Performance (Gflops)")
myplot = myplot + xlab("Taille de bloc")
#myplot = myplot + ggtitle("Performances de Cholesky sur 64 threads, N=8192")
myplot = myplot + theme(legend.position=c(.90, .25), text = element_text(size=16))
myplot = myplot + scale_colour_discrete(name="Support exécutif", labels=c("libOMP", "libGOMP", "libKOMP-Affinity", "OmpSs"))
print(myplot)
dev.off()


pdf(paste("graph_granularity_8k_128.pdf", sep = ''), width = 10, height=6)


myplot = ggplot(frame_8k_128, aes(x=Blocksize, y = Gflops))
myplot = myplot + geom_line(aes(x=Blocksize, y = Gflops, color=Runtime, group=Runtime))
myplot = myplot + geom_errorbar(position=position_dodge(0.9), aes(color=Runtime, ymin=Gflops-(2*Stddev/Iterations), ymax=Gflops+(2*Stddev/Iterations), width=.1))
myplot = myplot + ylab("Performance (Gflops)")
myplot = myplot + xlab("Taille de bloc")
#myplot = myplot + ggtitle("Performances de Cholesky sur 128 threads, N=8192")
myplot = myplot + theme(legend.position=c(.90, .25), text = element_text(size=16))
myplot = myplot + scale_colour_discrete(name="Support exécutif", labels=c("libOMP", "libGOMP", "libKOMP-Affinity", "OmpSs"))
print(myplot)
dev.off()

pdf(paste("graph_granularity_16k_64.pdf", sep = ''), width = 10, height=6)


myplot = ggplot(frame_16k_64, aes(x=Blocksize, y = Gflops))
myplot = myplot + geom_line(aes(x=Blocksize, y = Gflops, color=Runtime, group=Runtime))
myplot = myplot + geom_errorbar(position=position_dodge(0.9), aes(color=Runtime, ymin=Gflops-(2*Stddev/Iterations), ymax=Gflops+(2*Stddev/Iterations), width=.1))
myplot = myplot + ylab("Performance (Gflops)")
myplot = myplot + xlab("Taille de bloc")
#myplot = myplot + ggtitle("Performances de Cholesky sur 64 threads, N=16384")
myplot = myplot + theme(legend.position=c(.90, .25), text = element_text(size=16))
myplot = myplot + scale_colour_discrete(name="Support exécutif", labels=c("libOMP", "libGOMP", "libKOMP-Affinity", "OmpSs"))
print(myplot)
dev.off()



#myplot = myplot + geom_line(aes(x=Threads, y=GFlops, group=interaction(Progname, Runtime,Size,Blocksize),color=interaction(Progname, Runtime,Size,Blocksize)))
#myplot = myplot + facet_grid(Numactl~Placement)
#myplot = myplot + guides(col = guide_legend(ncol=3))
#myplot = myplot + theme(legend.text = element_text(size=8), legend.title = element_text(size=8), legend.position="bottom")
#myplot = myplot + ggtitle("Performance of OpenMP Runtimes")

