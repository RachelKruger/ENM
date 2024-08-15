# From https://scottrinnan.wordpress.com/2015/08/31/how-to-construct-a-bias-file-with-r-for-use-in-maxent-modeling/

library(raster) # spatial data manipulation
library(MASS) # for 2D kernel density function
library(magrittr) # for piping functionality, i.e., %>%
library(sf)
# install.packages("ecospat")
library(ecospat)

# Gather climate/predictorvariables and brick 'em

bio1 <- raster("data/pred_var/2deg_clip/bio1.tif")
bio2 <- raster("data/pred_var/2deg_clip/bio2.tif")
bio5 <- raster("data/pred_var/2deg_clip/bio5.tif")
bio6 <- raster("data/pred_var/2deg_clip/bio6.tif")
bio7 <- raster("data/pred_var/2deg_clip/bio7.tif")
bio9 <- raster("data/pred_var/2deg_clip/bio9.tif")
bio10 <- raster("data/pred_var/2deg_clip/bio10.tif")
bio12 <- raster("data/pred_var/2deg_clip/bio12.tif")
bio13 <- raster("data/pred_var/2deg_clip/bio13.tif")
bio14 <- raster("data/pred_var/2deg_clip/bio14.tif")
bio16 <- raster("data/pred_var/2deg_clip/bio16.tif")
bio17 <- raster("data/pred_var/2deg_clip/bio17.tif")
bio18 <- raster("data/pred_var/2deg_clip/bio18.tif")
bio19 <- raster("data/pred_var/2deg_clip/bio19.tif")
bdod <- raster("data/pred_var/2deg_clip/bdod.tif")
cfvo <- raster("data/pred_var/2deg_clip/cfvo.tif")
clay <- raster("data/pred_var/2deg_clip/clay.tif")
nitrogen <- raster("data/pred_var/2deg_clip/nitrogen.tif")
ocd <- raster("data/pred_var/2deg_clip/ocd.tif")
phh2o <- raster("data/pred_var/2deg_clip/phh2o.tif")
sand <- raster("data/pred_var/2deg_clip/sand.tif")
silt <- raster("data/pred_var/2deg_clip/silt.tif")
soc <- raster("data/pred_var/2deg_clip/soc.tif")

# Bricking will take several minutes
env <- stack(bio1, bio2, bio5, bio6, bio7, bio9, bio10, bio12, bio13, bio14, bio16, bio17, bio18, bio19, bdod, cfvo, clay, nitrogen, ocd, phh2o, sand, silt, soc)

occ <- read.csv("data/occurrence_data/lon_6-6-24_enmeval.csv")[,-1]

## MESSING AROUND
library(dplyr)

newocc <- occ %>% distinct()
#make a bias file

occur.ras <- rasterize(occ, env, 1)
plot(occur.ras)

presences <- which(values(occur.ras) == 1)
pres.locs <- coordinates(occur.ras)[presences, ]

dens <- kde2d(pres.locs[,1], pres.locs[,2], n = c(nrow(occur.ras), ncol(occur.ras)), lims = c(extent(env)[1], extent(env)[2], extent(env)[3], extent(env)[4]))
dens.ras <- raster(dens, env)
dens.ras2 <- resample(dens.ras, env)
plot(dens.ras2)

writeRaster(dens.ras2, "data/occurrence_data/cal_biasfile_v2.asc", overwrite = TRUE)


# length(which(!is.na(values(subset(env, 1)))))
# 
# bg <- xyFromCell(dens.ras2, sample(which(!is.na(values(subset(env, 1)))), 10000, prob=values(dens.ras2)[!is.na(values(subset(env, 1)))]))
# colnames(bg) <- colnames(occ)
# enmeval_results <- ENMevaluate(occ, env, bg, tune.args = list(fc = c("L","LQ","H", "LQH", "LQHP", "LQHPT"), rm = 1:5), partitions = "randomkfold", partition.settings = list(kfolds = 10), algorithm = "maxnet")
# occ
# bg
# occur.sfenmeval_results@results
# 
# write.csv(enmeval_results@results, "cal_enmeval_results.csv")
# 
# 
# 
# # # Get the occurrence data
# # # Occurrence data csv must have only two columns. "longitude" and "latitude" in that order
# # loc <- read.csv("data/occurrence_data/lon_6-6-24_enmeval.csv")
# # 
# # #Rasterize
# # occur.ras <- rasterize(loc, climdat, 1)
# # plot(occur.ras)
# # 
# # # Create bias layer - density raster
# # presences <- which(values(occur.ras) == 1)
# # pres.locs <- coordinates(occur.ras)[presences, ]
# # 
# # dens <- kde2d(pres.locs[,1], pres.locs[,2], n = c(nrow(occur.ras), ncol(occur.ras)))
# # dens.ras <- raster(dens)
# # plot(dens.ras)
# # 
# # # Need to resample or else the bias file(dens.ras) will not be in the same resolution as the occurrence file (occur.ras)
# # dens.ras.2 <- raster::resample(dens.ras, occur.ras, method="bilinear", filename="data/occurrence_data/dens_ras_lon.tif", overwrite=T)
# # 
# # 
# # writeRaster(dens.ras.2, "data/occurrence_data/lon_bias.tif", overwrite=T)
# # 
# # f <- "data/occurrence_data/lon_bias.tif"
# # r <- raster(f)
# # writeRaster(r, "data/occurrence_data/lon_bias.asc", format = "ascii", overwrite=T)
# # plot(r)
