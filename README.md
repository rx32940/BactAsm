# BactAsm

### Bacterial Genome Assembly Pipeline

This snakemake pipeline allows direct download from NCBI's SRA database with fastq-dump

The pipeline handles raw reads records of the bacterial genome from **SRA Accessions** to **Annotated _de novo_ Assemblies**

**Variant calling** will also be performed after mapped to the reference genomes provided. **Core SNPs** called from regions shared by all input sequences will be produced at the end of the pipline.

All the output files will be assessed by **1) fastqc, 2) QUAST**

## Sample workflow:
![dag](https://user-images.githubusercontent.com/31255012/209852338-0fbaee48-48b8-442d-b71e-98a965337e91.svg)


## Requirement
    - install miniconda 3
    - create working directory

## How to use:



### STEP 1: Download repo, and Change into BactAsm directory
```
git clone https://github.com/rx32940/BactAsm.git

cd BactAsm
```

### STEP 2: Create Environment
create environmental.yaml file
    - create conda env for snakemake
    - add dependencies for plotting
``` 
conda env env create -n BactAsm --file env/environment.yaml python=3.7
```


### use with command line:

```
python BactAsm.py -h
    usage: BactAsm.py [-h] [-s] [-b] [-l] [-f] [-o] [-t] [-k] [-g] [-c]

    Fetch SRA records from NCBI and perform de novo assemble & read alignments to reference genome

    optional arguments:
    -h, --help        show this help message and exit
    -s , --sra        SRA accession ID you would like to download
    -b , --sampleID   sampleID of the sample (this can be same as the SRA ID)
    -l , --list       input list (provide each sample' SampleID and sraID in a row, separated by TAB)
    -f , --ref        reference genome (required)
    -o , --output     output directory
    -t , --thread     number of threads to use
    -k , --kingdom    which kingdom the genome is from, default is Bacteria
    -g , --genus      which genus the genome is from, default is Leptospira
```

### OR: use by modifying config files

    1) modify config file
    2) Add the Bacterial genus of interst to config.yaml
    3) Add SAMN Accession and SRA Accession to config.yaml
    4) add expected output dir to config.yaml
    5) add directory to the reference genome to the config file if available
    6) refer to the examples in the config file for exact instruction
    7) modify the maximum allowance of threads in config.yaml

---

#### To run on UGA Sapelo2 Cluster

```sbatch submit_sapelo2.sh```


---

### Workflow:
   
#### Rule 1: raw.smk

1) download fastq files from NCBI with samples provided in the config file
2) fastqc all the raw reads files
3) combine fastqc with multiqc

#### Rule 2: trim.smk

1) trim raw reads with fastp
2) fastqc paired trimmed reads again
3) aggregate fastqc reports with multiqc

#### Rule 3: asm.smk

1) use SPAdes for de novo assemble ```outputdir/asm```
2) use quast w/o reference genome for de novo assemblies assessments
3) aggregate assessments with multiqc

#### Rule 4: annotate.smk
    
1) use PROKKA for genome annotation

#### Rule 5: snp.smk

1) use Snippy to call variant from the reference genome provided
    (no need to index the reference genome)
3) aggregate variants for core SNPs detection


    

