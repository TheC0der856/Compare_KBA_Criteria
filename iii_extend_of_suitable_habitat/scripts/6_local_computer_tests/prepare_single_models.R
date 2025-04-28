# load package
library(biomod2)
library(terra)

# change working dir
setwd("iii_extend_of_suitable_habitat/")

# load data set and variables
occ_data <- read.csv("occurrences/Ariagona_in_env.csv")
occ_data$Presence <- 1
myRespName <- 'Presence'
myResp <- as.numeric(occ_data[, myRespName])
myRespXY <- occ_data[, c('X', 'Y')]
myExpl <- rast("scripts/5_reduce_stack_size/stack_filtered6_50x50.tif")

# create pseudo absences
myResp.PA <- ifelse(myResp == 1, 1, NA)

# prepare data and parameters
myBiomodData <- BIOMOD_FormatingData(resp.var = myResp,
                                     expl.var = myExpl,
                                     resp.xy = myRespXY,
                                     resp.name = myRespName,
                                     PA.nb.rep = 10,           # 10 is recommended* by biomod2 team
                                     PA.nb.absences = 132,    # presence (44) x3 is recommended* by biomod2 team = 132
                                     PA.strategy = 'random')


# run models
myBiomodModelOut <- BIOMOD_Modeling(bm.format = myBiomodData,
                                    modeling.id = 'AllModels',
                                    CV.strategy = 'random',
                                    CV.nb.rep = 2,
                                    CV.perc = 0.8,
                                    OPT.strategy = 'bigboss',
                                    var.import = 3,
                                    metric.eval = c('TSS','ROC'),
                                    seed.val = 123) # set a random seed for being able to reproduce results
                                   