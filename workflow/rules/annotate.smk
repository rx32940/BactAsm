rule prokka:
    input:
        output_dir_asm + "denovo/{sample}/scaffolds.fasta"
    output:
        output_dir_prokka + "{sample}/{sample}.gff"
    conda:
        "../env/prokka.yaml"
    params:
        genus = config["genus"],
        kingdom = config["kingdom"],
        output_dir = output_dir_prokka
    shell:
        """
        prokka -kingdom {params.kingdom} -genus {params.genus} \
        -outdir {params.output_dir}{wildcards.sample} \
        -prefix {wildcards.sample} \
        {input} --force
        """