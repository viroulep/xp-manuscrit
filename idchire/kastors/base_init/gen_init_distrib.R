library(ggplot2)
library(plyr)

wholeframe=read.table("./all_data_init_distrib.dat", header=TRUE)

pdf("graph_distrib_data_idchire.pdf", width = 10, height=6)

wholeframe$init=factor(wholeframe$init, levels=c("seq", "node", "parallel", "numactl", "random", "cyclic"))

myplot = ggplot(wholeframe, aes(x=runtime, y = gflops, fill=init))
myplot = myplot + geom_bar(stat="identity", position="dodge")
myplot = myplot + geom_errorbar(show.legend=FALSE, position=position_dodge(0.9), aes(color=init, ymin=gflops-(2*std/iterations), ymax=gflops+(2*std/iterations), width=.1))
#myplot = myplot + facet_wrap(Size~Blocksize, ncol=4)
myplot = myplot + ylab("GFlops")
myplot = myplot + theme(legend.position="right", text=element_text(size=16))
#myplot = myplot + ggtitle("Cholesky's performances using 32K matrices depending on the data distribution\n")
myplot = myplot + scale_fill_discrete(name="Initialisation", labels=c("Séquentielle", "Noeud unique", "Non guidée", "Numactl", "Aléatoire", "Cyclique"))
#myplot = myplot + scale_fill_discrete()
myplot = myplot + scale_x_discrete(name="Support exécutif", labels=c("libOMP", "libGOMP", "libKOMP"))
#myplot = myplot + geom_hline(aes(yintercept=framsumnumactl_gcc$GFlops), linetype="dashed")
#myplot = myplot + geom_text(aes(3.2, framsumnumactl_gcc$GFlops, label="GCC init-seq\n+ Numactl"), vjust=0.5, hjust=1.05, size=4.5, family="Courier")
#myplot = myplot + geom_hline(aes(yintercept=framsumbasegcc_para$GFlops))
#myplot = myplot + geom_text(aes(3.2, framsumbasegcc_para$GFlops, label="GCC init-para"), vjust=-0.6, hjust=1.05, size=4.5, family="Courier")
#myplot = myplot + geom_hline(aes(yintercept=framsumbasegcc$GFlops), linetype="twodash")
#myplot = myplot + geom_text(aes(3.2, framsumbasegcc$GFlops, label="GCC init-seq"), vjust=1.5, hjust=1.05, size=4.5, family="Courier")
#myplot = myplot + scale_color_grey()
myplot = myplot + guides(fill=guide_legend(nrow=7, byrow=TRUE, keyheight=3), color=FALSE)


print(myplot)
dev.off()
