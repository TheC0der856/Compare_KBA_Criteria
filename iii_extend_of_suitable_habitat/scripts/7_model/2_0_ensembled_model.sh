#!/bin/bash
#SBATCH -t 0:10:00                # Zeitlimit
#SBATCH --mem=40000               # 4 GB RAM reserviert
#SBATCH -J EM
#SBATCH --mail-type=END
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4        # 4 CPUs pro Task

# go to working directory
cd /scratch/utr_gronefeld/run_model/

# start new shell
source ~/.bashrc

# activate environment
mamba activate R

# run R script
Rscript code/ensembled_model.R


# deactivate environment
mamba deactivate