include {   PROJECTMULTIQC      } from '../modules/multiqc/main.nf'

workflow QUALITYCHECK {
    take:
    PROJECTS

    main:
    PROJECTS
        .filter { file ->
            def path = file.toString()
            !path.contains('/Reports') && !path.contains('/Logs')
        }
        .view()

    //PROJECTMULTIQC ( PROJECTS )

}

