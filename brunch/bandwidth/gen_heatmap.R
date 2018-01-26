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
print(df_bandwidth)
#myplot=myplot+ geom_tile(aes(fill = cut(heat, c(0, 3.5, 3.7))))
myplot=myplot+ geom_tile(aes(fill = heat), colour="white")
myplot=myplot+ylab("Noeud cible")
myplot=myplot+xlab("Noeud source")
#myplot=myplot+ggtitle("Carte de la bande passante sur brunch (memcpy)")
#myplot=myplot+scale_fill_manual(name = "Bande passante (Go/s)",
                     #values = c("(0,3.5]" = "grey90",
                                  #"(3.5, 3.7]" = "steelblue4"))
                     #labels = c("<= 17", "17 < qsec <= 19", "> 19"))
myplot=myplot+scale_fill_gradient2(name="Bande passante (Go/s)", low="white", mid="green3", high="black", midpoint=3.3, limits=c(2.5, 3.61), breaks=c(2.5, 3.3, 3.6))
                                  #breaks=c(1, 2, 3, 4), labels=c("1.0", "2.0", "3.0", "4.0"))
#myplot=myplot+theme(plot.title = element_text(hjust = 0.5),
                    #legend.position=c(.9,.4)
                    #)

print(myplot)
dev.off()
quit()

