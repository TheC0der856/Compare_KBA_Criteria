#!/bin/bash
#SBATCH -t 1:60:00              # Zeitlimit
#SBATCH --mem=4000              # 4 GB RAM reserviert
#SBATCH -J respplot
#SBATCH --mail-type=END
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1       # 1 CPUs pro Task

# go to working directory
cd /scratch/utr_gronefeld/run_model/

# new start shell
source ~/.bashrc

# activate environment
mamba activate R

# run R script
Rscript code/response_curve_plot_median.R


# deactivate environment
mamba deactivate