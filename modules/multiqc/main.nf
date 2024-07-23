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
    path("${bcl_input.getSimpleName()}_report_data"), emit: data

    script:
    """
    multiqc -n ${bcl_input.getSimpleName()}_report .
    """
}

process PROJECTMULTIQC {
    debug true
    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/negedia/multiqc:v1.23'
    tag "${bcl_input.getSimpleName()}"
    publishDir "${params.outdir}" , mode: 'copy'
    
    input:
    path(project)

    output:
    tuple val(projects_name), path("*_fastqc.{zip,html}"), emit: fastqc

    script:
    project_name = project.baseName
    """
    fastqc -t 15 --quiet ${project_name}/* --outdir .
    multiqc -n ${project_name}_report .
    """
}
