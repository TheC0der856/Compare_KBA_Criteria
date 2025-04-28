#!/bin/bash
#SBATCH -t 600:00:00                # Zeitlimit
#SBATCH --mem=1500000               # 150 GB RAM reserviert
#SBATCH -J single_projections
#SBATCH --mail-type=END
#SBATCH --ntasks=1
#SBATCH --partition=bigmem
#SBATCH --cpus-per-task=8           # 8 CPUs pro Task

# go to working directory
cd /scratch/utr_gronefeld/run_model/

# start new shell
source ~/.bashrc

# activate environment
mamba activate R

# run R script
Rscript code/single_projections.R


# deactivate environment
mamba deactivate