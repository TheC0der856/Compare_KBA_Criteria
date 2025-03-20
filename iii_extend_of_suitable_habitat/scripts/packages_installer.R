# Install required packages if they are not installed
#if (!requireNamespace("sf", quietly = TRUE)) {install.packages("sf")}
if (!requireNamespace("dplyr", quietly = TRUE)) {install.packages("dplyr")}
#if (!require("raster")) install.packages("raster", dependencies = TRUE)
if (!requireNamespace("spatialEco", quietly = TRUE)) {install.packages("spatialEco")}  #DEM
#if (!requireNamespace("rJava", quietly = TRUE)) {install.packages("rJava", type = "source", configure.args = "--enable-java")}

# Define required packages
required_packages <- c("terra",       # necessary
                       "raster",      # avoid!
                       #"dismo",
                       #"ENMeval", 
                       "caret",       # findCorrelation(), necessary
                       "corrplot",    # corrplot(), not necessary
                       "sf", 
                       #"ggplot2",
                       #"rJava"
                       )

# Install missing packages
install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}

# Install all required packages
sapply(required_packages, install_if_missing)