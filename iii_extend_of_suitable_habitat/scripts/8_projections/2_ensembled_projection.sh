#!/bin/bash
#SBATCH -t 600:00:00                # Zeitlimit
#SBATCH --mem=1500000               # 150 GB RAM reserviert
#SBATCH -J EMprojection
#SBATCH --mail-type=END
#SBATCH --partition=bigmem
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

# go to working directory
cd /scratch/utr_gronefeld/run_model/

# start new shell
source ~/.bashrc

# activate environment
mamba activate R

# run R script
Rscript code/ensembled_projection.R


# deactivate environment
mamba deactivate