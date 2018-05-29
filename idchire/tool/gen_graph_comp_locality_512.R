library(ggplot2)
library(plyr)
library(lattice)
library(reshape)

subset_ddply <- function(df, bs) {
  tmpdf = subset(df, Blocksize==bs)
  return (ddply(tmpdf, c("Exp", "Blocksize", "Access", "total_cores", "kernel"), summarize, thread_avg = mean(GFlops), Std=sd(GFlops), Nxp=length(Exp)))
}

frameidchire = read.table("./summarized_all_data_dgemm_idchire.dat", header=TRUE)
avg_idchire = subset_ddply(frameidchire, 512)
avg_idchire$machine = "idchire"

framebrunch = read.table("../../brunch/tool/summarized_all_data_dgemm.dat", header=TRUE)
avg_brunch = subset_ddply(framebrunch, 512)
avg_brunch$machine = "brunch"

combined = rbind(avg_idchire, avg_brunch)

pd = position_dodge(width=.1)



#Graph for distribution

pdf("kernel_comp_locality_gemm_512.pdf", width = 10, height=6)


myplot = ggplot(combined, aes(x=total_cores, y = thread_avg))
#myplot = myplot + geom_bar(stat="identity", position=position_dodge())
myplot = myplot + geom_point(aes(colour=machine, shape=Access))
myplot = myplot + geom_line(aes(colour=machine, group=interaction(machine, Access)))
myplot = myplot + scale_shape_manual(name="Accès", values=c(19, 4), labels=c("Local", "Distant"))
myplot = myplot + expand_limits(y=0)
myplot = myplot + guides(colour=guide_legend(override.aes=list(shape=NA)))
#myplot = myplot + facet_wrap(~Blocksize, ncol=2)
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
myplot = myplot + theme(legend.position=c(0.85, 0.15), text=element_text(size=16))
#myplot = myplot + ggtitle("kernel perf wrt total concurrent exec")
myplot = myplot + ylab("Performance moyenne (GFlops)")
myplot = myplot + xlab("Nombre d'exécutions concurrentes")
myplot = myplot + labs(colour="Machine")

print(myplot)
dev.off()
quit()

