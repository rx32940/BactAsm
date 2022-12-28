#!/bin/bash
#SBATCH --partition=bahl_salv_p
#SBATCH --job-name=bactasm
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=12             
#SBATCH --time=100:00:00
#SBATCH --mem=100G
#SBATCH --output=%x.%j.out    # Standard output log      
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL

source activate BactAsm

WORK="/scratch/rx32940/whole_genome/work/1.assemble/Bacterial_Genome_Assembly_Pipeline"
OUT="/scratch/rx32940/whole_genome/data/pipeline_out"
IN="/scratch/rx32940/whole_genome/data/sra"
REF="/scratch/rx32940/whole_genome/ref"

cd $WORK

# python $WORK/BactAsm.py \
# -l $IN/PAIRED_GENOMIC_WGS_ILLUMINA_11172022.txt \
# -t 24 \
# -f $REF/GCF_000007685.1_ASM768v1_genomic.fna \
# -o $OUT

# after running the last command, try to save sequences that couldn't be assembled in the last round
python $WORK/BactAsm.py \
-l $IN/biosample_withSRA_but_noScaffolds_28.txt \
-t 12 \
-f $REF/GCF_000007685.1_ASM768v1_genomic.fna \
-o $OUT

conda deactivate 


