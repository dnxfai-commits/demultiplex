process bcl2fastq {
    disk "${params.b2f_disk} GB"
    memory "${params.b2f_mem} GB"
    tag "${bcl_input.getSimpleName()}"
    publishDir "$params.outdir" , mode: 'copy'

    input:
    path(bcl_input)
    path(rundir_ch)

    output:
    path("InterOp/*"), emit: interop
    path("Stats/*"), emit: stats
    path("Reports.tar.gz"), emit: reports
    path("Reads/*"), type: "file", emit: reads
    path("Reads/*"), type: "dir", emit: ch_multiqc_projects

    script:
    no_lane_split = params.b2f_no_lane_splitting ? "--no-lane-splitting " : ""
    miss_bcl = params.b2f_try_miss_bcl ? "--ignore-missing-bcls --ignore-missing-filter --ignore-missing-positions " : ""
    mask = params.use_mask ? "--use-bases-mask ${params.b2f_mask}" : ""
    """
    bcl2fastq \\
        --runfolder-dir ${rundir_ch} \\
        --output-dir $params.b2f_output_dir \\
        --sample-sheet $bcl_input \\
        --minimum-trimmed-read-length $params.b2f_min_trimmed_read_length \\
        --mask-short-adapter-reads $params.b2f_mark_short_adapter_reads \\
        --reports-dir $params.b2f_report_dir \\
        --interop-dir $params.b2f_interop_dir \\
        --stats-dir $params.b2f_stats_dir \\
        --loading-threads $params.b2f_threads \\
        --processing-threads $params.b2f_threads \\
        --writing-threads $params.b2f_threads \\
        $no_lane_split \\
        $miss_bcl \\
        $mask

    tar -zcf Reports.tar.gz Reports
    files=`find Reads -type f`
    md5sum \$files > Reads/${bcl_input.getSimpleName()}_fastq.md5
    """
    
}
