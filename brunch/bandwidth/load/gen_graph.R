library(ggplot2)
library(plyr)
library(dplyr)
library(lattice)
library(reshape)

frameall = read.table("./all_data_bandwidth_load.dat", header=TRUE)
avg_time = ddply(frameall, c("Exp", "Dest", "total_cores", "kernel", "threads_on_node", "size"), summarize, mean_time=mean(Time), Std=sd(Time), Nxp=length(Exp))
avg_bandwidth = transform(avg_time, bandwidth_gb=(size/mean_time)/1000000)
shrinked=select(avg_bandwidth, -(mean_time:Nxp))
shrinked=select(shrinked, -(threads_on_node))
sum_bandwidth = ddply(shrinked, c("Exp", "Dest", "total_cores", "kernel", "size"), summarize, full_bandwidth=sum(bandwidth_gb))

sum_bandwidth$Dest = as.character(sum_bandwidth$Dest)


sum_bandwidth

#Graph for distribution


pdf("link_saturation_brunch.pdf", width = 10, height=6)


myplot = ggplot(sum_bandwidth, aes(x=total_cores, y = full_bandwidth, colour=Dest))
#myplot = myplot + geom_bar(stat="identity", position=position_dodge())
#myplot = myplot + geom_point(aes(shape=Access, colour=kernel))
myplot = myplot + geom_line()
#myplot = myplot + expand_limits(y=0)
#myplot = myplot + facet_wrap(~Blocksize, ncol=2)
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
myplot = myplot + theme(legend.position=c(0.85, 0.70), text = element_text(size=16))
#myplot = myplot + ggtitle("Bande passante à partir du nœud 0")
myplot = myplot + scale_colour_discrete(name="Noeud destination")
myplot = myplot + ylab("Bande passante (Go/s)")
myplot = myplot + xlab("Nombre de threads")

print(myplot)
dev.off()
quit()

