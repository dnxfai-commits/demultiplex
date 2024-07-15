include {   MAKETSV      } from '../modules/maketsv/main.nf'

workflow PREPROCESSING {
    take:
    input_ch

    main:
    MAKETSV ( input_ch )
    

}
