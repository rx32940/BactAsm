rule spades:
    input:
        left= output_dir_trim + "pair/{sample}_1_paired_trimmed.fastq.gz",
        right= output_dir_trim + "pair/{sample}_2_paired_trimmed.fastq.gz"
    output:
        output_dir_asm + "denovo/{sample}/scaffolds.fasta"
    conda:
        "../env/spades.yaml"
    params:
        post_process="--careful --mismatch-correction",
        output_dir=output_dir_asm
    threads: 12
    shell:
        """
        spades.py --pe1-1 {input.left} \
        --pe1-2 {input.right} \
        -t {threads} \
        {params.post_process} \
        -o {params.output_dir}/denovo/{wildcards.sample}
        """

rule quast_denovo:
    input:
        output_dir_asm + "denovo/{sample}/scaffolds.fasta"
    output:
        output_dir_asm + "quast/{sample}/report.tsv"
    threads: 12
    conda:
        "../env/quast.yaml"
    params:
        output_dir=output_dir_asm
    shell:
        """
        quast {input} -o {output} -t {threads}
        """

rule multiqc_quast:
    input:
        report= expand([output_dir_asm + "quast/{sample}/report.tsv"], sample=config["samples"])
    output:
        output_dir_asm + "quast_asm.html"
    conda:
        "../env/multiqc.yaml"
    params:
        output_dir=output_dir_asm
    shell:
        """
        multiqc {input.report} -d -dd 1 -o {params.output_dir} -n quast_asm
        """

