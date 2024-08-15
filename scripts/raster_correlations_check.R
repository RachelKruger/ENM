# Use this correlation checker to check for correlations among predictor variables.
# I (Rachel) set a limit of 95% correlation to get rid of a predictor variable.
# To decide which predictor variable to get rid of, I tried to minimize the number of 
# predictor variables being excluded while considering the biological importance of 
# the predictor variables.
# install.packages("ENMTools")
library(ENMTools)
library(raster)

bio1 <- raster("data/pred_var/2deg_clip/bio1.tif")
bio2 <- raster("data/pred_var/2deg_clip/bio2.tif")
bio3 <- raster("data/pred_var/2deg_clip/bio3.tif")
bio4 <- raster("data/pred_var/2deg_clip/bio4.tif")
bio5 <- raster("data/pred_var/2deg_clip/bio5.tif")
bio6 <- raster("data/pred_var/2deg_clip/bio6.tif")
bio7 <- raster("data/pred_var/2deg_clip/bio7.tif")
bio8 <- raster("data/pred_var/2deg_clip/bio8.tif")
bio9 <- raster("data/pred_var/2deg_clip/bio9.tif")
bio10 <- raster("data/pred_var/2deg_clip/bio10.tif")
bio11 <- raster("data/pred_var/2deg_clip/bio11.tif")
bio12 <- raster("data/pred_var/2deg_clip/bio12.tif")
bio13 <- raster("data/pred_var/2deg_clip/bio13.tif")
bio14 <- raster("data/pred_var/2deg_clip/bio14.tif")
bio15 <- raster("data/pred_var/2deg_clip/bio15.tif")
bio16 <- raster("data/pred_var/2deg_clip/bio16.tif")
bio17 <- raster("data/pred_var/2deg_clip/bio17.tif")
bio18 <- raster("data/pred_var/2deg_clip/bio18.tif")
bio19 <- raster("data/pred_var/2deg_clip/bio19.tif")

layers.stack <- raster::stack(bio1, bio2, bio3, bio4, bio5, bio6, bio7, bio8, bio9, bio10, bio11, bio12, bio13, bio14, bio15, bio16, bio17, bio18, bio19)

# This step will take a while! Especially if you have many variables.
correlations <- raster.cor.matrix(layers.stack)

write.csv(correlations, "data/pred_var/bioclim_corr.csv")
