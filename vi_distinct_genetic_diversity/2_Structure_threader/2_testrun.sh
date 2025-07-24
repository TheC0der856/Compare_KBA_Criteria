#!/bin/bash
#SBATCH -J Structure
#SBATCH --ntasks 20
#SBATCH --cpus-per-task=1
#SBATCH --time=5-00:00:00
#SBATCH --mem=8G
#SBATCH --mail-type=END

# go to working directory
cd /scratch/utr_gronefeld/Structure_threader

# load structure
source ~/.bashrc
conda activate Structure_threader

# run STRUCTURE with Structure_threader
structure_threader run  -K 5 -R 20 -i populations_cleaned.structure -t 20 -o output9 -st ~/mambaforge-pypy3/envs/structure/bin/structure --seed 1234 --params mainparams9.txt

# deactivate environment
conda deactivate