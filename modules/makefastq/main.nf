process BCLCONVERT {
    disk "${params.bcl_disk} GB"
    memory "${params.bcl_mem} GB"
    tag "${bcl_input.getSimpleName()}"
    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/negedia/bclconvert:v4.3.6'
    publishDir "$params.outdir" , mode: 'copy'

    input:
    path(bcl_input)
    path(rundir_ch)

    output:
    path("Reads/*"), type: "dir", emit: ch_multiqc_projects

    script:
    lane_split = params.bcl_lane_splitting ? "" : "--no-lane-splitting true"
    cpu = $task.cpus / 2
    """
    bcl-convert \\
        --bcl-input-directory $rundir_ch \\
        --output-directory $params.bcl_output_dir \\
        --sample-sheet $bcl_input \\
        --bcl-num-parallel-tiles  \\
        --bcl-num-conversion-threads $cpu \\
        --bcl-num-compression-threads $cpu \\
        --strict-mode true \\
        --bcl-sampleproject-subdirectories true \\
        $lane_split \\
        --output-legacy-stats true
    """
}

