# load biomod
library(biomod2)

# load ensemble model
file.out <- paste0("Presence/Presence.AllModels.ensemble.models.out")
if (file.exists(file.out)) {
  myEnsembleModel <- get(load(file.out))
}


# bivariate
response_curves_EMcaByROC_bimedian <- bm_PlotResponseCurves(bm.out = myEnsembleModel, 
                                                            models.chosen = 'Presence_EMcaByROC_mergedData_mergedRun_mergedAlgo',
                                                            fixed.var = 'median', 
                                                            do.bivariate = TRUE)

# prepare tab for a clean plot
bivariate_tab <- response_curves_EMcaByROC_bimedian$tab
ggdat <- subset(bivariate_tab, grepl("dist_fayal_brezal", comb))
ggdat <- ggdat[!(ggdat$expl.name == "dist_fayal_brezal" & ggdat$expl.val > 0.001), ] # only looking at cliff heathland areas
ggdat <- ggdat[!(ggdat$expl.name == "dist_shrubs" & ggdat$expl.val > 1000), ]        # narrow perspective
ggdat <- ggdat[!(ggdat$expl.name == "dist_tree_edge" & ggdat$expl.val > 500), ]      # narrow perspective
# switch comb names, so fayal_brezal is always the last (y axes):
ggdat$comb <- gsub("^(dist_fayal_brezal)\\+(\\w+)$", "\\2+dist_fayal_brezal", ggdat$comb)
ggdat$comb <- gsub("^(\\w+)\\+(dist_fayal_brezal)$", "\\1+dist_fayal_brezal", ggdat$comb)

comb.names = sort(unique(ggdat$comb))
list.ggdat = foreach(combi = comb.names) %do%
  {
    vari1 = strsplit(combi, "[+]")[[1]][1]
    vari2 = strsplit(combi, "[+]")[[1]][2]
    tmp = ggdat[which(ggdat$comb == combi), ]
    tmp1 = tmp[which(tmp$expl.name == vari1), c("id", "expl.val", "pred.name", "pred.val", "comb")]
    colnames(tmp1)[which(colnames(tmp1) == "expl.val")] = vari1
    tmp2 = tmp[which(tmp$expl.name == vari2), c("id", "expl.val", "pred.name", "pred.val", "comb")]
    colnames(tmp2)[which(colnames(tmp2) == "expl.val")] = vari2
    tmp = merge(tmp1, tmp2, by = c("id", "pred.name", "pred.val", "comb"))
    return(tmp)
  }
names(list.ggdat) = comb.names

gg <- ggplot(ggdat, aes(fill = .data$pred.val))
for (ii in 1:length(list.ggdat)) {
  combi = names(list.ggdat)[ii]
  vari1 = strsplit(combi, "[+]")[[1]][1]
  vari2 = strsplit(combi, "[+]")[[1]][2]
  gg <- gg +
    geom_raster(data = list.ggdat[[ii]], aes(x = .data[[vari1]], y = .data[[vari2]]))
}
gg <- gg +
  facet_wrap(~ comb, labeller = labeller(comb = function(x) sapply(strsplit(x, "[+]"), `[`, 1)), scales = "free") + # only show variable one in the title
  xlab("") +
  ylab("") +
  scale_fill_viridis_c("Probability") +
  theme(
    legend.key = element_rect(fill = "white"),
    legend.position = c(0.95, 0),     # Positioniert die Legende weiter nach unten
    legend.justification = c(1, 0),   # Justiert die Legende unten rechts
    legend.box.just = "right",        # Box der Legende anpassen
    axis.text.x = element_text(angle = 45, hjust = 1, size = 15),
    axis.text.y = element_blank(), 
    axis.ticks.y = element_blank(), 
    strip.text = element_text(size = 20),
    legend.text = element_text(size = 15),  
    legend.title = element_text(size = 15),  
    legend.key.size = unit(1.2, "cm"),
    legend.direction = "horizontal",  
    legend.spacing.x = unit(0.5, "cm")  # Abstand zwischen den Legenden-Elementen
  ) +
  coord_cartesian(expand = FALSE)  # plot should have no (grey) background







# load ggplot to save the plot
library(ggplot2)

ggsave("ensemble_model_results/response_curves_EMcaByROC_bivariate.jpg", plot = gg, width = 14, height = 8, dpi = 300)
ggsave("ensemble_model_results/response_curves_EMcaByROC_bivariate.pdf", plot = gg, width = 14, height = 8)
