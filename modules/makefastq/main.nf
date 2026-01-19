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

    /*
     * DRAGEN usa ~1–1.5 GB RAM per thread
     * Limitiamo automaticamente i thread per non far killare la VM
     */
    cpu = Math.max(2, (task.cpus / 4) as int)

    /*
     * Flag lane splitting
     */
    lane_split = params.bcl_lane_splitting ? "" : "--no-lane-splitting true"

    /*
     * Caso 1: bcl_only_lane specificato → una conversione per lane + merge
     */
    if (!params.bcl_lane_splitting && params.bcl_only_lane) {

        lanes = params.bcl_only_lane.split(",")

        run_cmds = lanes.collect { lane ->

            """
            if [ ! -d Reads/L${lane} ]; then
                echo "Processing lane ${lane}"
                bcl-convert \\
                    --bcl-input-directory $rundir_ch \\
                    --output-directory Reads/L${lane} \\
                    --sample-sheet $bcl_input \\
                    --bcl-only-lane ${lane} \\
                    --bcl-num-parallel-tiles $cpu \\
                    --bcl-num-conversion-threads $cpu \\
                    --bcl-num-compression-threads $cpu \\
                    --strict-mode true \\
                    --bcl-sampleproject-subdirectories true \\
                    --output-legacy-stats true \\
                    $lane_split
            else
                echo "Lane ${lane} already processed — skipping"
            fi
            """

        }.join("\n")

        merge_cmd = """

        echo "Merging FASTQ across lanes"
        mkdir -p Reads/Reads_merged

        # Loop over samples detected in first lane
        for sample_dir in Reads/L${lanes[0]}/*; do
            sample_name=\$(basename \$sample_dir)
            mkdir -p Reads/Reads_merged/\$sample_name

            for read in R1 R2; do
                out_file=Reads/Reads_merged/\$sample_name/\${sample_name}_\${read}.fastq.gz
                > \$out_file

                for lane in ${lanes.join(" ")}; do
                    lane_file=Reads/L\$lane/\$sample_name/\${sample_name}_\${read}.fastq.gz
                    if [ -f \$lane_file ]; then
                        cat \$lane_file >> \$out_file
                    fi
                done
            done
        done
        """

    }
    /*
     * Caso 2: comportamento normale (tutte le lane insieme)
     */
    else {

        run_cmds = """
        bcl-convert \\
            --bcl-input-directory $rundir_ch \\
            --output-directory Reads \\
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
    set -euo pipefail
    mkdir -p Reads

    $run_cmds

    $merge_cmd
    """
}
