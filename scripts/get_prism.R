##### PRISM DATA - adapted from https://rsh249.github.io/spatial_bioinformatics/worldclim.html
# install.packages('prism')
library(prism)
libary(raster)
prism_set_dl_dir('data/pred_var/raw/prism', create = T)
vpdmin <- get_prism_normals(type = "vpdmin", resolution = "800m", mon = NULL, annual = T, keepZip = TRUE)
vpdmax <- get_prism_normals(type = "vpdmax", resolution = "800m", mon = NULL, annual = T, keepZip = TRUE)

#Rasterize each variable
vpdmin <- raster('data/pred_var/raw/prism/PRISM_vpdmin_30yr_normal_800mM5_annual_bil/PRISM_vpdmin_30yr_normal_800mM5_annual_bil.bil')
vpdmax <- raster('data/pred_var/raw/prism/PRISM_vpdmax_30yr_normal_800mM5_annual_bil/PRISM_vpdmax_30yr_normal_800mM5_annual_bil.bil')

#Stack the two variables
vpdminmax <- stack(vpdmin,vpdmax)

#Crop them to a relatively close extent to what you want to match (just slightly larger- we will crop it to the exact
# extent later)
crop <- extent(c(-122, -114, 29.5, 38.5))
vpdminmax_crop <- crop(vpdminmax, crop)
plot(vpdminmax_crop)
plot(vpdminmax)

for (i in 1:nlayers(vpdminmax_crop)){
  # writeRaster is a function that will write each layer with the correct name. As the 
  # loop iterates through, each layer in turn becomes "i". For the names, we will
  # use the names from any of the rasterstacks we downloaded from prism
  writeRaster(vpdminmax_crop[[i]], filename = names(vpdminmax_crop[[i]]), format='ascii', overwrite=T)
}
