# Bacterial_Genome_Assembly_Pipeline

## Requirement
    - install miniconda 3
    - create working directory

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
