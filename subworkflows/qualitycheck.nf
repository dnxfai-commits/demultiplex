include {   PROJECTMULTIQC      } from '../modules/multiqc/main.nf'

workflow QUALITYCHECK {
    take:
    BCL_INPUT
    PROJECTS

    main:
    PROJECTMULTIQC ( BCL_INPUT, PROJECTS )

}

