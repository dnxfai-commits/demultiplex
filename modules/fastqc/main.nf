process FASTQC {
    debug true
    tag "$labname"
    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/negedia/fastqc:v0.12.1'
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.endsWith("html"))               "FASTQC/html/$filename"
      else if (filename.endsWith("zip"))                "FASTQC/zip/$filename"
      else null
    }

    when:
    !params.skip_fastqc

    input:
    tuple val(samplename), val(genome), val(labname), val(projectname), val(condition), path(fastq)

    output:
    tuple val(samplename), val(genome), val(labname), val(projectname), val(condition), path("*.html"), emit: fastqc_html
    tuple val(samplename), val(genome), val(labname), val(projectname), val(condition), path("*.zip"), emit: fastqc_zip

    script:
    """
    fastqc --svg --threads 2 --quiet $fastq
    """

    stub:
    """
    touch ${labname}.html
    touch ${labname}.zip
    """
}