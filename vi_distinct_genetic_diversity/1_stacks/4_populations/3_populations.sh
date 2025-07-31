#!/bin/bash
#SBATCH -t 1:00:00               # time limit: one  hour
#SBATCH --mem=8000               # 8 GB RAM reserviert
#SBATCH -J populations
#SBATCH --mail-type=END
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12

# go to my working directory
cd /scratch/utr_gronefeld/combined_analyses

# starte shell neu
source ~/.bashrc

# activate stacks
mamba activate Stacks

# calculation
# --fstats was not calculated here, because to many files
# --phylip was not calculated here, because it is better to use vcf2phylip
populations -M popmaps/ID_Pop2.txt -P denovomap/calculated_files2 -t 12 -O populations  --vcf --genepop --structure --plink -p 25 -r 0.8 --min-maf 0.05 --write-single-snp

# deactivate environment
mamba deactivate