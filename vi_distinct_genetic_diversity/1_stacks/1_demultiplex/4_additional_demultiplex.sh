#!/bin/bash
#SBATCH -t 10:00:00             # Zeitlimit
#SBATCH --mem=4000              # 4 GB RAM reserviert
#SBATCH -J demultiplex
#SBATCH --mail-type=END
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8       # 8 CPUs pro Task

# go to my working directory
cd /scratch/utr_gronefeld/

# start new shell
source ~/.bashrc
# activate stacks
mamba activate Stacks

# demultiplex
# SG122 is ignored, somehow it must have been exchanged in the lab and I could not track down the actual ID
process_radtags -1 outgroup/outgroup_R1_001.fastq -2 outgroup/outgroup_R2_001.fastq -i fastq -b outgroup/barcodes.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 65 --disable-rad-check --threads 8

# deactivate environment
mamba deactivate