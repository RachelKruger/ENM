# Adapted from Josh Banta (joshbanta.com)

library(raster)

# Rasters I want to adjust here (Make sure everything is in ascii format. 
# See R file "C:\Users\Rachel Kruger\OneDrive - Binghamton University\Documents\Binghamton 2023-2024\enm\Bioclim_tif_to_ascii.R" 
# for how to convert from Tiff to ascii):
bdod <- raster("data/pred_var/clip/bdod1.asc")
cfvo <- raster("data/pred_var/clip/cfvo1.asc")
clay <- raster("data/pred_var/clip/clay1.asc") # THIS IS 5-15cm!!!
nitrogen <- raster("data/pred_var/clip/nitrogen1.asc")
ocd <- raster("data/pred_var/clip/ocd1.asc")
phh2o <- raster("data/pred_var/clip/phh2o1.asc")
sand <- raster("data/pred_var/clip/sand1.asc")
silt <- raster("data/pred_var/clip/silt1.asc")
soc <- raster("data/pred_var/clip/soc1.asc")
vpdmin <- raster("data/pred_var/clip/vpdmin.asc")
vpdmax <- raster("data/pred_var/clip/vpdmax.asc")

#raster I want it to match here:
bio1 <- raster("data/pred_var/109_extent/bioclim_asc/bio1.asc")

#now you can resample your rasters to be exactly like your target raster
bdod1 <- resample(bdod, bio1)
cfvo1 <- resample(cfvo, bio1)
clay1 <- resample(clay, bio1) # THIS IS 5-15cm!!!
nitrogen1 <- resample(nitrogen, bio1)
ocd1 <- resample(ocd, bio1)
phh2o1 <- resample(phh2o, bio1)
sand1 <- resample(sand, bio1)
silt1 <- resample(silt, bio1)
soc1 <- resample(soc, bio1)
vpdmin1 <- resample(vpdmin, bio1)
vpdmax1 <- resample(vpdmax, bio1)

# Write the rasters
writeRaster(bdod1, "data/pred_var/109_extent/isric/bdod2.asc", overwrite = TRUE)
writeRaster(cfvo1, "data/pred_var/109_extent/isric/cfvo2.asc", overwrite = TRUE)
writeRaster(clay1, "data/pred_var/109_extent/isric/clay2.asc", overwrite = TRUE) # THIS IS 5-15cm!!!
writeRaster(nitrogen1, "data/pred_var/109_extent/isric/nitrogen2.asc", overwrite = TRUE)
writeRaster(ocd1, "data/pred_var/109_extent/isric/ocd2.asc", overwrite = TRUE)
writeRaster(phh2o1, "data/pred_var/109_extent/isric/phh2o2.asc", overwrite = TRUE)
writeRaster(sand1, "data/pred_var/109_extent/isric/sand2.asc", overwrite = TRUE)
writeRaster(silt1, "data/pred_var/109_extent/isric/silt2.asc", overwrite = TRUE)
writeRaster(soc1, "data/pred_var/109_extent/isric/soc2.asc", overwrite = TRUE)
writeRaster(vpdmin1, "data/pred_var/109_extent/isric/vpdmin2.asc", overwrite = TRUE)
writeRaster(vpdmax1, "data/pred_var/109_extent/isric/vpdmax2.asc", overwrite = TRUE)
