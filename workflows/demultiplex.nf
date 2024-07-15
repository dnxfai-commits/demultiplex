include { PREPAREDATA } from '../subworkflows/preparedata'
include { BCLCONVERT } from '../subworkflows/bclconvert'

workflow DEMULTIPLEX {

    take:
    input_ch

    main:
    PREPAREDATA     ( input_ch )
    BCLCONVERT      ( BCL_INPUT )

}
