#!/bin/bash
#SBATCH --job-name=vcf2phylip
#SBATCH --output=vcf2phylip_%j.out
#SBATCH --error=vcf2phylip_%j.err
#SBATCH --time=0:25:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1

# go to working directory
cd /scratch/utr_gronefeld/combined_analyses/populations

# run vcf2phylip
/home/utr_gronefeld/vcf2phylip/vcf2phylip.py -i populations.snps.vcf


# This is good for SplitsTree.
# Search for missmatch in islands