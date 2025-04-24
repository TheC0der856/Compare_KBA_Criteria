# load packages
library(biomod2)
# library(terra)


# load environment
# myExpl <- rast("env_variables/stacks/stack_filtered6.tif")

# load ensemble model
file.out <- paste0("Presence/Presence.AllModels.ensemble.models.out")
 if (file.exists(file.out)) {
   myEnsembleModel <- get(load(file.out))
}

# load single projections
file.out <- paste0("test/proj_test/test.test.projection.out")
if (file.exists(file.out)) {
  myBiomodProj <- get(load(file.out))
}

# Project ensemble models (from single projections)
myBiomodEMProj <- BIOMOD_EnsembleForecasting(bm.em = myBiomodEM, 
                                             bm.proj = myBiomodProj,
                                             models.chosen = 'all',
                                             metric.binary = 'all',
                                             metric.filter = 'all')

