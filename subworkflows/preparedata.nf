include {   MAKETSV      } from '../modules/maketsv/main.nf'

workflow PREPAREDATA {
    take:
    input_ch

    main:
    MAKETSV ( input_ch )
    

}
