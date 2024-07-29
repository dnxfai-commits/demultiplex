include {   PROJECTMULTIQC      } from '../modules/multiqc/main.nf'

workflow QUALITYCHECK {
    take:
    PROJECTS

    main:
    PROJECTS
        .filter( !~/^Log.*/ )
    //PROJECTMULTIQC ( PROJECTS )

}

