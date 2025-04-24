# do single model projections

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


