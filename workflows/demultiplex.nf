include { PREPAREDATA } from '../subworkflows/preparedata'

workflow DEMULTIPLEX {

    take:
    input_ch

    main:
    PREPAREDATA ( input_ch )

}
