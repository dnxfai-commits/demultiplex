include { PREPAREDATA } from '../subworkflows/preparedata'
include { FASTQGENERATE } from '../subworkflows/fastqgenerate'
include { QUALITYCHECK } from '../subworkflows/qualitycheck'

workflow DEMULTIPLEX {

    take:
    input_ch
    rundir_ch

    main:
    PREPAREDATA     ( input_ch )
    /*
    FASTQGENERATE   ( PREPAREDATA.out.BCL_INPUT, rundir_ch )
    QUALITYCHECK    ( FASTQGENERATE.out.PROJECTS )
    */

}
