include { PREPAREDATA } from '../subworkflows/preparedata'
include { BCLCONVERT } from '../subworkflows/bclconvert'
include { QUALITYCHECK } from '../subworkflows/qualitycheck'

workflow DEMULTIPLEX {

    take:
    input_ch
    rundir_ch

    main:
    PREPAREDATA     ( input_ch )
    BCLCONVERT      ( PREPAREDATA.out.BCL_INPUT, rundir_ch )
    QUALITYCHECK    ( PREPAREDATA.out.BCL_INPUT, BCLCONVERT.out.PROJECTS )

}
