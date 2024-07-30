include {   BCLCONVERT      } from '../modules/makefastq/main.nf'
include {   RUNMULTIQC      } from '../modules/multiqc/main.nf'

workflow FASTQGENERATE {
    take:
    BCL_INPUT
    rundir_ch

    main:
    BCLCONVERT ( BCL_INPUT, rundir_ch )

    REPORTS = BCLCONVERT.out.ch_multiqc_projects
        .flatten()
        .filter { file ->
            def path = file.toString()
            path.contains('=~/Reports')
        }
        .view()
    
    //RUNMULTIQC ( BCL_INPUT, BCLCONVERT.out.reports )

    PROJECTS = BCLCONVERT.out.ch_multiqc_projects
        .flatten()
        .filter { file ->
            def path = file.toString()
            !path.contains('/Reports') && !path.contains('/Logs')
        }
        .view()

    emit:
    PROJECTS
}

