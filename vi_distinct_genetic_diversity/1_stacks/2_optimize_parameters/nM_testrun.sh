#!/bin/bash
#SBATCH -t 60:00:00             # Zeitlimit
#SBATCH --mem=16G
#SBATCH -J denovomap
#SBATCH --mail-type=END
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10       # 10 CPUs pro Task
#SBATCH --output=denovomap_%M_%n.out
#SBATCH --error=denovomap_%M_%n.err
#SBATCH --array=1-6

# go to my scatch dir
cd /scratch/utr_gronefeld/combined_analyses

# starte shell neu
source ~/.bashrc
# activate stacks
mamba activate Stacks

# Setze M und n abhängig von der Array-ID (0-5)
n=$((SLURM_ARRAY_TASK_ID))          # n von 1 bis 6
M=$((SLURM_ARRAY_TASK_ID + 1))      # try also -1 and without 1

# Sampleliste (Subsample)
species_list=(
  SG003
  SG007
  SG026
  SG181
  T020
  T063
  T131
  T160
  T247
  SG208
)

# Temp-Verzeichnis für Subsample FASTQs
sampledir="nM_test/tmp_subsample"
mkdir -p $sampledir

# Symlinks zu den FASTQ-Dateien
for sample in "${species_list[@]}"; do
  ln -sf "$(realpath demultiplexed/${sample}.1.fq)" $sampledir/
  ln -sf "$(realpath demultiplexed/${sample}.2.fq)" $sampledir/
done

# Output-Verzeichnis für diese Kombination
outdir="nM_test/test_M${M}_n${n}"
mkdir -p "$outdir"

# Starte denovo_map.pl mit den richtigen Parametern
denovo_map.pl \
  -M $M -n $n -m 3 -r 0.8 \
  -o nM_test/test_M${M}_n${n} \
  --samples nM_test/tmp_subsample \
  --popmap nM_test/popmap.txt \
  --paired \
  --threads 10 \
  -X "populations:--vcf"

echo "Fertig: M=$M, n=$n"

#wieder deaktivieren
mamba deactivate

