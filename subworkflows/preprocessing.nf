include {   FASTQC      } from '../modules/fastqc/main.nf'

workflow PREPROCESSING {
    take:
    input_csv
    adapter_fasta_ch

    main:
    FASTQC      ( input_csv )
    TRIMMING    ( input_csv, adapter_fasta_ch.collect() )

    FASTQC_MQC      = FASTQC.out.fastqc_zip.groupTuple(by: [1,3])
    TRIMMING_MQC    = TRIMMING.out.trimm_fastq_zip.groupTuple(by: [1,3])
    
    emit:
    TRIMMING_OUT
    PREPROCESSING_MULTIQC

}
