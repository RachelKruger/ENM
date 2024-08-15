library(geodata)
# Path to download: C:/Users/Rachel Kruger/OneDrive - Binghamton University/Documents/Binghamton 2023-2024/enm/isric
# Downloading each individual variable

bdod <- soil_world(var="bdod", depth=5, path='data/pred_var/raw_isric')

cfvo <- soil_world(var="cfvo", depth=5, path='data/pred_var/raw_isric')

clay <- soil_world(var="clay", depth=15, path='data/pred_var/raw_isric')

nitrogen <- soil_world(var="nitrogen", depth=5, path='data/pred_var/raw_isric')

ocd <- soil_world(var="ocd", depth=5, path='data/pred_var/raw_isric')

phh2o <- soil_world(var="phh2o", depth=5, path='data/pred_var/raw_isric')

sand <- soil_world(var="sand", depth=5, path='data/pred_var/raw_isric')

silt <- soil_world(var="silt", depth=5, path='data/pred_var/raw_isric')

soc <- soil_world(var="soc", depth=5, path='data/pred_var/raw_isric')

elev <- elevation_30s(country = "USA", path = "data/pred_var/raw_isric")


# NEED TO FIGURE THIS OUT - MUST CHOOSE ONE OF THE CHARACTERS...
# acrisols <- soil_world_vsi(var = "wrb", name = "Acrisols")
# albeluvisols <- soil_world_vsi(var = "wrb", name = "Albeluvisols")
# alisols <- soil_world_vsi(var = "wrb", name = "Alisols")
# andosols <- soil_world_vsi(var = "wrb", name = "Andosols")
# calcisols <- soil_world_vsi(var = "wrb", name = "Calcisols")
# cambisols <- soil_world_vsi(var = "wrb", name = "Cambisols")
# chernozems <- soil_world_vsi(var = "wrb", name = "Chernozems")
# cryosols <- soil_world_vsi(var = "wrb", name = "Cryosols")
# durisols <- soil_world_vsi(var = "wrb", name = "Durisols")
# ferralsols <- soil_world_vsi(var = "wrb", name = "Ferralsols")
# fluvisols <- soil_world_vsi(var = "wrb", name = "Fluvisols")
# gleysols <- soil_world_vsi(var = "wrb", name = "Gleysols")
# gypsisols <- soil_world_vsi(var = "wrb", name = "Gypsisols")
# histosols <- soil_world_vsi(var = "wrb", name = "Histosols")
# kastanozems <- soil_world_vsi(var = "wrb", name = "Kastanozems")
# leptosols <- soil_world_vsi(var = "wrb", name = "Leptosols")
# lixisols <- soil_world_vsi(var = "wrb", name = "Lixisols")
# luvisols <- soil_world_vsi(var = "wrb", name = "Luvisols")
# nitisols <- soil_world_vsi(var = "wrb", name = "Nitisols")
# phaeozems <- soil_world_vsi(var = "wrb", name = "Phaeozems")
# planosols <- soil_world_vsi(var = "wrb", name = "Planosols")
# plinthosols <- soil_world_vsi(var = "wrb", name = "Plinthosols")
# podzols <- soil_world_vsi(var = "wrb", name = "Podzols")
# regosols <- soil_world_vsi(var = "wrb", name = "Regosols")
# solonchaks <- soil_world_vsi(var = "wrb", name = "Solonchaks")
# solonetz <- soil_world_vsi(var = "wrb", name = "Solonetz")
# stagnosols <- soil_world_vsi(var = "wrb", name = "Stagnosols")
# umbrisols <- soil_world_vsi(var = "wrb", name = "Umbrisols")
# vertisols <- soil_world_vsi(var = "wrb", name = "Vertisols")

#Only available for depth=30
# ocs <- soil_world(var="ocs", depth=5, path='data/pred_var/raw_isric')

# Clip to extent - e<-extent(c(-126, -110, 29, 41)))
library(raster)
library(sf)
# Create a box as a Spatial Object
# e <- as(extent(-122, -114, 29.5, 38.5), 'SpatialPolygons')
# crs(e) <- "+proj=longlat +datum=WGS84 +no_defs"

# 4. Define extent of study region (cropping)----
## Import shapefile to crop to----

### Read in Shapefile----
# Remember, this is the only file you'll read in, but it requires those other files 
# with the same name but different file extensions to be present in the same folder!
shapefile <- st_read("data/buffer/loncal_2deg_7-1-24.shp") # st_read is from the sf package

### Transform to be same CRS as envall raster----
shapefile <- st_transform(shapefile, crs = 4326)

## Crop variable rasters to buffer extent----

# Crop to bbox extent of shapefile
cbdod <- crop(bdod, extent(st_bbox(shapefile)))
# Mask it so that it actually crops to the buffer shape rather than just the maximum 
# bbox or whatever
mbdod <- mask(cbdod, shapefile)
# Rasterize it
b <- raster(mbdod)
# Write the file in ascii format for MaxEnt
writeRaster(b, filename = "data/pred_var/2deg_clip/bdod.asc", format="ascii", overwrite=T)


ccfvo <- crop(cfvo, extent(st_bbox(shapefile)))
mcfvo <- mask(ccfvo, shapefile)
cf <- raster(mcfvo)
writeRaster(cf, filename = "data/pred_var/2deg_clip/cfvo.asc", format="ascii", overwrite=T)

