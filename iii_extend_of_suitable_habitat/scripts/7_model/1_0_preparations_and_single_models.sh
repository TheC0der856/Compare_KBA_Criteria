#!/bin/bash
#SBATCH -t 10:00:00                # Zeitlimit
#SBATCH --mem=1500000              # 150 GB RAM reserviert
#SBATCH -J preparations_and_single_models
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
Rscript code/preparations_and_single_models.R


# deactivate environment
mamba deactivate