# load package
library(biomod2)
library(doParallel)

# load single models
file.out <- paste0("Presence/Presence.AllModels.models.out")
if (file.exists(file.out)) {
  myBiomodModelOut <- get(load(file.out))
}

# select single models
all_models <- get_built_models(myBiomodModelOut)
filtered_models <- all_models[!grepl("CTA|SRE", all_models)]

# create ensembled models
myEnsembleModel <- BIOMOD_EnsembleModeling(
                                  myBiomodModelOut,
                                  models.chosen = filtered_models,
                                  em.by = "all",
                                  em.algo = 'EMca',
                                  metric.select = "all",
                                  metric.select.thresh = NULL,
                                  metric.select.table = NULL,
                                  metric.select.dataset = NULL,
                                  metric.eval = c("KAPPA", "TSS", "ROC"),
                                  var.import = 0,
                                  EMci.alpha = 0.05,
                                  EMwmean.decay = "proportional",
                                  nb.cpu = 4,
                                  seed.val = 123,
                                  do.progress = TRUE
)

# save evaluation scores
eval_scores <- get_evaluations(myEnsembleModel)
write.csv(eval_scores, "evaluation.csv", row.names = TRUE)