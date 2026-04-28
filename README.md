## Comparison of metrics for identification of Key Biodiversity Areas (KBAs)



Compare all metrics to identify KBAs with criteria A1 or B1: (i) mature individuals, (ii) area of occupancy, (iii) extend of suitable habitat, (iv) range, (v) number of localities, and (vi) distinct genetic diversity. Additionally a structure analysis and a PCA was conducted, potential KBAs were identified and the results of all metrics were compared.


Detailed discriptions of all calculations can be found at: 


Gronefeld, S. C., López, H., Hawlitschek, O., Schulte-Middelmann, T., Hofmann, F., Tandukar, P., & Hochkirch, A. (2026). Comparison of metrics for identifying Key Biodiversity Areas. Biological Conservation, 319, 111863. https://doi.org/10.1016/j.biocon.2026.111863


Assessing genetic data: 

First of all the raw reads were processed in assess_genetic_data/1_stacks. In assess_genetic_data/2_quality control a PCA was conducted using plink. In assess_genetic_data/3_structure a structure clusters were calculated and the most likely cluster was selected. This analyses was done before its results were used to calculate (vi) distinct genetic diversity. 


(i) mature individuals: 
The analysis is based on a single script, which can be found in: i_number_of_mature_individuals. 



(ii) area of occupancy: 
