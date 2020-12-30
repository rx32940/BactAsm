rule trim:
    input:
        left= output_dir + "SRA/{sample}_1.fastq.gz",
        right= output_dir + "SRA/{sample}_2.fastq.gz"
    output:
        left_paired = output_dir_trim + "pair/{sample}_1_paired_trimmed.fastq.gz",
        right_paired = output_dir_trim + "pair/{sample}_2_paired_trimmed.fastq.gz",
        left_unpaired= output_dir_trim + "unpair/{sample}_1_unpaired_trimmed.fastq.gz",
        right_unpaired= output_dir_trim + "unpair/{sample}_2_unpaired_trimmed.fastq.gz"
    conda:
        "../env/trimmomatic.yaml"
    threads: 12
    params:
        pe="PE",
        trimmer="ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36"
    shell:
        """
        trimmomatic {params.pe} -threads 12 {input.left} {input.right} \
        {output.left_paired} {output.left_unpaired} \
        {output.right_paired} {output.right_unpaired} \
        {params.trimmer}
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