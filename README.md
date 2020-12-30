# Bacterial_Genome_Assembly_Pipeline

This snakemake pipeline allows direct download from NCBI's SRA database with fastq-dump

The pipeline handles raw reads records of the bacterial genome from **SRA Accessions** to **Annotated _de novo_ Assemblies**

If reference genome is provided, short reads will be mapped to the reference genome with **BWA Mem**

All the output files will be assessed by **1) fastqc, 2) QUAST, 3) Qualimap**


## Requirement
    - install miniconda 3
    - create working directory

## How to use:

    1) modify config file
    2) Add the Bacterial genus of interst to config.yaml
    3) Add SAMN Accession and SRA Accession to config.yaml
    4) add expected output dir to config.yaml
    5) add directory to the reference genome to the config file if available
    6) refer to the examples in the config file for exact instruction
    7) modify the maximum allowance of threads in config.yaml

---
# Working locally

## STEP 1: Create Environment
    1) create environmental.yaml file
        - create conda env for snakemake
        - add dependencies for plotting
    2) conda env create --name Bacterial_Genome_Assembly_Pipeline --file env/environment.yaml
    3) update env: conda env update -f env/environment.yaml

## STEP 2: Specify Rules in Snakefile
    1) **rule all**: if no output argument provided, will run the first rule, which will run the complete pipeline
    2) snakemake --use-conda --cores 1
    3) snakemake --dag | dot -Tsvg > dag.svg

sample pipeline: https://github.com/tanaes/snakemake_assemble (has info about running on the cluster)
https://github.com/jlanga/smsk

---

# To run on UGA Sapelo2 Cluster

```sbatch submit_sapelo2.sh```


---

# Workflow:
   
### Rule 1: raw.smk

    1) download fastq files from NCBI with samples provided in the config file
    2) fastqc all the raw reads files
    3) combine fastqc with multiqc

### Rule 2: trim.smk

    1) trim raw reads with trimmomatic using trimmer: 
    ```ILLUMINACLIP:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 
    MINLEN:36```
    2) fastqc paired trimmed reads again
    3) aggregate fastqc reports with multiqc

### Rule 3: asm.smk

    1) use SPAdes for de novo assemble ```outputdir/asm```
    2) use quast w/o reference genome for de novo assemblies assessments
    3) aggregate assessments with multiqc

### Rule 4: annotate.smk
    
    1) use PROKKA for genome annotation

### Rule 5: map.smk

    1) use bwa mem to map **trimmed** short reads to the reference genome if provided
        (no need to index the reference genome)
    2) use qualimap to assess the mapped alignments
    3) aggregate the assessments with multiqc

**To DO**

- [ ] fix cluster.json to attribute resources for each function
- [ ] Test if without reference works
    

