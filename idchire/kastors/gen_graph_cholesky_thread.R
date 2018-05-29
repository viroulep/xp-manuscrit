library(ggplot2)
library(plyr)

framecholesky = read.table("./all_data.dat", header=TRUE)
framecholesky = subset(framecholesky, size == 32768 & program == "dpotrf_taskdep" & runtime == "libgomp")

pd = position_dodge(width=.1)



pdf("graph_evolution_cholesky_32768_512.pdf", width = 10, height=4)


myplot = ggplot(framecholesky, aes(x=threads, y = gflops))
#myplot = myplot + geom_bar(stat="identity", position=position_dodge())
myplot = myplot + geom_point(aes(colour=program))
myplot = myplot + geom_line(aes(colour=program))
#myplot = myplot + expand_limits(y=0)
#myplot = myplot + facet_wrap(~Name, ncol=2)
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
#myplot = myplot + ggtitle("Évolution des performances de Cholesky (taille 8192, blocs 224)")
myplot = myplot + ylab("GFlops")
myplot = myplot + xlab("Nombres de threads")
myplot = myplot + theme(legend.position="none", text=element_text(size=16))
#myplot = myplot + scale_fill_discrete(name="", labels=c("sRand\npLoc", "sRandNuma\npLocNum", "sNumaProc\npNumaWLoc", "sProc\npNumaWLoc"))
#myplot = myplot + scale_x_discrete(name="Data distribution")
#myplot = myplot + geom_hline(aes(yintercept=framsumnumactl_gcc$GFlops), linetype="dashed")
#myplot = myplot + geom_text(aes(3.2, framsumnumactl_gcc$GFlops, label="GCC init-seq\n+ Numactl"), vjust=0.5, hjust=1.05, size=4.5, family="Courier")
#myplot = myplot + geom_hline(aes(yintercept=framsumbasegcc_para$GFlops))
#myplot = myplot + geom_text(aes(3.2, framsumbasegcc_para$GFlops, label="GCC init-para"), vjust=-0.6, hjust=1.05, size=4.5, family="Courier")
#myplot = myplot + geom_hline(aes(yintercept=framsumbasegcc$GFlops), linetype="twodash")
#myplot = myplot + geom_text(aes(3.2, framsumbasegcc$GFlops, label="GCC init-seq"), vjust=1.5, hjust=1.05, size=4.5, family="Courier")
#myplot = myplot + scale_color_grey()
#myplot = myplot + guides(fill=guide_legend(nrow=4, byrow=TRUE, keyheight=3), color=FALSE)


print(myplot)
dev.off()
quit()

