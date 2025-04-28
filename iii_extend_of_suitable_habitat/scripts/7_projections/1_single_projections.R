# load libraries
library(biomod2)
library(terra)
library(doParallel)

# load model
file.out <- paste0("Presence/Presence.AllModels.models.out")
if (file.exists(file.out)) {
  myBiomodModelOut <- get(load(file.out))
}

# load environment
myExpl <- rast("stack_filtered6_20x20.tif")



# Project single models
myBiomodProj <- BIOMOD_Projection(bm.mod = myBiomodModelOut,
                                  proj.name = '20x20',
                                  new.env = myExpl,
                                  models.chosen = 'all',
                                  build.clamping.mask = TRUE,
                                  np.cpu = 7)
