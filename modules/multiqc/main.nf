process RUNMULTIQC {
    debug true
    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/negedia/multiqc:v1.22.1'
    tag "${bcl_input.getSimpleName()}"
    publishDir "${params.outdir}" , mode: 'copy'
    
    input:
    tuple val(name), path(stats)

    output:
    path("*report.html"), emit: report
    path("*_data"), emit: data

    script:
    """
    multiqc -n $name --quiet ${stats}
    """

}