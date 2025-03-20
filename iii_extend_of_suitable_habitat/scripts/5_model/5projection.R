# do projection


# load packages
library(biomod2)
library(terra)

# load model
file.out <- paste0("Presence/Presence.AllModels.models.out")
if (file.exists(file.out)) {
  myBiomodModelOut <- get(load(file.out))
}


# Project single models
myBiomodProj <- BIOMOD_Projection(bm.mod = myBiomodModelOut,
                                  proj.name = 'Current',
                                  new.env = myExpl,
                                  models.chosen = 'all',
                                  build.clamping.mask = TRUE,
                                  digits = 1)
myBiomodProj
plot(myBiomodProj)


# load ensemble model
file.out <- paste0("Presence/Presence.AllModels.ensemble.models.out")
 if (file.exists(file.out)) {
   myEnsembleModel <- get(load(file.out))
}

# load environment
myExpl <- rast("env_variables/stacks/stack_filtered6.tif")

# which models exist?
get_built_models(myEnsembleModel)
# EMca is the best!

# create projections:
myBiomodEMProj <- BIOMOD_EnsembleForecasting(myEnsembleModel, 
                                            myBiomodProj, 
                                            myExpl, 
                                            models.chosen = "Presence_EMcaByTSS_mergedData_mergedRun_mergedAlgo" 
                                            )
