include {   BCL2FASTQ      } from '../modules/bcl2fastq/main.nf'

workflow PREPAREDATA {
    take:
    BCL_INPUT
    rundir_ch

    main:
    BCL2FASTQ ( BCL_INPUT, rundir_ch )

}
