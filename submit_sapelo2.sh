#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=snakemake_assembly
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=24             
#SBATCH --time=100:00:00
#SBATCH --mem=100G
#SBATCH --output=/scratch/rx32940/snakemake_assembly.%j.out       
#SBATCH --error=/scratch/rx32940/snakemake_assembly.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL


cd /home/rx32940/github/Bacterial_Genome_Assembly_Pipeline/

source activate /home/rx32940/miniconda3/envs/Bacterial_Genome_Assembly_Pipeline

snakemake --cores 24 --use-conda --rerun-incomplete

snakemake --dag | dot -Tsvg > dag.svg # run this line to create a dag workflow for the pipeline

conda deactivate 


