#!/bin/bash
#SBATCH -t 10:00:00             # Zeitlimit
#SBATCH --mem=4000              # 4 GB RAM reserviert
#SBATCH -J demultiplex
#SBATCH --mail-type=END
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8       # 8 CPUs pro Task

# go to my working dir
cd /scratch/utr_gronefeld/

# start new shell 
source ~/.bashrc
# activate stacks
mamba activate Stacks

# commands
process_radtags -1 Laborergebnisse24/00_fastq/1_R1_001.fastq -2 Laborergebnisse24/00_fastq/1_R2_001.fastq -i fastq -b Laborergebnisse24/barcodes/barcodes3_1.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 65 $process_radtags -1 Laborergebnisse24/00_fastq/2_R1_001.fastq -2 Laborergebnisse24/00_fastq/2_R2_001.fastq -i fastq -b Laborergebnisse24/barcodes/barcodes3_2.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 65 $process_radtags -1 Laborergebnisse24/00_fastq/3_R1_001.fastq -2 Laborergebnisse24/00_fastq/3_R2_001.fastq -i fastq -b Laborergebnisse24/barcodes/barcodes3_3.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 65 $process_radtags -1 Laborergebnisse24/00_fastq/4_R1_001.fastq -2 Laborergebnisse24/00_fastq/4_R2_001.fastq -i fastq -b Laborergebnisse24/barcodes/barcodes3_4.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 65 $process_radtags -1 Laborergebnisse24/00_fastq/5_R1_001.fastq -2 Laborergebnisse24/00_fastq/5_R2_001.fastq -i fastq -b Laborergebnisse24/barcodes/barcodes4_1.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 65 $process_radtags -1 Laborergebnisse24/00_fastq/6_R1_001.fastq -2 Laborergebnisse24/00_fastq/6_R2_001.fastq -i fastq -b Laborergebnisse24/barcodes/barcodes4_2.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 65 $process_radtags -1 Laborergebnisse24/00_fastq/7_R1_001.fastq -2 Laborergebnisse24/00_fastq/7_R2_001.fastq -i fastq -b Laborergebnisse24/barcodes/barcodes4_3.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 65 $process_radtags -1 Laborergebnisse24/00_fastq/8_R1_001.fastq -2 Laborergebnisse24/00_fastq/8_R2_001.fastq -i fastq -b Laborergebnisse24/barcodes/barcodes4_4.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 65 $process_radtags -1 Laborergebnisse24/00_fastq/10_R1_001.fastq -2 Laborergebnisse24/00_fastq/10_R2_001.fastq -i fastq -b Laborergebnisse24/barcodes/barcodes5_1.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 6$process_radtags -1 Laborergebnisse24/00_fastq/11_R1_001.fastq -2 Laborergebnisse24/00_fastq/11_R2_001.fastq -i fastq -b Laborergebnisse24/barcodes/barcodes5_2.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 6$process_radtags -1 Laborergebnisse24/00_fastq/13_R1_001.fastq -2 Laborergebnisse24/00_fastq/13_R2_001.fastq -i fastq -b Laborergebnisse24/barcodes/barcodes5_3.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 6$process_radtags -1 Laborergebnisse24/00_fastq/15_R1_001.fastq -2 Laborergebnisse24/00_fastq/15_R2_001.fastq -i fastq -b Laborergebnisse24/barcodes/barcodes5_4.txt -o combined_analyses/demultiplexed/ -cqr --renz-2 sbfI --renz-1 mseI -t 6$
# deaktivate environement
mamba deactivate

