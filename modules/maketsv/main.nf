process MAKETSV {
    debug true
    tag "${input_ch.getSimpleName()}"
    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/negedia/maketsv:v4.3.3'
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path(input_ch)

    output:
    path("Params"), type: "dir"
    path("*.csv"), emit: csv
    
    script:
    """
    echo "File to convert: ${input_ch.getSimpleName()}"
    mkdir -p Params/
    header=\$(head -n 1 ${input_ch})
    awk -F"\t" 'NR == 1 { header=\$0; next } { print >> ("Params/"\$12 ".txt") }' ${input_ch}

    for file in Params/*; do
        if [[ -f "\$file" ]]; then
            echo "\$header" | cat - "\$file" > temp && mv temp "\$file"
        fi
    done

    toPrepare.R ${input_ch} ${input_ch.getSimpleName()}.csv TRUE txt ${input_ch.getSimpleName()} $params.b2f_mask
    """
}