process RUNMULTIQC {
    debug true
    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/negedia/multiqc:v1.23'
    tag "${bcl_input.getSimpleName()}"
    publishDir "${params.outdir}" , mode: 'copy'
    
    input:
    path(bcl_input)
    path(stats)

    output:
    path("${bcl_input.getSimpleName()}_report.html"), emit: report
    path("${bcl_input.getSimpleName()}_data"), emit: data

    script:
    """
    multiqc -n ${bcl_input.getSimpleName()} .
    """

}