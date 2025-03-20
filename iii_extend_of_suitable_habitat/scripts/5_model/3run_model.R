#library(ggplot2)

# Run model: 
# Model single models
# default options modified for the better by biomod2 team
myBiomodModelOut <- BIOMOD_Modeling(bm.format = myBiomodData,
                                    modeling.id = 'AllModels',
                                    CV.strategy = 'random',
                                    CV.nb.rep = 2,
                                    CV.perc = 0.8,
                                    OPT.strategy = 'bigboss',       
                                    var.import = 3,
                                    metric.eval = c('TSS','ROC'), 
                                    seed.val = 123, # set a random seed for being able to reproduce results
                                    nb.cpu = 10)    # use 10 cpu cores

# 
# # save results: 
# # create a directory for results: 
# if (!dir.exists("model_results")) {
#   dir.create("model_results")
# }
# if (!dir.exists("model_results/model_quality")) {
#   dir.create("model_results/model_quality")
# }
# if (!dir.exists("model_results/variable_importance")) {
#   dir.create("model_results/variable_importance")
# }
# capture.output(print(myBiomodModelOut), file = "model_results/0myBiomodModelOut_ingeneral.txt")
# 
# # Get evaluation scores & variables importance
# eval_scores <- get_evaluations(myBiomodModelOut)
# write.csv(eval_scores, "model_results/model_quality/evaluation.csv", row.names = TRUE)
# var_importance <- get_variables_importance(myBiomodModelOut)
# write.csv(var_importance, "model_results/variable_importance/variable_importance.csv", row.names = TRUE)
# 
# # Represent evaluation scores & variables importance
# eval_mean <- bm_PlotEvalMean(bm.out = myBiomodModelOut)
# ggsave("model_results/model_quality/1evaluation_mean.png", plot = eval_mean$plot, width = 8, height = 6, dpi = 300)
# write.csv(eval_mean$tab, "model_results/model_quality/1evaluation_mean.csv", row.names = TRUE)
# eval_boxplot <- bm_PlotEvalBoxplot(bm.out = myBiomodModelOut, group.by = c('algo', 'algo'))
# ggsave("model_results/model_quality/2evaluation_boxplot.png", plot = eval_boxplot$plot, width = 8, height = 6, dpi = 300)
# write.csv(eval_boxplot$tab, "model_results/model_quality/2evaluation_boxplot.csv", row.names = TRUE)
# # random forest performs better than other models: highest ROC and TSS
# # followed by GBM
# # and ANN
# eval_boxplot_run <- bm_PlotEvalBoxplot(bm.out = myBiomodModelOut, group.by = c('algo', 'run'))
# ggsave("model_results/model_quality/3compare_runs.png", plot = eval_boxplot_run$plot, width = 8, height = 6, dpi = 300)
# write.csv(eval_boxplot_run$tab, "model_results/model_quality/3compare_runs.csv", row.names = TRUE)
# var_importance_boxplot <- bm_PlotVarImpBoxplot(bm.out = myBiomodModelOut, group.by = c('expl.var', 'algo', 'algo'))
# ggsave("model_results/variable_importance/compare_models.png", plot = var_importance_boxplot$plot, width = 8, height = 6, dpi = 300)
# write.csv(var_importance_boxplot$tab, "model_results/variable_importance/compare_models.csv", row.names = TRUE)
# # the model does not seem to increase in precision with combining the runs, but we have very few presence points. 
# # I decided to use all runs non the less.
# var_importance_run <- bm_PlotVarImpBoxplot(bm.out = myBiomodModelOut, group.by = c('expl.var', 'algo', 'run')) 
# ggsave("model_results/variable_importance/compare_runs.png", plot = var_importance_run$plot, width = 8, height = 6, dpi = 300)
# write.csv(var_importance_run$tab, "model_results/variable_importance/compare_runs.csv", row.names = TRUE)
# # here we can see that all variables are not explaining the species occurrence very well... (with random forest)
# # but distance to fayal-brezal seems to be the most important 
# # canopy height seems to be important to
# var_importance_runs <- bm_PlotVarImpBoxplot(bm.out = myBiomodModelOut, group.by = c('algo', 'expl.var', 'run'))
# ggsave("model_results/variable_importance/compare_runs2.png", plot = var_importance_run$plot, width = 8, height = 6, dpi = 300)
# write.csv(var_importance_run$tab, "model_results/variable_importance/compare_runs2.csv", row.names = TRUE)
# # random forest and GBM say the variables are not describing the occurrences
# # ANN finds them to be more explaining
# 
# # Using this code you can see all the model names :
# # get_built_models(myBiomodModelOut)
# # I am only interested in Models which were performed with all data and all runs
# # I like to see more details of the models: RF, GBM and ANN
# # their names: "Presence_allData_allRun_RF", "Presence_allData_allRun_GBM", "Presence_allData_allRun_ANN"
# 
# if (!dir.exists("model_results/response_curves")) {
#   dir.create("model_results/response_curves")
# }
# if (!dir.exists("model_results/response_curves/ANN")) {
#   dir.create("model_results/response_curves/ANN")
# }
# if (!dir.exists("model_results/response_curves/CTA")) {
#   dir.create("model_results/response_curves/CTA")
# }
# if (!dir.exists("model_results/response_curves/FDA")) {
#   dir.create("model_results/response_curves/FDA")
# }
# if (!dir.exists("model_results/response_curves/GAM")) {
#   dir.create("model_results/response_curves/GAM")
# }
# if (!dir.exists("model_results/response_curves/GBM")) {
#   dir.create("model_results/response_curves/GBM")
# }
# if (!dir.exists("model_results/response_curves/GLM")) {
#   dir.create("model_results/response_curves/GLM")
# }
# if (!dir.exists("model_results/response_curves/MARS")) {
#   dir.create("model_results/response_curves/MARS")
# }
# if (!dir.exists("model_results/response_curves/MAXENT")) {
#   dir.create("model_results/response_curves/MAXENT")
# }
# if (!dir.exists("model_results/response_curves/MAXNET")) {
#   dir.create("model_results/response_curves/MAXNET")
# }
# if (!dir.exists("model_results/response_curves/RF")) {
#   dir.create("model_results/response_curves/RF")
# }
# if (!dir.exists("model_results/response_curves/SRE")) {
#   dir.create("model_results/response_curves/SRE")
# }
# if (!dir.exists("model_results/response_curves/XGBOOST")) {
#   dir.create("model_results/response_curves/XGBOOST")
# }
# # Represent response curves:
# #ANN
# response_curves_median_ANN <- bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_ANN"), fixed.var = 'median')
# ggsave("model_results/response_curves/ANN/median.png", plot = response_curves_median_ANN$plot, width = 8, height = 6, dpi = 300)
# response_curves_min_ANN <-bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_ANN"  ), fixed.var = 'min')
# ggsave("model_results/response_curves/ANN/min.png", plot = response_curves_min_ANN$plot, width = 8, height = 6, dpi = 300)
# #CTA
# response_curves_median_CTA <- bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_CTA"), fixed.var = 'median')
# ggsave("model_results/response_curves/CTA/median.png", plot = response_curves_median_CTA$plot, width = 8, height = 6, dpi = 300)
# response_curves_min_CTA <-bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_CTA"  ), fixed.var = 'min')
# ggsave("model_results/response_curves/CTA/min.png", plot = response_curves_min_CTA$plot, width = 8, height = 6, dpi = 300)
# #FDA
# response_curves_median_FDA <- bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_FDA"), fixed.var = 'median')
# ggsave("model_results/response_curves/FDA/median.png", plot = response_curves_median_FDA$plot, width = 8, height = 6, dpi = 300)
# response_curves_min_FDA <-bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_FDA"  ), fixed.var = 'min')
# ggsave("model_results/response_curves/FDA/min.png", plot = response_curves_min_FDA$plot, width = 8, height = 6, dpi = 300)
# #GAM
# response_curves_median_GAM <- bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_GAM"), fixed.var = 'median')
# ggsave("model_results/response_curves/GAM/median.png", plot = response_curves_median_GAM$plot, width = 8, height = 6, dpi = 300)
# response_curves_min_GAM <-bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_GAM"  ), fixed.var = 'min')
# ggsave("model_results/response_curves/GAM/min.png", plot = response_curves_min_GAM$plot, width = 8, height = 6, dpi = 300)
# #GBM
# response_curves_median_GBM <- bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_GBM"), fixed.var = 'median')
# ggsave("model_results/response_curves/GBM/median.png", plot = response_curves_median_GBM$plot, width = 8, height = 6, dpi = 300)
# response_curves_min_GBM <-bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_GBM"  ), fixed.var = 'min')
# ggsave("model_results/response_curves/GBM/min.png", plot = response_curves_min_GBM$plot, width = 8, height = 6, dpi = 300)
# #GLM
# response_curves_median_GLM <- bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_GLM"), fixed.var = 'median')
# ggsave("model_results/response_curves/GLM/median.png", plot = response_curves_median_GLM$plot, width = 8, height = 6, dpi = 300)
# response_curves_min_GLM <-bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_GLM"  ), fixed.var = 'min')
# ggsave("model_results/response_curves/GLM/min.png", plot = response_curves_min_GLM$plot, width = 8, height = 6, dpi = 300)
# #MARS
# response_curves_median_MARS <- bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_MARS"), fixed.var = 'median')
# ggsave("model_results/response_curves/MARS/median.png", plot = response_curves_median_MARS$plot, width = 8, height = 6, dpi = 300)
# response_curves_min_MARS <-bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_MARS"  ), fixed.var = 'min')
# ggsave("model_results/response_curves/MARS/min.png", plot = response_curves_min_MARS$plot, width = 8, height = 6, dpi = 300)
# #MAXENT
# response_curves_median_MAXENT <- bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_MAXENT"), fixed.var = 'median')
# ggsave("model_results/response_curves/MAXENT/median.png", plot = response_curves_median_MAXENT$plot, width = 8, height = 6, dpi = 300)
# response_curves_min_MAXENT <-bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_MAXENT"  ), fixed.var = 'min')
# ggsave("model_results/response_curves/MAXENT/min.png", plot = response_curves_min_MAXENT$plot, width = 8, height = 6, dpi = 300)
# #MAXNET
# response_curves_median_MAXNET <- bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_MAXNET"), fixed.var = 'median')
# ggsave("model_results/response_curves/MAXNET/median.png", plot = response_curves_median_MAXNET$plot, width = 8, height = 6, dpi = 300)
# response_curves_min_MAXNET <-bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_MAXNET"  ), fixed.var = 'min')
# ggsave("model_results/response_curves/MAXNET/min.png", plot = response_curves_min_MAXNET$plot, width = 8, height = 6, dpi = 300)
# #RF
# # seems to consider more influences: fog, wind speed, canopy height, tree cover density, fayal_brezal, aspect, NDVI, NDMI
# response_curves_median_RF <- bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_RF"), fixed.var = 'median')
# ggsave("model_results/response_curves/RF/median.png", plot = response_curves_median_RF$plot, width = 8, height = 6, dpi = 300)
# # DEM could be interesting too (?)
# response_curves_min_RF <-bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_RF"  ), fixed.var = 'min')
# ggsave("model_results/response_curves/RF/min.png", plot = response_curves_min_RF$plot, width = 8, height = 6, dpi = 300)
# # SRE
# response_curves_median_SRE <- bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_SRE"), fixed.var = 'median')
# ggsave("model_results/response_curves/SRE/median.png", plot = response_curves_median_SRE$plot, width = 8, height = 6, dpi = 300)
# response_curves_min_SRE <-bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_SRE"  ), fixed.var = 'min')
# ggsave("model_results/response_curves/SRE/min.png", plot = response_curves_min_SRE$plot, width = 8, height = 6, dpi = 300)
# # XGBOOST
# response_curves_median_XGBOOST <- bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_XGBOOST"), fixed.var = 'median')
# ggsave("model_results/response_curves/XGBOOST/median.png", plot = response_curves_median_XGBOOST$plot, width = 8, height = 6, dpi = 300)
# response_curves_min_XGBOOST <-bm_PlotResponseCurves(bm.out = myBiomodModelOut, models.chosen = c("Presence_allData_allRun_XGBOOST"  ), fixed.var = 'min')
# ggsave("model_results/response_curves/XGBOOST/min.png", plot = response_curves_min_XGBOOST$plot, width = 8, height = 6, dpi = 300)
# 
# 
# 
# 
# 
# # helps to visualize interactions: for all variables the probabilty is raising if fayal-brezal is included in the model
# # maybe just because fayal-brezal is important
# # bm_PlotResponseCurves(bm.out = myBiomodModelOut, 
# #                       models.chosen = c("Presence_allData_allRun_RF"),
# #                       fixed.var = 'median',
# #                       do.bivariate = TRUE)
# 

