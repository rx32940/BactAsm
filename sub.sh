#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=bactasm
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=2             
#SBATCH --time=100:00:00
#SBATCH --mem=100G
#SBATCH --output=%x.%j.out             
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL

source activate BactAsm

WORK="/scratch/rx32940/whole_genome/work/1.assemble/Bacterial_Genome_Assembly_Pipeline"

cd $WORK

# conda config --set channel_priority strict
snakemake --conda-frontend mamba --cores --use-conda --nolock

conda deactivate