# Sampbias

# Install package, load library----
install.packages("devtools")
require("devtools")
install_github("azizka/sampbias")
library(sampbias)


# lon-cal
loncal <- read.csv("data/occurrence_data/loncal_6-28-24_nodup_sampbias.csv")
loncal.out <- calculate_bias(x = loncal, res = 0.1, plot_raster = T)
summary(loncal.out)
plot(loncal.out)

proj <- project_bias(loncal.out)
map_bias(proj, type = "log_sampling_rate")

# lon
lon <- read.csv("data/occurrence_data/lon_6-28-24_nodup_sampbias.csv")
lon.out <- calculate_bias(x = lon, res = 0.1, plot_raster = T)
summary(lon.out)
plot(lon.out)

proj <- project_bias(lon.out)
map_bias(proj, type = "log_sampling_rate")

# lon
cal <- read.csv("data/occurrence_data/cal_6-28-24_nodup_sampbias.csv")
cal.out <- calculate_bias(x = cal, res = 0.1, plot_raster = T)
summary(cal.out)
plot(cal.out)

proj <- project_bias(lon.out)
map_bias(proj, type = "log_sampling_rate")
