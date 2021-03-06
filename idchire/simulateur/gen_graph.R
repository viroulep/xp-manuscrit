library(ggplot2)

df = read.table("./all_data_simulateur.dat", header=TRUE)
df_8k = subset(df, size==8192)
df = subset(df, size==32768)
df_runtime = read.table("../kastors/all_data.dat", header=TRUE)
df_runtime_8k = subset(df_runtime, size == 8192 & blocksize == 256 & program == "dpotrf_taskdep")
df_runtime = subset(df_runtime, size == 32768 & blocksize == 512 & program == "dpotrf_taskdep")

df_steals = read.table("./all_data_steal_count.dat", header=TRUE)

pdf("simu_min_max_affinity_idchire.pdf", width = 10, height=6)

df_simu_min = subset(df, (model == "IdchireMin" & strat == "RandLoc")
                     | (model == "IdchireMax" & strat == "RandLoc")
                     | model == "IdchireAffinity")

myplot = ggplot(df_simu_min, aes(x=threads, y = gflops))
myplot = myplot + geom_point(aes(colour=model, shape=strat, group=interaction(model,strat)))
myplot = myplot + geom_line(aes(colour=model, group=interaction(model, strat)))
myplot = myplot + guides(colour = guide_legend(override.aes = list(shape = NA)))
#myplot = myplot + expand_limits(y=0)
myplot = myplot + theme(legend.position=c(0.75, 0.25), text = element_text(size=16))
myplot = myplot + scale_colour_discrete(name="Modèle", labels=c("DeuxNiveaux", "Maximum", "Distant"))
myplot = myplot + scale_shape_manual(name="Stratégie de vol", values=c(19, 4))
#myplot = myplot + ggtitle("P d'un Cholesky (N=32768, BS=512) en fonction du modèle et strat.")
myplot = myplot + ylab("Performance (GFlops)")
myplot = myplot + xlab("Nombre de threads")

print(myplot)
dev.off()

pdf("simu_affinity_runtime_idchire.pdf", width = 10, height=6)

df_affinity = subset(df, (model == "IdchireAffinity" & strat == "Affinity")
                     | (model == "IdchireMin" & strat == "RandLoc")
                     | (model == "IdchireMax" & strat == "RandLoc"))

myplot = ggplot(df_affinity, aes(x=threads, y = gflops))
#myplot = myplot + geom_point(aes(colour=model, shape=strat, group=interaction(model,strat)))
myplot = myplot + geom_line(aes(colour=model, group=interaction(model, strat)), linetype = "longdash")
myplot = myplot + geom_line(data=subset(df_runtime, runtime=="clang" | runtime=="libkomp"), aes(colour=runtime))
myplot = myplot + geom_vline(mapping = NULL, data = NULL, xintercept = 64, color="red")
#myplot = myplot + expand_limits(y=0)
myplot = myplot + theme(legend.position=c(0.75, 0.25), text = element_text(size=16))
myplot = myplot + scale_colour_manual(
                    name="Modèle ou support exécutif", labels=c("libOMP", "DeuxNiveaux + Affinity", "Maximum", "Distant", "libKOMP"),
                    values=c("#f8766d", "#a3a500", "#04c07f", "#01b0f6", "#e76bf3"),
                    guide = guide_legend(override.aes = list(linetype = c("solid", "dashed", "dashed", "dashed", "solid")))
                  )
#myplot = myplot + scale_shape_manual(name="Stratégie de vol", values=c(19, 4))
#myplot = myplot + ggtitle("P d'un Cholesky (N=32768, BS=512) en fonction du modèle et strat.")
myplot = myplot + ylab("Performance (GFlops)")
myplot = myplot + xlab("Nombre de threads")

print(myplot)
dev.off()

pdf("simu_affinity_runtime_idchire_0.pdf", width = 10, height=6)

df_affinity = subset(df, (model == "IdchireAffinity" & strat == "Affinity")
                     | (model == "IdchireMin" & strat == "RandLoc")
                     | (model == "IdchireMax" & strat == "RandLoc"))

myplot = ggplot(df_affinity, aes(x=threads, y = gflops))
#myplot = myplot + geom_point(aes(colour=model, shape=strat, group=interaction(model,strat)))
myplot = myplot + geom_line(aes(colour=model, group=interaction(model, strat)), linetype = "longdash")
myplot = myplot + guides(colour = guide_legend(override.aes = list(shape = NA)))
#myplot = myplot + expand_limits(y=0)
myplot = myplot + theme(legend.position=c(0.75, 0.25), text = element_text(size=16))
myplot = myplot + scale_colour_manual(name="Modèle ou support exécutif", labels=c("DeuxNiveaux + Affinity", "Maximum", "Distant"), values=c("#a3a500", "#04c07f", "#01b0f6"))
#myplot = myplot + scale_shape_manual(name="Stratégie de vol", values=c(19, 4))
#myplot = myplot + ggtitle("P d'un Cholesky (N=32768, BS=512) en fonction du modèle et strat.")
myplot = myplot + ylab("Performance (GFlops)")
myplot = myplot + xlab("Nombre de threads")

