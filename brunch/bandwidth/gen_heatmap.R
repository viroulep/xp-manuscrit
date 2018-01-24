library(ggplot2)
library(plyr)
library(lattice)
library(reshape)
library(scales)

node_from_core <- function(n) { return ((n%/%48)*4 + n%%4) }

bandwidth = read.table("all_data_bandwidth_brunch.dat", header=TRUE)

df_bandwidth = ddply(bandwidth, c("Exp", "node_source", "total_cores", "kernel", "size","thread_dest"), summarize, Time = mean(Time))
df_bandwidth = subset(df_bandwidth, node_source < 48 & thread_dest < 48)
df_bandwidth = transform(df_bandwidth, node_source = node_from_core(node_source), node_dest=node_from_core(thread_dest), bandwith_gb=(size/Time)/1000000)
df_bandwidth = transform(df_bandwidth, heat = (bandwith_gb))


pdf("heatmap_brunch.pdf", width = 10, height=6)
myplot=ggplot(df_bandwidth, aes(node_source, node_dest))
myplot=myplot+ geom_tile(aes(fill = heat), colour="white")
myplot=myplot+ylab("Noeud cible")
myplot=myplot+xlab("Noeud source")
#myplot=myplot+ggtitle("Carte de la bande passante sur brunch (memcpy)")
myplot=myplot+scale_fill_gradient(name="Bande passante (Go/s)", low = "grey90", high = "steelblue")
                                  #breaks=c(1, 2, 3, 4), labels=c("1.0", "2.0", "3.0", "4.0"))
#myplot=myplot+theme(plot.title = element_text(hjust = 0.5),
                    #legend.position=c(.9,.4)
                    #)

print(myplot)
dev.off()
quit()

