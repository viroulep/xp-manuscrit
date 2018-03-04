library(ggplot2)
library(plyr)

wholeframe=read.table("./all_data.dat", header=TRUE)
wholeframe=subset(wholeframe, threads==96)



pdf("graph_details_qr_cholesky_brunch.pdf", width = 10, height=10)

levels(wholeframe$Exp) <- c("QR", "Cholesky")

myplot = ggplot(wholeframe, aes(x=factor(size), y = gflops, fill=runtime))
myplot = myplot + geom_bar(stat="identity", position=position_dodge())
myplot = myplot + geom_errorbar(position=position_dodge(0.9), aes(color=runtime, ymin=gflops-(2*std/iterations), ymax=gflops+(2*std/iterations), width=.1))
myplot = myplot + facet_wrap(~Exp, ncol=1)
myplot = myplot + theme(legend.position="right", text=element_text(size=16))
myplot = myplot + scale_x_discrete(name="Taille de matrice")
#myplot = myplot + scale_color_grey()
#myplot = myplot + ggtitle("Cholesky and QR performances for multiple sizes\n")
myplot = myplot + scale_fill_discrete(name="Support exécutif", labels=c("libOMP", "libGOMP", "libKOMP-Affinity"))
myplot = myplot + guides(fill=guide_legend(nrow=3, byrow=TRUE, keyheight=3), color=FALSE)



print(myplot)
dev.off()