print(myplot)
dev.off()

pdf("simu_affinity_avg_runtime_idchire.pdf", width = 10, height=6)

df_affinity_avg = subset(df, (model == "IdchireAffinityAVG"))

myplot = ggplot(df_affinity_avg, aes(x=threads, y = gflops))
#myplot = myplot + geom_point(aes(colour=model, shape=strat, group=interaction(model,strat)))
myplot = myplot + geom_line(aes(colour=interaction(model, strat), group=interaction(model, strat)))
myplot = myplot + geom_line(data=subset(df_runtime, runtime=="clang" | runtime=="libkomp"), aes(colour=runtime))
#myplot = myplot + geom_ribbon(data=subset(df_runtime, runtime=="clang" | runtime=="libkomp"), aes(colour=runtime, ymin=gflops-(2*std/iterations), ymax=gflops+(2*std/iterations)))
myplot = myplot + guides(colour = guide_legend(override.aes = list(shape = NA)), fill=guide_legend(override.aes=list(linetype=0, shape='')))
#myplot = myplot + expand_limits(y=0)
myplot = myplot + theme(legend.position=c(0.75, 0.25), text = element_text(size=16))
myplot = myplot + scale_colour_discrete(name="Modèle ou support exécutif", labels=c("libOMP", "DeuxNiveaux/Affinity", "DeuxNiveaux/RandLoc", "libKOMP"))
#myplot = myplot + scale_fill_manual(name="")
#myplot = myplot + scale_shape_manual(name="Stratégie de vol", values=c(19, 4))
#myplot = myplot + ggtitle("P d'un Cholesky (N=32768, BS=512) en fonction du modèle et strat.")
myplot = myplot + ylab("Performance (GFlops)")
myplot = myplot + xlab("Nombre de threads")

print(myplot)
dev.off()

pdf("simu_affinity_8k_runtime_idchire.pdf", width = 10, height=6)

df_affinity_avg = subset(df_8k, ((model == "IdchireAffinityAVG" & strat == "Affinity") | model == "IdchireMin" | model == "IdchireMax"))

myplot = ggplot(df_affinity_avg, aes(x=threads, y = gflops))
#myplot = myplot + geom_point(aes(colour=model, shape=strat, group=interaction(model,strat)))
myplot = myplot + geom_line(aes(colour=interaction(model, strat), group=interaction(model, strat)), linetype="longdash")
myplot = myplot + geom_vline(mapping = NULL, data = NULL, xintercept = 64, color="red")
myplot = myplot + geom_line(data=subset(df_runtime_8k, runtime=="libkomp"), aes(colour=runtime))
#myplot = myplot + expand_limits(y=0)
myplot = myplot + theme(legend.position=c(0.75, 0.25), text = element_text(size=16))
myplot = myplot + scale_colour_manual(
                    name="Modèle ou support exécutif", labels=c("DeuxNiveaux + Affinity", "Maximum", "Distant", "libKOMP"),
                    values=c("#a3a500", "#04c07f", "#01b0f6", "#e76bf3"),
                    guide = guide_legend(override.aes = list(linetype = c("dashed", "dashed", "dashed", "solid")))
                  )
#myplot = myplot + scale_shape_manual(name="Stratégie de vol", values=c(19, 4))
#myplot = myplot + ggtitle("P d'un Cholesky (N=32768, BS=512) en fonction du modèle et strat.")
myplot = myplot + ylab("Performance (GFlops)")
myplot = myplot + xlab("Nombre de threads")

print(myplot)
dev.off()

pdf("simu_affinity_8k_runtime_idchire_ajuste.pdf", width = 10, height=6)

df_affinity_avg = subset(df_8k, ((model == "IdchireAffinityAVG" & strat == "Affinity") | model == "IdchireMax" | model == "IdchireTmp"))
#df_affinity_avg = subset(df_8k, ((model == "IdchireAffinityAVG" & strat == "Affinity") | model == "IdchireMin" | model == "IdchireMax"))

