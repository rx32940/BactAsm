rule trim:
    input:
        left= output_dir + "SRA/{sample}_1.fastq.gz",
        right= output_dir + "SRA/{sample}_2.fastq.gz"
    output:
        left_paired = output_dir_trim + "pair/{sample}_1_paired_trimmed.fastq.gz",
        right_paired = output_dir_trim + "pair/{sample}_2_paired_trimmed.fastq.gz"
    conda:
        "../env/fastp.yaml"
    threads: THREADS
    params:
        pe="-c"
    shell:
        """
        fastp {params.pe} --thread {threads} --in1 {input.left} --in2 {input.right} \
        --out1 {output.left_paired} --out2 {output.right_paired}
        """

rule fastqc_after_trim:
    input:
        fastq=expand([output_dir_trim + "pair/{sample}_1_paired_trimmed.fastq.gz", 
        output_dir_trim + "pair/{sample}_2_paired_trimmed.fastq.gz"], sample=config["samples"])
    output:
        zip = expand([output_dir_trim + "trim_qc/{sample}_1_paired_trimmed_fastqc.zip",
         output_dir_trim + "trim_qc/{sample}_2_paired_trimmed_fastqc.zip"], sample=config["samples"]),
        html = expand([output_dir_trim + "trim_qc/{sample}_1_paired_trimmed_fastqc.html",
         output_dir_trim + "trim_qc/{sample}_2_paired_trimmed_fastqc.html"], sample=config["samples"])
    conda:
        "../env/fastqc.yaml"
    params:
        output_dir=output_dir_trim
    shell:
        "fastqc -t 12 -o {params.output_dir}/trim_qc -f fastq {input.fastq}"

rule multiqc_after_trim:
    input:
        zip = expand([output_dir_trim + "trim_qc/{sample}_1_paired_trimmed_fastqc.zip",
         output_dir_trim + "trim_qc/{sample}_2_paired_trimmed_fastqc.zip"], sample=config["samples"])
    output:
        output_dir_trim + "multiqc_report.html"
    conda:
        "../env/multiqc.yaml"
    params:
        output_dir=output_dir_trim
    shell:
        "multiqc {input.zip} -o {params.output_dir}"