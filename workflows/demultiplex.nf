include { PREPAREDATA } from '../subworkflows/preparedata'
include { BCLCONVERT } from '../subworkflows/bclconvert'

workflow DEMULTIPLEX {

    take:
    input_ch
    rundir_ch

    main:
    PREPAREDATA     ( input_ch )
    BCLCONVERT      ( PREPAREDATA.out.BCL_INPUT, rundir_ch )

}
