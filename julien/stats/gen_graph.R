library(ggplot2)
library(plyr)

datafile = commandArgs(TRUE)[1]
#"./02_01_2017/alldata.dat"
wholeframe = read.table(datafile, header=TRUE)

pd = position_dodge(width=.1)

#2.4 is the frequency (GHz) of idchire
#dirty hardcoded values...
wholeframe2 <- transform(wholeframe, gflops = flops*2.4/duration)

pdf("graph_distrib.pdf", width = 10, height=4)

#print(framsum)

subframe = subset(wholeframe, threads == "192")


myplot = ggplot(subframe, aes(x=duration, fill=task_id))
myplot = myplot + geom_density()
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
#myplot = myplot + scale_x_discrete(name="Matrix sizes (512 BS)")
myplot = myplot + scale_fill_discrete(name="Kernel: ")
myplot = myplot + ggtitle("Distribution of Cholesky's kernels duration")
myplot = myplot + xlab("Duration (cycles)")
myplot = myplot + xlim(10000, 25000000)
#myplot = myplot + scale_fill_discrete(name="", labels=c("sRand\npLoc", "sHierarchy\npAffinityLoc", "sRandNuma\npAffinity"))
#myplot = myplot + guides(fill=guide_legend(nrow=3, byrow=TRUE, keyheight=3), color=FALSE)



print(myplot)
dev.off()



pdf("graph_distrib_overview.pdf", width = 10, height=6)

#print(framsum)
subframe = subset(wholeframe2, threads != "8" & threads != "128" & date >= "3422407423")



myplot = ggplot(subframe, aes(x=gflops, fill=as.factor(threads)))
myplot = myplot + geom_density()
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
#myplot = myplot + scale_x_discrete(name="Matrix sizes (512 BS)")
myplot = myplot + scale_fill_discrete(name="Nombre de coeurs :")
myplot = myplot + facet_wrap(~task_id, ncol=2)
#myplot = myplot + ggtitle("Distribution of Cholesky's kernels duration")
myplot = myplot + xlab("Performance (GFlops)")
myplot = myplot + ylab("Densité")
myplot = myplot + xlim(0, 20)
print(myplot)
dev.off()

pdf("graph_anim_distrib.pdf", width = 10, height=6)
subframe = subset(wholeframe2, threads == "16" & date >= "3422407423" & task_id == "potrf")

myplot = ggplot(subframe, aes(x=gflops, fill=as.factor(threads)))
myplot = myplot + geom_density()
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
#myplot = myplot + scale_x_discrete(name="Matrix sizes (512 BS)")
myplot = myplot + scale_fill_manual(name="Nombre de coeurs :", values=c("#f8766d","#a3a500","#00bf7d","#00b0f6","#e76bf3"))
#myplot = myplot + facet_wrap(~task_id, ncol=2)
#myplot = myplot + ggtitle("Distribution of Cholesky's kernels duration")
myplot = myplot + xlim(0, 20)
myplot = myplot + xlab("Performance (GFlops)")
myplot = myplot + ylab("Densité")

print(myplot)
dev.off()

pdf("graph_anim_distrib_1.pdf", width = 10, height=6)
subframe = subset(wholeframe2, (threads == "16" | threads == "32" ) & date >= "3422407423" & task_id == "potrf")

myplot = ggplot(subframe, aes(x=gflops, fill=as.factor(threads)))
myplot = myplot + geom_density()
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
#myplot = myplot + scale_x_discrete(name="Matrix sizes (512 BS)")
myplot = myplot + scale_fill_manual(name="Nombre de coeurs :", values=c("#f8766d","#a3a500","#00bf7d","#00b0f6","#e76bf3"))
#myplot = myplot + facet_wrap(~task_id, ncol=2)
#myplot = myplot + ggtitle("Distribution of Cholesky's kernels duration")
myplot = myplot + xlim(0, 20)
myplot = myplot + xlab("Performance (GFlops)")
myplot = myplot + ylab("Densité")

print(myplot)
dev.off()


pdf("graph_anim_distrib_2.pdf", width = 10, height=6)
subframe = subset(wholeframe2, (threads == "16" | threads == "32" | threads == "96" ) & date >= "3422407423" & task_id == "potrf")

myplot = ggplot(subframe, aes(x=gflops, fill=as.factor(threads)))
myplot = myplot + geom_density()
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
#myplot = myplot + scale_x_discrete(name="Matrix sizes (512 BS)")
myplot = myplot + scale_fill_manual(name="Nombre de coeurs :", values=c("#f8766d","#a3a500","#00bf7d","#00b0f6","#e76bf3"))
#myplot = myplot + facet_wrap(~task_id, ncol=2)
#myplot = myplot + ggtitle("Distribution of Cholesky's kernels duration")
myplot = myplot + xlim(0, 20)
myplot = myplot + xlab("Performance (GFlops)")
myplot = myplot + ylab("Densité")

print(myplot)
dev.off()

pdf("graph_anim_distrib_3.pdf", width = 10, height=6)
subframe = subset(wholeframe2, (threads=="144" | threads == "16" | threads == "32" | threads == "96" ) & date >= "3422407423" & task_id == "potrf")

myplot = ggplot(subframe, aes(x=gflops, fill=as.factor(threads)))
myplot = myplot + geom_density()
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
#myplot = myplot + scale_x_discrete(name="Matrix sizes (512 BS)")
myplot = myplot + scale_fill_manual(name="Nombre de coeurs :", values=c("#f8766d","#a3a500","#00bf7d","#00b0f6","#e76bf3"))
#myplot = myplot + facet_wrap(~task_id, ncol=2)
#myplot = myplot + ggtitle("Distribution of Cholesky's kernels duration")
myplot = myplot + xlim(0, 20)
myplot = myplot + xlab("Performance (GFlops)")
myplot = myplot + ylab("Densité")

print(myplot)
dev.off()

pdf("graph_anim_distrib_4.pdf", width = 10, height=6)
subframe = subset(wholeframe2, (threads=="192"|threads=="144" | threads == "16" | threads == "32" | threads == "96" ) & date >= "3422407423" & task_id == "potrf")

myplot = ggplot(subframe, aes(x=gflops, fill=as.factor(threads)))
myplot = myplot + geom_density()
#myplot = myplot + theme(legend.position="right", legend.title=element_text(size=14), legend.text=element_text(size=13), axis.text=element_text(size=12))
#myplot = myplot + scale_x_discrete(name="Matrix sizes (512 BS)")
myplot = myplot + scale_fill_manual(name="Nombre de coeurs :", values=c("#f8766d","#a3a500","#00bf7d","#00b0f6","#e76bf3"))
#myplot = myplot + facet_wrap(~task_id, ncol=2)
#myplot = myplot + ggtitle("Distribution of Cholesky's kernels duration")
myplot = myplot + xlim(0, 20)
myplot = myplot + xlab("Performance (GFlops)")
myplot = myplot + ylab("Densité")

print(myplot)
dev.off()



