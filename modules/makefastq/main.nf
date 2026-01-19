process BCLCONVERT {
    disk "${params.bcl_disk} GB"
    memory "${params.bcl_mem} GB"
    tag "${bcl_input.getSimpleName()}"
    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/negedia/bclconvert:v4.4.4'
    publishDir "$params.outdir", mode: 'copy'

    input:
    path(bcl_input)
    path(rundir_ch)

    output:
    path("Reads/*"), type: "dir", emit: ch_multiqc_projects

    script:
    cpu = Math.max(2, (task.cpus / 4) as int)

    // Lane splitting flag
    lane_split = params.bcl_lane_splitting ? "" : "--no-lane-splitting true"

    if (!params.bcl_lane_splitting && params.bcl_only_lane) {

        lanes = params.bcl_only_lane.split(",")
        run_cmds = lanes.collect { lane ->
            """
            echo "Processing lane $lane"
            bcl-convert \\
                --bcl-input-directory $rundir_ch \\
                --output-directory $params.bcl_output_dir/L$lane \\
                --sample-sheet $bcl_input \\
                --bcl-only-lane $lane \\
                --bcl-num-parallel-tiles $cpu \\
                --bcl-num-conversion-threads $cpu \\
                --bcl-num-compression-threads $cpu \\
                --strict-mode true \\
                --bcl-sampleproject-subdirectories true \\
                --output-legacy-stats true \\
                $lane_split
            """
        }.join("\n")

        merge_cmd = """
        echo "Merging FASTQ per sample and read type across lanes"
        mkdir -p $params.bcl_output_dir/Reads_merged

        # Loop over samples in first lane
        for sample_dir in $params.bcl_output_dir/L${lanes[0]}/*; do
            sample_name=\$(basename \$sample_dir)
            mkdir -p $params.bcl_output_dir/Reads_merged/\$sample_name

            # Merge R1, R2 only
            for read in R1 R2; do
                out_file=$params.bcl_output_dir/Reads_merged/\$sample_name/\${sample_name}_\${read}.fastq.gz
                > \$out_file  # empty file
                for lane in ${lanes.join(" ")}; do
                    lane_file=$params.bcl_output_dir/L\$lane/\$sample_name/\${sample_name}_\${read}.fastq.gz
                    if [ -f \$lane_file ]; then
                        cat \$lane_file >> \$out_file
                    fi
                done
            done
        done
        """

    } else {
        // No lane filter, default behavior
        run_cmds = """
        bcl-convert \\
            --bcl-input-directory $rundir_ch \\
            --output-directory $params.bcl_output_dir \\
            --sample-sheet $bcl_input \\
            --bcl-num-parallel-tiles $cpu \\
            --bcl-num-conversion-threads $cpu \\
            --bcl-num-compression-threads $cpu \\
            --strict-mode true \\
            --bcl-sampleproject-subdirectories true \\
            $lane_split \\
            --output-legacy-stats true
        """
        merge_cmd = ""
    }

    """
    mkdir -p $params.bcl_output_dir
    $run_cmds
    $merge_cmd
    """
}
