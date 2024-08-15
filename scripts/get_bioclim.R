# From https://rsh249.github.io/spatial_bioinformatics/worldclim.html
# Load library
library('dismo')
library('rgdal')

# For 30 arc-sec resolution, you need to download by tile...
env1 <- getData("worldclim", var="bio", res=0.5, download = T, lat=38.5, lon=-122)
env2 <- getData("worldclim", var="bio", res=0.5, download = T, lat=38.5, lon=-114)
env3 <- getData("worldclim", var="bio", res=0.5, download = T, lat=29.5, lon=-122)
env4 <- getData("worldclim", var="bio", res=0.5, download = T, lat=29.5, lon=-114)

# Merge the four tiles into one rasterstack called envall
env12<-merge(env1, env2)
env123<-merge(env12, env3)
envall<-merge(env123, env4)


# Define extent of study region (cropping)
e<-extent(c(-121.534367, -114.662118, 29.986786, 38.002557))

# Crop bioclim data to this extent
Bio<-crop(envall, e)

# Write rasters as GeoTiffs and save to computer
for (i in 1:nlayers(Bio)){
  # writeRaster is a function that will write each layer with the correct name. As the 
  # loop iterates through, each layer in turn becomes "i". For the names, we will
  # use the names from any of the rasterstacks we downloaded from worldclim
  writeRaster(Bio[[i]], filename = names(env1[[i]]), format='GTiff', overwrite=T)
}

# Load Occurrences and Check on environmental layer to see if it makes sense
library(sf)
library(tidyverse)
library(mapview)

lon_cal_obs <- read.csv("lon_cal_maxent.csv")
lon_cal <- st_as_sf(lon_cal_obs, coords = c("longitude", "latitude"),
                    crs = "wgs84")