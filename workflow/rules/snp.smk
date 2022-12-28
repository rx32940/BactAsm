if reference:
    rule call_SNPs:
        input:
            left=output_dir_trim + "pair/{sample}_1_paired_trimmed.fastq.gz",
            right=output_dir_trim + "pair/{sample}_2_paired_trimmed.fastq.gz"
        output:
            directory(os.path.join(output_dir_map,"individual_snps","{sample}"))
        conda:
            "../env/snippy.yaml"
        threads: THREADS
        params:
            ref=reference
        shell:
            """
            snippy --rgid --cpus {threads} --outdir {output} --ref {params.ref} --R1 {input.left} --R2 {input.right}
            """

    rule get_coreSNPs:
        input:
            expand([os.path.join(output_dir_map, "individual_snps" , "{sample}")], sample = SAMPLES)
        output:
            os.path.join(output_dir_map , "coreSNPs","clean.full.aln")
        conda:
            "../env/snippy.yaml"
        threads: THREADS
        shell:
            """
            snippy-core --ref {reference} {input} --prefix {output_dir_map}"coreSNPs/core"
            snippy-clean_full_aln {output_dir_map}"coreSNPs/core" > {output}
            """
else:
    rule no_ref:
        log: output_dir_map + "no_reference.log"






    