myplot = ggplot(df_affinity_avg, aes(x=threads, y = gflops))
#myplot = myplot + geom_point(aes(colour=model, shape=strat, group=interaction(model,strat)))
myplot = myplot + geom_line(aes(colour=interaction(model, strat), group=interaction(model, strat)), linetype="longdash")
myplot = myplot + geom_line(data=subset(df_runtime_8k, runtime=="libkomp"), aes(colour=runtime))
myplot = myplot + geom_vline(mapping = NULL, data = NULL, xintercept = 64, color="red")
myplot = myplot + guides(colour = guide_legend(override.aes = list(shape = NA)))
#myplot = myplot + expand_limits(y=0)
myplot = myplot + theme(legend.position=c(0.75, 0.25), text = element_text(size=16))
#myplot = myplot + scale_colour_discrete(name="Modèle ou support exécutif")
myplot = myplot + scale_colour_manual(
                    name="Modèle ou support exécutif", labels=c("DeuxNiveaux + Affinity", "Maximum", "Coûts basés sur les chiffres réels", "libKOMP"),
                    values=c("#a3a500", "#04c07f", "#01b0f6", "#e76bf3"),
                    guide = guide_legend(override.aes = list(linetype = c("dashed", "dashed", "dashed", "solid")))
                  )
#myplot = myplot + scale_shape_manual(name="Stratégie de vol", values=c(19, 4))
#myplot = myplot + ggtitle("P d'un Cholesky (N=32768, BS=512) en fonction du modèle et strat.")
myplot = myplot + ylab("Performance (GFlops)")
myplot = myplot + xlab("Nombre de threads")

print(myplot)
dev.off()

pdf("simu_affinity_8k_runtime_idchire_0.pdf", width = 10, height=6)

#df_affinity_avg = subset(df_8k, (model == "IdchireAffinityAVG" | model == "IdchireMin" | model == "IdchireMax" | model == "IdchireTmp"))
df_affinity_avg = subset(df_8k, ((model == "IdchireAffinityAVG" & strat == "Affinity") | model == "IdchireMin" | model == "IdchireMax"))

myplot = ggplot(df_affinity_avg, aes(x=threads, y = gflops))
#myplot = myplot + geom_point(aes(colour=model, shape=strat, group=interaction(model,strat)))
myplot = myplot + geom_line(aes(colour=interaction(model, strat), group=interaction(model, strat)), linetype="longdash")
#myplot = myplot + geom_line(data=subset(df_runtime_8k, runtime=="clang" | runtime=="libkomp"), aes(colour=runtime))
myplot = myplot + guides(colour = guide_legend(override.aes = list(shape = NA)))
#myplot = myplot + expand_limits(y=0)
myplot = myplot + theme(legend.position=c(0.75, 0.25), text = element_text(size=16))
myplot = myplot + scale_colour_manual(name="Modèle ou support exécutif", labels=c("DeuxNiveaux/Affinity", "Maximum", "Distant"), values=c("#a3a500", "#04c07f", "#01b0f6"))
#myplot = myplot + scale_shape_manual(name="Stratégie de vol", values=c(19, 4))
#myplot = myplot + ggtitle("P d'un Cholesky (N=32768, BS=512) en fonction du modèle et strat.")
myplot = myplot + ylab("Performance (GFlops)")
myplot = myplot + xlab("Nombre de threads")

print(myplot)
dev.off()

pdf("simu_all_models_idchire.pdf", width = 10, height=6)

myplot = ggplot(df, aes(x=threads, y = gflops))
myplot = myplot + geom_point(aes(colour=model, shape=strat, group=interaction(model,strat)))
myplot = myplot + geom_line(aes(colour=model, group=interaction(model, strat)))
myplot = myplot + geom_line(data=df_runtime, aes(colour=runtime))
#myplot = myplot + expand_limits(y=0)
myplot = myplot + theme(legend.position=c(0.75, 0.25), text = element_text(size=16))
myplot = myplot + ggtitle("Perf d'un Cholesky (N=32768, BS=512) en fonction du modèle et strat.")
myplot = myplot + ylab("Perf (Gflops)")
myplot = myplot + xlab("Nombre de threads")

print(myplot)
dev.off()

pdf("simu_steal_visits_idchire.pdf", width = 10, height=6)

df_steals=subset(df_steals, strat=="Affinity")

myplot = ggplot(df_steals, aes(x=threads, y = steals_per_task))
#myplot = myplot + geom_point(aes(colour=factor(size)))
myplot = myplot + geom_line(aes(colour=factor(size)))
#myplot = myplot + geom_line(aes(colour=factor(size), y=visits_per_task/180))
#myplot = myplot + geom_line(data=df_runtime, aes(colour=runtime))
#myplot = myplot + expand_limits(y=0)
myplot = myplot + theme(legend.position=c(0.25, 0.75), text = element_text(size=16))
#myplot = myplot + ggtitle("Visites par tache")
myplot = myplot + scale_colour_discrete(name="Tailles : Matrice x Bloc", labels=c("8192x256", "32768x512"))
myplot = myplot + ylab("Requêtes de vol par tâche")
myplot = myplot + xlab("Nombre de threads")

print(myplot)
dev.off()
