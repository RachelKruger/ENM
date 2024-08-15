# PCA
library(raster)
# Load in data----
loncal <- read.csv('data/pca/loncal_envdata.csv')
loncal <- na.omit(loncal)
loncal <- subset(loncal, select = -c(long, lat))

# RUN PCA
pca <- prcomp(loncal[,2:ncol(loncal)], scale=T)
pca

plot(pca$x[,1], pca$x[,2])


pca.var <- pca$sdev^2
pca.var.per <- round(pca.var/sum(pca.var)*100, 1)

barplot(pca.var.per, main="Scree Plot", xlab="Principal Component", ylab="Percent Variation")


library(ggplot2)

pca_scores <- pca$x
species <- loncal[, 1]
par(mar=c(5,6,4,1)+.1)
pca_plot <- plot(pca_scores[, 1], pca_scores[, 2], 
     col = ifelse(species == "calycinus", "#8B8BDB", "#FF9C00"), 
     pch = ifelse(species == "calycinus", 17, 16),
     xlab = paste("PC1 - ", pca.var.per[1], "%", sep=""),
     ylab = paste("PC2 - ", pca.var.per[2], "%", sep=""),
     cex.lab=2, cex.axis=2)
pca_plot
legend("topright", 
       legend = c("CAL", "LON"), 
       col = c("#8B8BDB", "#FF9C00"), 
       pch = c(17,16), 
       bty = "n", 
       pt.cex = 2, 
       cex = 2, 
       text.col = "black", 
       horiz = F , 
       inset = c(0.1, 0.1))



loading_scores1 <- pca$rotation[,1]
loading_scores2 <- pca$rotation[,2]
bioclim_scores <- abs(loading_scores1)
bioclim_scores_ranked <- sort(bioclim_scores, decreasing=T)
top_10_vars <- names(bioclim_scores_ranked[1:10])

pca$rotation[top_10_vars,1]
loadingscore <- as.list(loading_scores)
pca$rotation
loadingscore
write.csv(loadingscore, "data/pca/figs/loadingscores.csv")
loading_scores1
loading_scores2

# Discriminant Function Analysis----
library(MASS)
loncal <- read.csv('data/pca/loncal_envdata.csv')
loncal <- na.omit(loncal)
loncal <- subset(loncal, select = -c(long, lat))
loncal$species <- as.factor(loncal$species)




## Conducting LDA----
loncal_lda <- lda(species ~ bio_1+bio_2+bio_5+bio_6+bio_7+bio_9+bio_10+bio_12+bio_13+bio_14+bio_16+bio_17+bio_18+bio_19, data = loncal)
## Predicting groups----
loncal_lda$scores <- predict(loncal_lda, newdata=loncal[,c(2:ncol(loncal))]
                              )$class

## Creating a table of real vs. predicted----

predicttable <- table(loncal_lda$scores, loncal[,1])

# loncal_lda_predict calycinus longiflorus
# calycinus         177          28
# longiflorus        28         860

## Assessing accuracy of predictions----
accuracy1 <- sum(diag(predicttable))/sum(predicttable)
accuracy1
summary(loncal_lda)
# I got an accuracy of 94.88%!

## Plot histogram----


lda_histogram <- plot(loncal_lda, type="both", sep = T)
                      #col = ifelse(loncal_lda$lev == "calycinus", "#c99700", "#239c3a"))
                      #col = factor(loncal_lda$lev))

legend("topleft", 
       legend = c("CAL", "LON"), 
       col = c("#c99700", "#239c3a"), 
       pch = c(15,16), 
       bty = "n", 
       pt.cex = 2, 
       cex = 1.5, 
       text.col = "black", 
       horiz = F , 
       inset = c(0.1, 0.1))

lda_values <- predict(loncal_lda)$x
groups <- loncal$species  # Replace 'your_data' and 'Group' with your actual data and grouping variable
colors <- c("#c99700", "#239c3a")
hist(lda_values[, 1], breaks = 20, col = rgb(1, 1, 1, 0), border = NA, xlab = "LDA Score", main = "LDA Histograms", ylim = c(0, max(table(cut(lda_values[, 1], breaks = 20))) * 2))
for (i in unique(groups)) {
        hist(lda_values[groups == i, 1], breaks = 20, col = colors[i], border = NA, add = TRUE)
}

# Crossvalidate
loncal_lda2 <- lda(species ~ bio_1+bio_2+bio_5+bio_6+bio_7+bio_9+bio_10+bio_12+bio_13+bio_14+bio_16+bio_17+bio_18+bio_19, data = loncal, CV = T)
loncal_lda_predict2 <- predict(loncal_lda2, newdata=loncal[,c(2:ncol(loncal))]
)$class
crossvaltable <- table(loncal_lda2$class, loncal[,1])

# MANOVA----
loncal <- read.csv('data/pca/loncal_envdata.csv')
loncal <- na.omit(loncal)
loncal <- subset(loncal, select = -c(long, lat))


res.man <- manova(cbind(bio_1,bio_2,bio_5,bio_6,bio_7,bio_9,bio_10,bio_12,bio_13,bio_14,bio_16,bio_17,bio_18,bio_19) ~ species, data = loncal)
summary(res.man)

# Wilks lambda----
manovasummary <- summary(res.man, test='Wilks')
#            Df   Wilks approx F num Df den Df    Pr(>F)    
# species      1 0.29208   186.62     14   1078 < 2.2e-16 ***
#         Residuals 1091 

manova <- summary.aov(res.man)
manova
output <- capture.output(manova)
output
write.csv(output, "data/manova.csv")

# Box plots----
par(mar=c(5,6,4,1)+.1)
bio1box <- boxplot(bio_1 ~ species, data = loncal)
bio2box <- boxplot(bio_2 ~ species, data = loncal)
bio5box <- boxplot(bio_5 ~ species, data = loncal, ylab = "Max Temperature of Warmest Month", cex.axis=2, cex.lab=2)
bio6box <- boxplot(bio_6 ~ species, data = loncal)
bio7box <- boxplot(bio_7 ~ species, data = loncal)
bio9box <- boxplot(bio_9 ~ species, data = loncal)
bio10box <- boxplot(bio_10 ~ species, data = loncal)
bio12box <- boxplot(bio_12 ~ species, data = loncal)

bio13box <- boxplot(bio_13 ~ species, data = loncal)
bio14box <- boxplot(bio_14 ~ species, data = loncal)
bio16box <- boxplot(bio_16 ~ species, data = loncal, ylab = "Precipitation of Wettest Quarter", cex.axis=2, cex.lab=2)
bio17box <- boxplot(bio_17 ~ species, data = loncal)
bio18box <- boxplot(bio_18 ~ species, data = loncal)
bio19box <- boxplot(bio_19 ~ species, data = loncal)

# Descriptives----
install.packages('pastecs')
library(pastecs)
descriptives <- by(loncal$bio_1, loncal$species, stat.desc, basic=F) # This needs package pastecs
descriptives

homcov <- by(loncal[2:15], loncal$species, cov)
homcov
