include { PREPROCESSING } from '../subworkflows/preprocessing'

workflow DIGITALRNASEQ {

    take:
    input_csv
    adapter_fasta_ch

    main:
    PREPROCESSING ( input_csv, adapter_fasta_ch )

}
