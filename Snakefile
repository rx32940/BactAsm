configfile: "config.yaml"
# print(config["samples"])
# lambda wildcards: config["samples"][wildcards.sample] # get the value of the key from config dict in a loop

rule all:
    input: 
        "/home/rx32940/snakemake_assembly_workdir/data/multiqc_report.html"

rule fastq_dump:    
    output: 
        "/home/rx32940/snakemake_assembly_workdir/data/SRA/{sample}_1.fastq.gz", # expected output is the value of the dict in config file
        "/home/rx32940/snakemake_assembly_workdir/data/SRA/{sample}_2.fastq.gz"
    threads: 6
    conda:
        "env/qc_env.yaml"
    params:
        sra=lambda wildcards: config["samples"][wildcards.sample],
        format="--gzip",
        pe="--split-files"
    shell:
        """
        fastq-dump {params.format} {params.pe} -O data/SRA {params.sra}
        mv /home/rx32940/snakemake_assembly_workdir/data/SRA/{params.sra}_1.fastq.gz /home/rx32940/snakemake_assembly_workdir/data/SRA/{wildcards.sample}_1.fastq.gz
        mv /home/rx32940/snakemake_assembly_workdir/data/SRA/{params.sra}_2.fastq.gz /home/rx32940/snakemake_assembly_workdir/data/SRA/{wildcards.sample}_2.fastq.gz
        """


rule fastqc:
    input:
        fastq=expand(["/home/rx32940/snakemake_assembly_workdir/data/SRA/{sample}_1.fastq.gz",
        "/home/rx32940/snakemake_assembly_workdir/data/SRA/{sample}_2.fastq.gz"], sample=config["samples"])
    output:
        zip = expand(["/home/rx32940/snakemake_assembly_workdir/data/SRA_fastqc/{sample}_1_fastqc.zip",
         "/home/rx32940/snakemake_assembly_workdir/data/SRA_fastqc/{sample}_2_fastqc.zip"], sample=config["samples"]),
        html = expand(["/home/rx32940/snakemake_assembly_workdir/data/SRA_fastqc/{sample}_1_fastqc.html",
         "/home/rx32940/snakemake_assembly_workdir/data/SRA_fastqc/{sample}_2_fastqc.html"], sample=config["samples"])
    conda:
        "/home/rx32940/snakemake_assembly_workdir/env/qc_env.yaml"
    shell:
        "fastqc -t 12 -o /home/rx32940/snakemake_assembly_workdir/data/SRA_fastqc -f fastq {input.fastq}"

rule multiqc:
    output:
        "/home/rx32940/snakemake_assembly_workdir/data/multiqc_report.html"
    conda:
        "/home/rx32940/snakemake_assembly_workdir/env/qc_env.yaml"
    shell:
        "multiqc /home/rx32940/snakemake_assembly_workdir/data/SRA_fastqc/*fastqc.zip -o data"




