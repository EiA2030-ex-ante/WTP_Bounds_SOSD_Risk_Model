# Hypothetical Comparisons ---------------------------------------------------

# Theoretical graphs ------------------------------------------------------------

# Truncated normal -----------------------
library(truncnorm)

seed(232)

g <- rtruncnorm (n=1000,a=4,b=8, mean=6,sd=0.8 )
q <- rtruncnorm (n=1000,a=4,b=8, mean=5,sd=1 )
f <- rtruncnorm (n=1000,a=3,b=9, mean=5,sd=2 )
df <- data.frame(x = c(g, q, f),Scenarios = factor(rep(c("G","Q","F"), c(1000,1000,1000))))
df <- df[order(df$x), ]

df$ecdf <- ave(df$x, df$Scenarios, FUN=function(x) seq_along(x)/length(x))

library(ggplot2)
stochasticdominance=ggplot(df, aes(x, ecdf, colour =   Scenarios,linetype=Scenarios)) + 
  geom_line(lwd=c(1.5))+
  scale_linetype_manual(values = c(1,2,3))+
  # theme(axis.ticks = element_blank(),axis.text.x = element_blank()) +
  xlab("Yield (tons/ha)") +
  ylab("Cumulative probability") +
  scale_color_manual(values = c("grey","black","black"))+
  theme(panel.grid.major.x = element_blank())+
  theme(panel.grid.minor.x = element_blank())
previous_theme <- theme_set(theme_bw())
stochasticdominance

ggsave("code/Hypothetical/Figure_stochasticdominance_truncated_normal.png",dpi=300)

# Data for stochastic dominance comparisons ------------------------------------
ID=rep(1,1000)
g=as.data.frame(g*1000)
q=as.data.frame(q*1000)
f=as.data.frame(f*1000)
Rep=1:nrow(g)
Area=rep(1,1000)


QvsG=data.frame(ID,Rep,Area,q,g)
export(QvsG,colNames=F,"code/Hypothetical/QvsG.xlsx")

QvsF=data.frame(ID,Rep,Area,q,f)
export(QvsF,colNames=F,"code/Hypothetical/QvsF.xlsx")

FvsG=data.frame(ID,Rep,Area,f,g)
export(FvsG,colNames=F,"code/Hypothetical/FvsG.xlsx")

# Experiments -------------

# G vs Q: Q as baseline -----------------
GvsQ=data.frame(ID,Rep,Area,g,q)
export(GvsQ,colNames=F,"code/Hypothetical/GvsQ.xlsx")


## F vs Q: Q as baseline ---------------
FvsQ=data.frame(ID,Rep,Area,f,q)
export(FvsQ,colNames=F,"code/Hypothetical/FvsQ.xlsx")

## G vs F: F as baseline ----------------
GvsF=data.frame(ID,Rep,Area,g,f)
export(GvsF,colNames=F,"code/Hypothetical/GvsF.xlsx")


