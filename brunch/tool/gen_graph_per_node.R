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

#df_gemm_0 = subset(framegemm, thread %% 4 == 0)
#avg_0 = ddply(df_gemm_0, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=sd(GFlops), Nxp=length(Exp))
#print(avg_0)
#df_gemm_1 = subset(framegemm, thread %% 4 == 1)
#avg_1 = ddply(df_gemm_1, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=sd(GFlops), Nxp=length(Exp))
#df_gemm_2 = subset(framegemm, thread %% 4 == 2)
#avg_2 = ddply(df_gemm_2, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=sd(GFlops), Nxp=length(Exp))
#df_gemm_3 = subset(framegemm, thread %% 4 == 3)
#avg_3 = ddply(df_gemm_3, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=sd(GFlops), Nxp=length(Exp))

combined = rbind(framegemm, framesyrk, frametrsm, framepotrf)
combined = subset(combined, Blocksize == 512 & Access == "remote" & (kernel == "dgemm" | kernel == "dpotrf"))
#combined = subset(combined, Blocksize == 512 & Access == "remote" & kernel == "dgemm")
combined = subset(combined, total_cores == 26 | total_cores == 24 | total_cores == 36 | total_cores == 30 | total_cores == 48 | total_cores == 40)
#combined_avg = rbind(avg_dgemm, avg_dsyrk, avg_dtrsm, avg_dpotrf)

pd = position_dodge(width=.1)




pdf("illustration_load_avg.pdf", width = 10, height=10)


#myplot = ggplot(combined, aes(x=thread, y = GFlops))
myplot = ggplot(combined, aes(x=GFlops, fill = as.factor(kernel)))
#myplot = myplot + geom_point(aes(colour=kernel, shape=kernel))
myplot = myplot + geom_density()
myplot = myplot + scale_fill_discrete(name="Noyau")
myplot = myplot + expand_limits(y=0)
myplot = myplot + facet_wrap(~total_cores, ncol=2)
myplot = myplot + theme(legend.position=c(0.90, 0.90), text=element_text(size=16))
myplot = myplot + ylab("Nombre")
myplot = myplot + xlab("GFlops")
myplot = myplot + labs(colour="Noyau", shape="Noyau", fill="Noyau")

#myplot = myplot + geom_bar(stat="identity", position=position_dodge())
#myplot = myplot + geom_line(data=subset(avg_0, Access="remote"))
#myplot = myplot + geom_line(data=subset(avg_1, Access="remote"))
#myplot = myplot + geom_line(data=subset(avg_2, Access="remote"))
#myplot = myplot + geom_line(data=subset(avg_3, Access="remote"))
#myplot = myplot + geom_line(data=combined, aes(colour=kernel))
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
#myplot = myplot + theme(legend.position=c(0.75, 0.25))
#myplot = myplot + ggtitle("Plot, courbe par noeud")

print(myplot)
dev.off()
quit()

