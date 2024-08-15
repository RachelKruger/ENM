#only need to run this code the first time you install these packages on your machine/user account.

#NOTE: If you have RStudio open already and you tried this script and it didn't work:
#Close RStudio and reopen it again. and try re-installing the ENMEval package (line 12)

#You don't need rJava for this version of the script, but you must install all of the packages and run all of the code you see below with the hash (comment) symbols the first time you run it
#install.packages("devtools", dependencies = TRUE)
#library(devtools)
#install_github("jamiemkass/ENMeval")
#

library(ENMeval)
library(raster)

#You don't need to do all that stuff about putting Java in the right directory any more.
#
#
#
#

#put here the names of your environmental layers, following the pattern below:
setwd("C:/Users/Rachel Kruger/OneDrive - Binghamton University/Documents/Binghamton 2023-2024/enm/new extent")
bio1 <- raster("bio1.asc")
bio2 <- raster("bio2.asc")
bio3 <- raster("bio3.asc")
bio4 <- raster("bio4.asc")
bio7 <- raster("bio7.asc")
bio8 <- raster("bio8.asc")
bio9 <- raster("bio9.asc")
bio10 <- raster("bio10.asc")
bio11 <- raster("bio11.asc")
bio13 <- raster("bio13.asc")
bio14 <- raster("bio14.asc")
bio15 <- raster("bio15.asc")
bio18 <- raster("bio18.asc")
bdod <- raster("bdod2.asc")
cfvo <- raster("cfvo2.asc")
clay <- raster("clay2.asc")
nitrogen <- raster("nitrogen2.asc")
ocd <- raster("ocd2.asc")
phh2o <- raster("phh2o2.asc")
sand <- raster("sand2.asc")
silt <- raster("silt2.asc")
soc <- raster("soc2.asc")

#Do what's called "stacking" the rasters together into a single r object

env <- stack(bio1, bio2, bio3, bio4, bio7, bio8, bio9, bio10, bio11, bio13, bio14, bio15, bio18, bdod, cfvo, clay, nitrogen, ocd, phh2o, sand, silt, soc)

#Display the stacked environment layer. Make a note of the position in the list 
#of any categorical variables (do that by hand)

env

#in this example, the categorical variables are #s 9 and 10 in the list. But know your own data!

#load in your occurrence points
setwd("C:/Users/Rachel Kruger/OneDrive - Binghamton University/Documents/Binghamton 2023-2024/enm/Occurrence Data")

occ <- read.csv("cal_thin_enmeval.csv")

#check how many potential background points you have available

length(which(!is.na(values(subset(env, 1)))))

#If this number is far in excess of 10,000, then use 10,000 background points.
#If this number is comprable to, or smaller than 10,000, then use 5,000, 1,000, 500,
#or even 100 background points. The number of available non-NA spaces should 
#be well in excess of the number of background points used.

#For the evalution below, we need to convert the bias object into another format.
#The code is set up to sample 5,000 background points. It would be better if we
#could sample 10,000 background points, but there are not enough places available.
#If we could change it to 10,000 background points we would change the ", 5000," to ",10000," ***RK - This is irrelevant if no bias file***

cb2 <- get.checkerboard2(occ, envs, bg, aggregation.factor, gridSampleN = 10000)
#run the evaluation

##This run uses the "randomkfold" method of cross-validation and 10 cross-validation folds. 
##There are two categorical variables: they are numbers 9 and 10 in the list of environmental 
##variables from the stacked raster object.

enmeval_results_cal <- ENMevaluate(occ, env, bg = NULL, tune.args = list(fc = c("L","LQ","H", "LQH", "LQHP", "LQHPT"), rm = 1:5), partitions = "randomkfold", partition.settings = list(kfolds = 5), algorithm = "maxnet")
enmeval_results@results

write.csv(enmeval_results_cal@results, "enmeval_results_cal_thin.csv")

#If you were to use the block method, you would replace:
#partitions = "randomkfold", partition.settings = list(kfolds = 10)
#with:
#partitions = "block"

#############################
##########IMPORTANT##########
#############################
#If you have fewer than 50 occurrence points, you will need to use the "jackknife" method of
#model validation instread. To do that, you would replace:
#partitions = "randomkfold", partition.settings = list(kfolds = 10)
#with:
#partitions = "jackknife"

#If there are no categorical variables in your dataset, you would get rid of:
#categoricals = c("biocateg1", "biocateg2")
#In general, be very careful that the categoricals argument points to the right variable(s).
