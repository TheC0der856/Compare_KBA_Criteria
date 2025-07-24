#!/bin/bash
#SBATCH -t 140:00:00              # time limit
#SBATCH --mem=100000
#SBATCH -J denovo
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
denovo_map.pl --popmap popmaps/ID_Pop1.txt --samples demultiplexed/ --threads 24 -o denovomap/calculated_files2 -M 3 -n 4

# deactivate environment
mamba deactivate

