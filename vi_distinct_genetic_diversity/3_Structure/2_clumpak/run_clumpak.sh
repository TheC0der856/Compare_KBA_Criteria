#!/bin/bash
#SBATCH -J clumpak
#SBATCH --nodes=1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task=1
#SBATCH -p skylake-96
#SBATCH --time=9-00:00:00
#SBATCH --mem=32G
#SBATCH --mail-type=END

# activate environment
source ~/.bashrc
mamba activate clumpak

# move to clumpaks home
cd $HOME/CLUMPAK/26_03_2015_CLUMPAK/CLUMPAK

# run calculation
perl CLUMPAK.pl \
  --id 3 \
  --dir /scratch/utr_gronefeld/clumpak \
  --file /scratch/utr_gronefeld/Structure_threader/results/structure2clumpak.zip

# deactivate environment
mamba deactivate
