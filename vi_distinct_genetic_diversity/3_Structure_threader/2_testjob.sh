#!/bin/bash
#SBATCH -J Structure
#SBATCH --nodes=1
#SBATCH --ntasks 20
#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mem=4G
#SBATCH --mail-type=END

# go to working directory
cd /scratch/utr_gronefeld/Structure_threader

# load structure
source ~/.bashrc
conda activate Structure_threader

# run STRUCTURE with Structure_threader
structure_threader run  -K 5 -R 20 -i populations_cleaned.structure -t 20 -o testresults -st ~/mambaforge-pypy3/envs/structure/bin/structure --seed 1234 --params mainparams10b20r.txt

# deactivate environment
conda deactivate
