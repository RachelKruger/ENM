# Adapted from https://rsh249.github.io/spatial_bioinformatics/worldclim.html

# The purpose of this R script is to download all 19 BioClim variables as rasters,
# and crop them to an extent of your choosing. For use as predictor variables in 
# your ecological niche model
# 
# I've provided the files you will need to go through this. If you want to do this
# with your own data, and want to learn how to create a shapefile of a buffer around
# your occurrence points, I am working on creating a tutorial for that in the free 
# software QGIS. So far, I have a simple txt file with instructions (titled 
# "Creating Buffer" in the materials I posted), but they may not make sense! I'll 
# work on getting a more graphical tutorial. It's pretty quick and simple once you
# know what you're doing. In the meantime, please feel free to ask me for assistance!
# 
# 
# Make sure ALL of these files are located in ONE FOLDER (these are the files included
# in the "buffer" folder I put up):
# buffer_loncal_v1.cpg
# buffer_loncal_v1.dbf
# buffer_loncal_v1.prj
# buffer_loncal_v1.qmd
# buffer_loncal_v1.shp
# buffer_loncal_v1.shx
#
# Even though you will only call upon the .shp file, R needs all those files to be in
# the same location!
#
# Use your own preferred directories in your R Project
#
# Let me know if you have any questions! rkruger1@binghamton.edu



# 1. Load library----
# install.packages("sf")
# install.packages("terra")
# install.packages("raster")
# install.packages("geodata")
library(sf)
library(terra)
library(raster)
library(geodata)

# 2. Download climate data----
# Uses 'geodata' package
# For 30 arc-sec resolution, you need to download by tile...
# This is how it's formatted: env1 <- worldclim_tile(this is the one to use to download
# by tile rather than country or world)(var = "bio" for bioclim data, lon=west point, 
# lat=north point, path="directory you want to save"). 
# Make sure you have your buffer extent BEFORE doing this so that you can download tiles
# that extend BEYOND the limits of your buffer.

env1 <- worldclim_tile(var = "bio", lon=-123, lat=39.5, path = "data/pred_var/raw_bioclim")
env2 <- worldclim_tile(var = "bio", lon=-113.5, lat=39.5, path = "data/pred_var/raw_bioclim")
env3 <- worldclim_tile(var = "bio", lon=-123, lat=28.5, path = "data/pred_var/raw_bioclim")
env4 <- worldclim_tile(var = "bio", lon=-113.5, lat=28.5, path = "data/pred_var/raw_bioclim")


# 3. Merge into rasterstack----
# Merge the four tiles into one rasterstack called envall
# This will take just a couple minutes
env12<-merge(env1, env2)
env123<-merge(env12, env3)
envall<-merge(env123, env4)

# 4. Define extent of study region (cropping)----
## Import shapefile to crop to----

### Read in Shapefile----
# Remember, this is the only file you'll read in, but it requires those other files 
# with the same name but different file extensions to be present in the same folder!
shapefile <- st_read("data/buffer/loncal_2deg_7-1-24.shp")

### Transform to be same CRS as envall raster----
shapefile <- st_transform(shapefile, crs(envall))

## Crop envall raster to buffer extent----
cropped_raster <- crop(envall, extent(st_bbox(shapefile)))
# Mask it so that it actually crops to the buffer shape rather than just the maximum 
# bbox or whatever
Bio <- mask(cropped_raster, shapefile)


# 5. Write raster files of cropped data----

## Create output folder for For Loop to write to----
output_folder <- "data/pred_var/2deg_clip"

## Write rasters as GeoTiffs and save to computer----
for (i in 1:nlyr(Bio)){
  # writeRaster is a function that will write each layer with the correct name. As
  # the loop iterates through, each layer in turn becomes "i". For the names, we will
  # use the names from any of the rasterstacks we downloaded from worldclim
  output_filename <- file.path(output_folder, paste0(names(env1)[i], ".tif")) ### RECHECK THIS WITH .asc! It was .tif
  terra::writeRaster(Bio[[i]], filename = output_filename, overwrite=T)

# This is to test for NA values - I'm still trying to figure this out, but it doesn't
# change anything in the files, I don't think
if (any(is.na(values(Bio[[i]]))) | any(!is.finite(values(Bio[[i]])))) {
  warning(paste("Layer", names(env1)[i], "contains NA or non-finite values"))
}

# This will plot each Bioclim layer one at a time
  plot(Bio[[i]], main = paste("Layer", names(env1)[i]))
}

# This is something to do with the NA values, I think? Also doens't change anything.
# You don't need to run these lines to get your raster files
test_raster <- rast(file.path(output_folder, paste0(names(env1)[1], ".tif")))
plot(test_raster, main = paste("Layer", names(env1)[1], "from file"))




###### IGNORE ALL THIS BELOW

# # Load Occurrences and Check on environmental layer to see if it makes sense
# library(sf)
# library(tidyverse)
# library(mapview)
# 
# lon_cal_obs <- read.csv("lon_cal_maxent.csv")
# lon_cal <- st_as_sf(lon_cal_obs, coords = c("longitude", "latitude"),
#                     crs = "wgs84")

library(raster)
library(terra)
bio1rast <- rast('data/pred_var/2deg_clip/bio_1.asc')
bdodrast <- rast('data/pred_var/2deg_clip/bdod.asc')
cfvorast <- rast('data/pred_var/2deg_clip/cfvo.asc')
clayrast <- rast('data/pred_var/2deg_clip/clay.asc')
nitrogenrast <- rast('data/pred_var/2deg_clip/nitrogen.asc')
elevrast <- rast('data/pred_var/2deg_clip/elev.asc')
bio2rast <- rast('data/pred_var/2deg_clip/bio_2.asc')
ocdrast <- rast('data/pred_var/2deg_clip/ocd.asc')
phrast <- rast('data/pred_var/2deg_clip/phh2o.asc')
socrast <- rast('data/pred_var/2deg_clip/soc.asc')



plot(socrast)
