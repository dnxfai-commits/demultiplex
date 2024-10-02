process BCLCONVERT {
    disk "${params.b2f_disk} GB"
    memory "${params.b2f_mem} GB"
    tag "${bcl_input.getSimpleName()}"
    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/negedia/bclconvert:v4.3.6'
    publishDir "$params.outdir" , mode: 'copy'

    input:
    path(bcl_input)
    path(rundir_ch)

    output:
    path("Reads/*"), type: "dir", emit: ch_multiqc_projects

    script:
    lane_split = params.lane_splitting ? "--no-lane-splitting false" : "--no-lane-splitting true"
    """
    bcl-convert \\
        --bcl-input-directory $rundir_ch \\
        --output-directory $params.b2f_output_dir \\
        --sample-sheet $bcl_input \\
        --bcl-num-parallel-tiles 16 \\
        --bcl-num-conversion-threads 16 \\
        --bcl-num-compression-threads 16 \\
        --strict-mode true \\
        --bcl-sampleproject-subdirectories true \\
        $lane_split \\
        --output-legacy-stats true
    """
}

