## ----echo=FALSE-------------------------------------------------------------
library(MASS)
library(klaR)
library(class)
library(factoextra)
library(labelled)
library(Hmisc)
library(FactoMineR)
library(DescTools)


## ----setup, include=FALSE---------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, fig.width = 12,fig.height = 4)


## ---------------------------------------------------------------------------
load("D:/STDV 1/ANALYSEDEDONNEES/PROJET CLUSTERING/states.RData")
data<-states.data


## ---------------------------------------------------------------------------
head(data,n=10)
summary(data)


## ---------------------------------------------------------------------------
names(data)
names(data)<-c('Pop_Total','Immigration_dom_net','Am_migration_avec_etranger',
               'Immigration_inter_net','Taux_naissance','Taux_mortalite','Pop_moins_65','Pop_plus_65')


## ---------------------------------------------------------------------------
ggplot(data, aes(x=Pop_moins_65)) + 
  geom_histogram(aes(y = ..density..),
                 colour = 1, fill = "white",bins=10) +
  geom_density(lwd = 1, colour = 4,
               fill = 4, alpha = 0.25)+ggtitle('Histogram Pop moins de 65 ans')

ggplot(data, aes(x=Pop_plus_65)) + 
  geom_histogram(aes(y = ..density..),
                 colour = 1, fill = "white",bins=10) +
  geom_density(lwd = 1, colour = 4,
               fill = 4, alpha = 0.25)+ggtitle('Histogram Pop plus de 65 ans')

ggplot(data, aes(x=Taux_naissance)) + 
  geom_histogram(aes(y = ..density..),
                 colour = 1, fill = "white",bins=20) +
  geom_density(lwd = 1, colour = 4,
               fill = 4, alpha = 0.25)+ggtitle('Histogram Taux de naissance')

ggplot(data, aes(x=Taux_mortalite)) + 
  geom_histogram(aes(y = ..density..),
                 colour = 1, fill = "white",bins=20) +
  geom_density(lwd = 1, colour = 4,
               fill = 4, alpha = 0.25)+ggtitle('Histogram Taux de mortalite')

ggplot(data, aes(x=Immigration_dom_net)) + 
  geom_histogram(aes(y = ..density..),
                 colour = 1, fill = "white",bins=20) +
  geom_density(lwd = 1, colour = 4,
               fill = 4, alpha = 0.25)+ggtitle('Histogram Immigration domicile nette')

ggplot(data, aes(x=Immigration_inter_net)) + 
  geom_histogram(aes(y = ..density..),
                 colour = 1, fill = "white",bins=20) +
  geom_density(lwd = 1, colour = 4,
               fill = 4, alpha = 0.25)+ggtitle('Histogram Immigration Internationale nette')


## ---------------------------------------------------------------------------
statecor <- cor(data,method="spearman")#Spearman test robuste
statecor

## ---------------------------------------------------------------------------
library(corrplot)
corrplot(as.matrix(statecor), method='color', addCoef.col = "black", type="lower", order="hclust", tl.col="black", tl.srt=45,title='Matrice de corrélation')


## ---------------------------------------------------------------------------
data<-data[2:8]
datascale=scale(data)


## ----echo=FALSE-------------------------------------------------------------
library(cluster)
library(fpc)


## ---------------------------------------------------------------------------
datascale.kmean=kmeansruns(datascale, krange=2:12)
datascale.kmean$cluster
datascale.kmean$bestk


## ---------------------------------------------------------------------------
statecluster1=as.data.frame(which(datascale.kmean$cluster==1))
statecluster2=as.data.frame(which(datascale.kmean$cluster==2))


## ---------------------------------------------------------------------------
datascale.kmedo=pam(datascale, k=2, metric="euclidean", stand=FALSE)


## ---------------------------------------------------------------------------
library(cluster)
library(factoextra)


## ---------------------------------------------------------------------------
fviz_nbclust(datascale, pam, method = "silhouette", k.max=12) +
geom_vline(xintercept = 2, linetype = 2)


## ---------------------------------------------------------------------------
statecluster11=as.data.frame(which(datascale.kmedo$clustering==1))
statecluster22=as.data.frame(which(datascale.kmedo$clustering==2))


## ---------------------------------------------------------------------------
library(ggdendro)
library(ggplot2)
library(dendextend)


## ---------------------------------------------------------------------------
datascale.dist = dist(datascale)
datascale.ag = hclust(datascale.dist,method="complete")


## ---------------------------------------------------------------------------
datascale.dist = dist(datascale,method="euclidean", diag=FALSE) #Calcul de la matrice de distance
datascale.ag = hclust(datascale.dist,method="ward.D") #HAC avec comme méthode d'agglomération entre cluster la méthode ward.d
ggdendrogram(datascale.ag, labels = TRUE)+ggtitle('Dendogramme')


## ---------------------------------------------------------------------------
inertie <- sort(datascale.ag$height, decreasing = TRUE)
plot(inertie[1:50], type = "s", xlab = "Nombre de classes", ylab = "Inertie")
xtick<-seq(0, 50, by=2)
axis(side=1, at=xtick)


## ---------------------------------------------------------------------------
ggplot(color_branches(datascale.ag, k = 5), labels = TRUE) +ggtitle('Dendogramme')
fviz_dend(datascale.ag, k = 2, show_labels = TRUE, rect = TRUE)

