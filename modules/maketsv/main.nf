process MAKETSV {
    debug true
    tag "${input_ch.getSimpleName()}"
    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/negedia/maketsv:v4.3.3'
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path(input_ch)

    output:
    path("Params"), type: "dir"
    path("DEMULTIPLEX*.csv"), emit: csv
    
    script:
    """
    echo "File to convert: ${input_ch.getSimpleName()}"

    createParams.R ${input_ch}
    toPrepare.R ${input_ch} TRUE csv ${input_ch.getSimpleName()} $params.bcl_mask $params.IndexReads
    """
}
