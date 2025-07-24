#!/bin/bash
#SBATCH -t 10:00:00             # Zeitlimit
#SBATCH --mem=4000              # 4 GB RAM reserviert
#SBATCH -J demultiplex
#SBATCH --mail-type=END
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8       # 8 CPUs pro Task

# go to my scatch dir
cd /scratch/utr_gronefeld/

# starte shell neu
source ~/.bashrc
# activate stacks
mamba activate Stacks

# Dein eigentlicher Befehl
process_radtags -1 outgroup/outgroup_R1_001.fastq -2 outgroup/outgroup_R2_001.fastq -i fastq -b outgroup/barcodes.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 65 --disable-rad-check --threads 8

# Umgebung wieder deaktivieren
mamba deactivate
