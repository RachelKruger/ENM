library(ENMTools)
library(terra)

# Load in environmental data----
env.files <- list.files(path = "data/pred_var/2deg_max", pattern = "bio", full.names = TRUE)
env <- terra::rast(env.files)
names(env) <- c("bio1", "bio10", "bio12", "bio13", "bio14","bio16","bio17","bio18","bio19","bio2", "bio5", "bio6", "bio7", "bio9")
env <- setMinMax(env)
env <- check.env(env)

plot(env[[1]])

# Create enmtools.species objects----
calycinus <- enmtools.species()
longiflorus <- enmtools.species()

## CAL----
names(calycinus)
calycinus$species.name <- "calycinus"
calycinus$presence.points <- vect(read.csv('data/occurrence_data/cal_thin_enmtools.csv'), geom = c("x", "y"))
crs(calycinus$presence.points) <- crs(env)
calycinus$range <- background.raster.buffer(calycinus$presence.points, 50000, mask = env)
calycinus$background.points <- background.points.buffer(points = calycinus$presence.points,
                                               radius = 2000, n = 1000, mask = env[[1]])
calycinus <- check.species(calycinus)
interactive.plot(calycinus)

## LON----
names(longiflorus)
longiflorus$species.name <- "longiflorus"
longiflorus$presence.points <- vect(read.csv('data/occurrence_data/lon_thin_enmtools.csv'), geom = c("x", "y"))
crs(longiflorus$presence.points) <- crs(env)
longiflorus$range <- background.raster.buffer(longiflorus$presence.points, 50000, mask = env)
longiflorus$background.points <- background.points.buffer(points = longiflorus$presence.points,
                                                        radius = 2000, n = 1000, mask = env[[1]])
longiflorus <- check.species(longiflorus)
interactive.plot(longiflorus)


# Identity Test----
id.glm <- identity.test(species.1 = calycinus, species.2 = longiflorus, env = env, type = "glm", nreps = 4)
id.glm
# 
# Identity test calycinus vs. longiflorus
# 
# Identity test p-values:
#   D        I rank.cor    env.D    env.I  env.cor 
# 0.2      0.2      0.2      0.2      0.2      0.2 
# 
# 
# Replicates:
#   
#   
#   |          |         D|         I|   rank.cor|     env.D|     env.I|    env.cor|
#   |:---------|---------:|---------:|----------:|---------:|---------:|----------:|
#   |empirical | 0.1937442| 0.4355212| -0.8268455| 0.2439283| 0.2883515| -0.6458279|
#   |rep 1     | 0.7569511| 0.9444553|  0.4399288| 0.7572416| 0.9026805|  0.9067274|
#   |rep 2     | 0.5467859| 0.8105136| -0.0031331| 0.7215404| 0.8505500|  0.7999710|
#   |rep 3     | 0.6595719| 0.8980954|  0.4318060| 0.7823177| 0.8402091|  0.7577250|
#   |rep 4     | 0.7980421| 0.9631372|  0.7719571| 0.8196845| 0.9089318|  0.9096140|
#   Warning messages:
#   1: Removed 2 rows containing missing values or values outside the scale range (`geom_bar()`). 
# 2: Removed 2 rows containing missing values or values outside the scale range (`geom_bar()`). 
# 3: Removed 2 rows containing missing values or values outside the scale range (`geom_bar()`). 
# 4: Removed 2 rows containing missing values or values outside the scale range (`geom_bar()`). 
# 5: Removed 2 rows containing missing values or values outside the scale range (`geom_bar()`). 
# 6: Removed 2 rows containing missing values or values outside the scale range (`geom_bar()`). 



# Ecospat Test----
esp.bg.sym <- enmtools.ecospat.bg(calycinus, longiflorus, env, test.type = "symmetric")
esp.bg.sym
