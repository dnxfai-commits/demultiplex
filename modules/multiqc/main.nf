process RUNMULTIQC {
    debug true
    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/negedia/multiqc:v1.23'
    tag "${bcl_input.getSimpleName()}"
    publishDir "${params.outdir}" , mode: 'copy'
    
    input:
    path(bcl_input)
    path(reports)

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
    tag "${project.baseName}"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.endsWith("fastqc.html"))              "Reads/$project_name/fastqc/$filename"
      else if (filename.endsWith("report.html"))              "Reads/$project_name/multiqc/$filename"
      else if (filename.endsWith("report_data"))              "Reads/$project_name/multiqc/$filename"
      else if (filename.endsWith("md5"))                      "Reads/$project_name/$filename"
      else null
    }
    
    input:
    path(project)

    output:
    tuple val(project_name), path("*_fastqc.{zip,html}"), emit: fastqc
    tuple val(project_name), path("${project_name}_report.html"), emit: report
    tuple val(project_name), path("${project_name}_report_data"), emit: data

    script:
    project_name = project.baseName
    """
    fastqc -t 15 --quiet ${project_name}/* --outdir .
    multiqc -n ${project_name}_report .
    md5sum ${project_name}/* > ${project_name}.md5
    """
}
