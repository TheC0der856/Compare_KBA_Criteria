#!/bin/bash
#SBATCH -t 70:00:00               # Zeitlimit
#SBATCH --mem=40000               # 40 GB RAM reserviert
#SBATCH -J populations
#SBATCH --mail-type=END
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24

# go to my working directory
cd /scratch/utr_gronefeld/combined_analyses

# starte shell neu
source ~/.bashrc

# activate stacks
mamba activate Stacks

# calculation
populations -M cstacks/catalog/ID_and_Pop4.txt -P denovomap2 -t 24 -O populations  --fstats --vcf --genepop --structure --plink --phylip -p 4 -r 0.8 --min-maf 0.05 --write-single-snp

# deactivate environment
mamba deactivate
