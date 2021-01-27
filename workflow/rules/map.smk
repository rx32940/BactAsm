if reference:
    rule map:
        input:
            left=output_dir_trim + "pair/{sample}_1_paired_trimmed.fastq.gz",
            right=output_dir_trim + "pair/{sample}_2_paired_trimmed.fastq.gz"
        output:
            output_dir_map + "sorted_bam/{sample}.sorted.bam"
        conda:
            "../env/bwa.yaml"
        threads: THREADS
        params:
            ref=reference
        shell:
            """
            bwa index {params.ref}
            bwa mem -t {threads} {params.ref} {input.left} {input.right} | samtools sort -o {output} -
            """

    rule qualimap:
        input:
            output_dir_map + "sorted_bam/{sample}.sorted.bam"
        output:
            directory(output_dir_map + "qualimap/{sample}")
        conda:
            "../env/qualimap.yaml"
        threads: THREADS
        shell:
            """
            qualimap bamqc -bam {input} -outdir {output} -nt {threads}
            """
    
    rule multiqc_map:
        input:
            expand(output_dir_map + "qualimap/{sample}", sample=SAMPLES)
        output:
            output_dir_map + "multiqc_cov/qualimap_cov_multiqc.html"
        conda:
            "../env/multiqc.yaml"
        params:
            output_dir = output_dir_map
        shell:
            """
            multiqc {input} -o {params.output_dir}/multiqc_cov -n qualimap_cov_multiqc
            """
else:
    rule no_ref:
        log: output_dir_map + "no_reference.log"






    
