library(ggplot2)

df = read.table("./all_data.dat", header=TRUE)

pdf("simu_vs_runtime_brunch.pdf", width = 10, height=6)

myplot = ggplot(df, aes(x=Threads, y = Gflops))
myplot = myplot + geom_point(aes(colour=Runtime))
myplot = myplot + geom_line(aes(colour=Runtime))
#myplot = myplot + expand_limits(y=0)
myplot = myplot + theme(legend.position=c(0.75, 0.25))
myplot = myplot + ggtitle("Perf d'un Cholesky (N=8192, BS=256) en fonction du runtime, brunch.")
myplot = myplot + ylab("Perf (Gflops)")
myplot = myplot + xlab("Nombre de threads")

print(myplot)
dev.off()
