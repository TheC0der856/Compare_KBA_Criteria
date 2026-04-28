## Comparison of metrics for identification of Key Biodiversity Areas (KBAs)



Compare all metrics to identify KBAs with criteria B1 for Ariagona margaritae: (i) mature individuals, (ii) area of occupancy, (iii) extend of suitable habitat, (iv) range, (v) number of localities, and (vi) distinct genetic diversity. Additionally a structure analysis and a PCA was conducted, potential KBAs were identified and the results of all metrics were compared.


Detailed discriptions of all calculations can be found at: 

Gronefeld, S. C., López, H., Hawlitschek, O., Schulte-Middelmann, T., Hofmann, F., Tandukar, P., & Hochkirch, A. (2026). Comparison of metrics for identifying Key Biodiversity Areas. Biological Conservation, 319, 111863. https://doi.org/10.1016/j.biocon.2026.111863



#Assessing genetic data: 
First of all the raw reads were processed in assess_genetic_data/1_stacks. In assess_genetic_data/2_quality control a PCA was conducted using plink. In assess_genetic_data/3_structure a structure clusters were calculated and the most likely cluster was selected. This analyses was done before its results were used to calculate (vi) distinct genetic diversity. 



#(i) mature individuals: 
The analysis is based on a single script, which can be found in: i_number_of_mature_individuals. 



#(ii) area of occupancy: 
The analysis is based on a single script, which can be found in: ii_area_of_occupancy. 



#(iii) extend of suitable habitat: 
Code in iii_extend_of_suitable_habitat/scripts/0_google_engine/ was used to calculate vegetation and moisture indices from google engine. In iii_extend_of_suitable_habitat/scripts/1_prepare_rasters/ the raster files were edited. Distances were calculated to change all categorical raster files into a have continous values. Furthermore, the DEM was used to calculate hillshade, sloope, aspect, curvature, and the Terrain Ruggedness Index (TRI). All rasters were combined to a stacked raster file in iii_extend_of_suitable_habitat/scripts/2_combine_rasters/. In iii_extend_of_suitable_habitat/scripts/3_prepare_stack/ correlating rasters were removed and rasters which were provided by Copernicus and the Spanish Government were compared, to decide which one of them should be included in the analyses. In the fourth step (4_create_occ_table), occurence points for each individual were transformed to a table which contains all occurence points of the species. In the fifth step (5_reduce_stack_size) a dummy raster stack was created with reduced size to test models and estimate calculation times. The sixth step (6_local_computer_tests), contains test scripts that were performed on a normal computer, before the code was adjusted to a high performance cluster computer. After the code performed well on a normal computer, the models were calcualted in iii_extend_of_suitable_habitat/scripts/7_model/. The script 1_0_preparations_and_single_models.R calculates all models. It is executed by 1_0_preparations_and_single_models.sh. Afterwards the quality of the models were tested with 1_1_quality_control.R, which was executed by 1_1_quality_control.sh. All models which performed well were combined in an ensembled model with 2_0_ensembled_model.R, which was executed by 2_0_ensembled_model.sh. The performance of the ensembled model was controlled calculating response curves with the following scripts: 2_1_response_curves_median.R executed by 2_1_response_curves_median.sh and 2_2_response_curves_bivariate.R executed by 2_2_response_curves_bivariate.sh. The code to project the models is saved in     iii_extend_of_suitable_habitat/scripts/8_projections/. The single models were projected with: 1_single_projections.R executed by 1_single_projections.sh. The ensembled model was projected using 2_ensembled_projection.R executed by 2_ensembled_projection.sh. note_projecting_large_raster_files.txt contains an idea how the ensembled model could be projected in an 10 x 10 m solution. Finally the projection of the ensembled model was transformed into an sf object and ESH was calculated using the intersection of the sf object with range. The code for the final step is saved in iii_extend_of_suitable_habitat/scripts/9_suitable_habitat/. 



#(iv) range: 
The range was calculated using the range.R script in iv_range/.



#(v) number of localities: 
The analysis is based on a single script, which can be found in: v_number_of_localities. 



#(vi) distinct genetic diversity: 

3 different methods were used to calculate distinct genetic diversity.

