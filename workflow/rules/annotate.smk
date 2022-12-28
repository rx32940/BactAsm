rule prokka:
    input:
        final=rules.spades.output
    output:
        os.path.join(output_dir_prokka ,"{sample}", "{sample}.gff")
    conda:
        "../env/prokka.yaml"
    params:
        genus = config["genus"],
        kingdom = config["kingdom"],
        output_dir = output_dir_prokka
    shell:
        """
        sed -re 's/(_length)[^=]*$/\1/' {input.final} > {params.output_dir}{wildcards.sample}.fasta

        prokka -kingdom {params.kingdom} -genus {params.genus} \
        -outdir {params.output_dir}{wildcards.sample} \
        -prefix {wildcards.sample} \
        {params.output_dir}{wildcards.sample}.fasta --force

        rm {params.output_dir}{wildcards.sample}.fasta
        """