include {   PROJECTMULTIQC      } from '../modules/multiqc/main.nf'

workflow QUALITYCHECK {
    take:
    PROJECTS

    main:
    PROJECTS
        .filter( ~/^Logs.*/ )
    //PROJECTMULTIQC ( PROJECTS )

}

