#!/bin/bash
#SBATCH --partition=highmem_30d_p
#SBATCH --job-name=snakemake_assembly
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=24             
#SBATCH --time=300:00:00
#SBATCH --mem=200G
#SBATCH --output=/scratch/rx32940/assembly_4.%j.out       
#SBATCH --error=/scratch/rx32940/assembly_4.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL

module load snakemake/5.7.1-foss-2019b-Python-3.7.4

cd /home/rx32940/github/Bacterial_Genome_Assembly_Pipeline/
snakemake --cores 24 --use-conda 