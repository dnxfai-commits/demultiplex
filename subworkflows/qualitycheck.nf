include {   PROJECTMULTIQC      } from '../modules/multiqc/main.nf'

workflow QUALITYCHECK {
    take:
    PROJECTS

    main:
    PROJECTS.view()
    //PROJECTMULTIQC ( PROJECTS )

}

