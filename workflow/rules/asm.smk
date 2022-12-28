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
        asm_out=output_dir_asm
    threads: THREADS
    shell:
        """
        spades.py --pe1-1 {input.left} \
        --pe1-2 {input.right} \
        -t {threads} \
        {params.post_process} \
        -o {params.asm_out}/denovo/{wildcards.sample}
        """

rule quast_denovo:
    input:
        final=rules.spades.output
    output:
        output_dir_asm + "quast/{sample}/report.tsv"
    threads: THREADS
    conda:
        "../env/quast.yaml"
    params:
        reference=" -R " + reference if reference != '' else ' ',
        output_dir=output_dir_asm
    shell:
        """
        quast{params.reference} {input.final} -o {params.output_dir}/quast/{wildcards.sample} -t {threads}
        """

rule multiqc_quast:
    input:
        report= expand([output_dir_asm + "quast/{sample}/report.tsv"], sample=config["samples"])
    output:
        output_dir_asm + "multiqc_quast.html"
    conda:
        "../env/multiqc.yaml"
    params:
        output_dir=output_dir_asm
    shell:
        """
        multiqc {input.report} -d -dd 1 -o {params.output_dir} -n multiqc_quast
        """

