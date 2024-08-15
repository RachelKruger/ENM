#Adapted from Josh Banta (joshbanta.com)

#install spThin package if not already installed
install.packages("spThin", dependencies = TRUE)

#initialize the spThin package
library(spThin)

#read in the file
## change the file name to match your file name
## latitude/longitude must be in the WGS1984 pseudoprojection!
input_cal <- read.csv("data/occurrence_data/cal_6-28-24_nodup_spThin.csv")
input_lon <- read.csv("data/occurrence_data/lon_6-28-24_nodup_spThin.csv")
#thin to no more than one sample per kilometer

##If you're using on your own data, change 'out.dir', 'out.base', and 'log.file' to be what
##you want for your data. Also change 'lat.col', 'long.col', and 'spec.col' to match your
##data


thinned_cal <- thin(
  
  loc.data = input_cal, 
  lat.col = "LAT", long.col = "LONG", 
  spec.col = "SPEC", 
  thin.par = 1, reps = 10, 
  locs.thinned.list.return = TRUE, 
  write.files = TRUE, 
  max.files = 10, 
  out.dir = "data/occurrence_data", out.base = "calycinus",
  write.log.file = TRUE,
  log.file = "data/occurrence_data/cal.txt" 
  
)

thinned_lon <- thin(
  
  loc.data = input_lon, 
  lat.col = "LAT", long.col = "LONG", 
  spec.col = "SPEC", 
  thin.par = 1, reps = 10, 
  locs.thinned.list.return = TRUE, 
  write.files = TRUE, 
  max.files = 10, 
  out.dir = "data/occurrence_data", out.base = "longiflorus",
  write.log.file = TRUE,
  log.file = "data/occurrence_data/lon.txt" 
  
)
plotThin(thinned)
summaryThin(thinned, show = T)
