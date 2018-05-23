
library(dplyr);
readtrace <- function (filename)
{
   df <- read.csv(filename, header=TRUE, sep=",", strip.white=TRUE);
   df = subset(df, Name != "init")
   df <- df %>% filter((Explicit==1)) %>% as.data.frame();
   df$Start <- df$Start*1e-9; # Convert ns to second
   df$End <- df$End*1e-9;
   df$Duration <- df$Duration*1e-9;
   df;
}
df <- readtrace("./tasks.csv");
head(df);

library(ggplot2);
require(grid);

# helper: convert s to the date
date<-function(d) { as.POSIXct(d, origin="1970-01-01"); }

pdf("gantt_32768_512.pdf", width = 10, height=4)
# theplot
myplot=ggplot() +
  theme_bw(base_size=16) +
   xlab("Time [s]") +
   ylab("Thread Identification") +
   scale_fill_brewer(palette = "Set1") +
   theme (
       plot.margin = unit(c(0,0,0,0), "cm"),
       #legend.spacing = unit(.1, "line"),
       panel.grid.major = element_blank(),
       #panel.spacing=unit(0, "cm"),
       panel.grid=element_line(0, "cm"),
       legend.position = "bottom",
       legend.title =  element_text("Helvetica")
   ) +
   guides(fill = guide_legend(nrow = 1)) +
   scale_fill_manual(values=c("#33cc00", "#ffff00", "#ff0000", "#3366ff")) +
   geom_rect(data=df, alpha=1, aes(fill=Name,
                                 xmin=date(Start),
                                 xmax=date(End),
                                 ymin=Resource,
                                 ymax=Resource+0.9)) +
   scale_y_reverse();
print(myplot)
dev.off()
