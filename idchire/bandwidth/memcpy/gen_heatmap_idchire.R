library(ggplot2)
library(plyr)
library(lattice)
library(reshape)
library(scales)

node_from_core <- function(n) { return ((n-n%%2)%/%8) }

datafile = commandArgs(TRUE)[1]
bandwidth = read.table("all_data_bandwidth_memcpy.dat", header=TRUE)

df_bandwidth = ddply(bandwidth, c("Exp", "node_source", "total_cores", "kernel", "size","thread_dest"), summarize, Time = mean(time.ms))
df_bandwidth = transform(df_bandwidth, node_dest=node_from_core(thread_dest), bandwith_gb=(size/Time)/1000000)
df_bandwidth = transform(df_bandwidth, heat = (bandwith_gb))


pdf("heatmap_idchire_memcpy.pdf", width = 10, height=6)
myplot=ggplot(df_bandwidth, aes(node_source, node_dest))
myplot=myplot+ geom_tile(aes(fill = heat), colour="white")
myplot=myplot+ylab("Noeud cible")
myplot=myplot+xlab("Noeud source")
#myplot=myplot+ggtitle("Carte de la bande passante sur idchire (memcpy)")
myplot=myplot+scale_fill_gradient2(name="Bande passante (Go/s)", limits=c(0.0, 3.2), low="red", mid="white", high="green4", midpoint=1.12, breaks=c(0, 1.12, 3.15))
#myplot=myplot+scale_fill_gradientn(colours=heat.color(10), name="Bande passante (Go/s)", low = "grey90", high = "steelblue")
#myplot=myplot+theme(plot.title = element_text(hjust = 0.5),
                    #legend.position=c(.9,.4)
                    #)

print(myplot)
dev.off()
quit()

