rule normalised_frequency:
    input:
        "shuf.a.bed.gz"
    output:
        "query.hist"
    shell:
        "zcat {input} | python frequency.py | sort -k1,1n > {output}"

rule lines:
    input:
        "query.hist"
    output:
        "lines_to_pull.tsv"
    shell:
        "python lines.py > {output}"

rule subsample:
    input:
        bed="shuf.a.bed.gz",
        lines="lines_to_pull.tsv"
    output:
        shuffled=temp("{sample}_shuffled_{rep}.bed.gz"),
        rescaled="{sample}_rescaled_{rep}.bed.gz"
    shell:
        """
        zcat {input.bed} | shuf | gzip > {output.shuffled}
        zcat {output.shuffled} | python rescaled.py | gzip > {output.rescaled}
        """

rule rescaled_hist:
    input:
        "{sample}_rescaled_{rep}.bed.gz"
    output:
        "{sample}_rescaled_{rep}.hist"
    shell:
        "zcat {input} | python frequency.py | sort -k1,1n > {output}"