cclay <- crop(clay, extent(st_bbox(shapefile)))
mclay <- mask(cclay, shapefile)
cl <- raster(mclay)
writeRaster(cl, filename = "data/pred_var/2deg_clip/clay.asc", format="ascii", overwrite=T)

cnitrogen <- crop(nitrogen, extent(st_bbox(shapefile)))
mnitrogen <- mask(cnitrogen, shapefile)
n <- raster(mnitrogen)
writeRaster(n, filename = "data/pred_var/2deg_clip/nitrogen.asc", format="ascii", overwrite=T)

cocd <- crop(ocd, extent(st_bbox(shapefile)))
mocd <- mask(cocd, shapefile)
o <- raster(mocd)
writeRaster(o, filename = "data/pred_var/2deg_clip/ocd.asc", format="ascii", overwrite=T)

cphh2o <- crop(phh2o, extent(st_bbox(shapefile)))
mphh2o <- mask(cphh2o, shapefile)
p <- raster(mphh2o)
writeRaster(p, filename = "data/pred_var/2deg_clip/phh2o.asc", format="ascii", overwrite=T)

csand <- crop(sand, extent(st_bbox(shapefile)))
msand <- mask(csand, shapefile)
sa <- raster(msand)
writeRaster(sa, filename = "data/pred_var/2deg_clip/sand.asc", format="ascii", overwrite=T)

csilt <- crop(silt, extent(st_bbox(shapefile)))
msilt <- mask(csilt, shapefile)
si <- raster(msilt)
writeRaster(si, filename = "data/pred_var/2deg_clip/silt.asc", format="ascii", overwrite=T)

csoc <- crop(soc, extent(st_bbox(shapefile)))
msoc <- mask(csoc, shapefile)
so <- raster(msoc)
writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)

celev <- crop(elev, extent(st_bbox(shapefile)))
melev <- mask(celev, shapefile)
el <- raster(melev)
writeRaster(el, filename = "data/pred_var/2deg_clip/elev.asc", format="ascii", overwrite=T)

# cacrisols <- crop(acrisols, extent(st_bbox(shapefile)))
# macrisols <- mask(cacrisols, shapefile)
# sacrisols <- raster(macrisols)
# writeRaster(sacrisols, filename = "data/pred_var/2deg_clip/acrisols.asc", format="ascii", overwrite=T)
# 
# calbeluvisols <- crop(albeluvisols, extent(st_bbox(shapefile)))
# malbeluvisols <- mask(calbeluvisols, shapefile)
# salbeluvisols <- raster(malbeluvisols)
# writeRaster(salbeluvisols, filename = "data/pred_var/2deg_clip/albeluvisols.asc", format="ascii", overwrite=T)
# 
# calisols <- crop(alisols, extent(st_bbox(shapefile)))
# malisols <- mask(calisols, shapefile)
# salisols <- raster(malisols)
# writeRaster(salisols, filename = "data/pred_var/2deg_clip/alisols.asc", format="ascii", overwrite=T)
# 
# csoc <- crop(soc, extent(st_bbox(shapefile)))
# msoc <- mask(csoc, shapefile)
# so <- raster(msoc)
# writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)
# 
# csoc <- crop(soc, extent(st_bbox(shapefile)))
# msoc <- mask(csoc, shapefile)
# so <- raster(msoc)
# writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)
# 
# csoc <- crop(soc, extent(st_bbox(shapefile)))
# msoc <- mask(csoc, shapefile)
# so <- raster(msoc)
# writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)
# 
# csoc <- crop(soc, extent(st_bbox(shapefile)))
# msoc <- mask(csoc, shapefile)
# so <- raster(msoc)
# writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)
# 
# csoc <- crop(soc, extent(st_bbox(shapefile)))
# msoc <- mask(csoc, shapefile)
# so <- raster(msoc)
# writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)
# 
# csoc <- crop(soc, extent(st_bbox(shapefile)))
# msoc <- mask(csoc, shapefile)
# so <- raster(msoc)
# writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)
# 
# csoc <- crop(soc, extent(st_bbox(shapefile)))
# msoc <- mask(csoc, shapefile)
# so <- raster(msoc)
# writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)
# 
# csoc <- crop(soc, extent(st_bbox(shapefile)))
# msoc <- mask(csoc, shapefile)
# so <- raster(msoc)
# writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)
# 
# csoc <- crop(soc, extent(st_bbox(shapefile)))
# msoc <- mask(csoc, shapefile)
# so <- raster(msoc)
# writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)
# 
# csoc <- crop(soc, extent(st_bbox(shapefile)))
# msoc <- mask(csoc, shapefile)
# so <- raster(msoc)
# writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)
# 
# csoc <- crop(soc, extent(st_bbox(shapefile)))
# msoc <- mask(csoc, shapefile)
# so <- raster(msoc)
# writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)
# 
# csoc <- crop(soc, extent(st_bbox(shapefile)))
# msoc <- mask(csoc, shapefile)
# so <- raster(msoc)
# writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)
# 
# csoc <- crop(soc, extent(st_bbox(shapefile)))
# msoc <- mask(csoc, shapefile)
# so <- raster(msoc)
# writeRaster(so, filename = "data/pred_var/2deg_clip/soc.asc", format="ascii", overwrite=T)