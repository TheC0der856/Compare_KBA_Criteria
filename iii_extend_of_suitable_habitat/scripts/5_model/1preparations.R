# biomod model
#install.packages("biomod2", dependencies = TRUE)
#library(devtools)
#devtools::install_github("biomodhub/biomod2", dependencies = TRUE)
library(biomod2)
library(terra)


# load data set and variables
occ_data <- read.csv("occurences/Ariagona_in_env.csv")
occ_data$Presence <- 1
myRespName <- 'Presence'
myResp <- as.numeric(occ_data[, myRespName])
myRespXY <- occ_data[, c('X', 'Y')]
myExpl <- rast("env_variables/stacks/stack_filtered6.tif")

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

# * https://biomodhub.github.io/biomod2/articles/vignette_pseudoAbsences.html