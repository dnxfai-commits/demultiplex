include {   MAKETSV      } from '../modules/makets/main.nf'

workflow PREPROCESSING {
    take:
    input_ch

    main:
    MAKETSV ( input_ch )
    

}
