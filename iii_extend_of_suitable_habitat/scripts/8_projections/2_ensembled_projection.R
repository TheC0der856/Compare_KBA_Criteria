# load libraries
library(biomod2)

# load ensembled model
file.out <- paste0("Presence/Presence.AllModels.ensemble.models.out")
if (file.exists(file.out)) {
  myEnsembleModel <- get(load(file.out))
}

# load single projections
file.out <- paste0("Presence/proj_20x20/Presence.20x20.projection.out")
if (file.exists(file.out)) {
  myBiomodProj <- get(load(file.out))
}

# Project ensemble models
myBiomodEMProj <- BIOMOD_EnsembleForecasting(bm.em = myEnsembleModel,
                                             bm.proj = myBiomodProj,
                                             models.chosen = 'all',
                                             metric.binary = 'all',
                                             metric.filter = 'all')