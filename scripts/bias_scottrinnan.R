# Bias file a la Scott Rinnan----

# Load in libraries----
library(raster) # spatial data manipulation
library(MASS) # for 2D kernel density function
library(magrittr) # for piping functionality, i.e., %>%
#library(maptools) # reading shapefiles
# Instead of maptools maybe I can use sf?
library(sf)
library(dplyr)


# Load in species occurrence data and delete duplicates----
lonocc <- read.csv("data/occurrence_data/lon_6-28-24.csv")[,-1]
lonocc <- lonocc %>% distinct()
write.csv(lonocc,"data/occurrence_data/lon_6-28-24_nodup.csv")

calocc <- read.csv("data/occurrence_data/cal_6-28-24.csv")[,-1]
calocc <- calocc %>% distinct()
write.csv(calocc,"data/occurrence_data/cal_6-28-24_nodup.csv")
# Load in environmental variables----
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

# Brick the environmental variables into one brick
climdat <- brick(bio1, bio2, bio5, bio6, bio7, bio9, bio10, bio12, bio13, bio14, bio16, bio17, bio18, bio19, bdod, cfvo, clay, nitrogen, ocd, phh2o, sand, silt, soc)

# Rasterize these
occur.ras <- rasterize(calocc, climdat, 1)
plot(occur.ras)

presences <- which(values(occur.ras) == 1)
pres.locs <- coordinates(occur.ras)[presences, ]

dens <- kde2d(pres.locs[,1], pres.locs[,2], n = c(nrow(occur.ras), ncol(occur.ras)))
dens.ras <- raster(dens)
plot(dens.ras)

dens.ras.1 <- resample(dens.ras,climdat)
writeRaster(dens.ras.1, "data/bias_cal-6-27-24.grd", format="raster", overwrite = T)


