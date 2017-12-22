library(ggplot2)
library(plyr)
library(lattice)
library(reshape)

framegemm = read.table("./summarized_all_data_dgemm.dat", header=TRUE)
avg_dgemm = ddply(framegemm, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=sd(GFlops), Nxp=length(Exp))

frametrsm = read.table("./summarized_all_data_dtrsm.dat", header=TRUE)
avg_dtrsm = ddply(frametrsm, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=sd(GFlops), Nxp=length(Exp))

framepotrf = read.table("./summarized_all_data_dpotrf.dat", header=TRUE)
avg_dpotrf = ddply(framepotrf, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=sd(GFlops), Nxp=length(Exp))

framesyrk = read.table("./summarized_all_data_dsyrk.dat", header=TRUE)
avg_dsyrk = ddply(framesyrk, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=sd(GFlops), Nxp=length(Exp))

combined = rbind(avg_dgemm, avg_dsyrk, avg_dtrsm, avg_dpotrf)

pd = position_dodge(width=.1)



#Graph for distribution


pdf("big_thing.pdf", width = 10, height=10)


myplot = ggplot(combined, aes(x=total_cores, y = thread_avg))
#myplot = myplot + geom_bar(stat="identity", position=position_dodge())
myplot = myplot + geom_point(aes(shape=Access, colour=kernel))
myplot = myplot + geom_line(data=subset(combined, Access=="local"), aes(colour=kernel))
myplot = myplot + geom_line(data=subset(combined, Access=="remote"), aes(colour=kernel))
myplot = myplot + expand_limits(y=0)
myplot = myplot + facet_wrap(~Blocksize, ncol=2)
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
myplot = myplot + theme(legend.position=c(0.75, 0.25))
myplot = myplot + ggtitle("Evolution of the average time for each Cholesky's kernel (Brunch CoD)")
myplot = myplot + ylab("Perf (Gflops)")
myplot = myplot + xlab("Number of threads")

print(myplot)
dev.off()
quit()

