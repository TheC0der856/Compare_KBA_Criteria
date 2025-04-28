#!/bin/bash
#SBATCH -t 1:60:00              # Zeitlimit
#SBATCH --mem=4000              # 4 GB RAM reserviert
#SBATCH -J quality_single_models
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
Rscript code/single_model_quality.R


# deactivate environment
mamba deactivate
