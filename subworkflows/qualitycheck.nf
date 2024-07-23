include {   PROJECTMULTIQC      } from '../modules/multiqc/main.nf'

workflow BCLCONVERT {
    take:
    BCL_INPUT
    PROJECTS

    main:
    PROJECTMULTIQC ( BCL_INPUT, PROJECTS )

}

