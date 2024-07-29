include {   BCLCONVERT      } from '../modules/makefastq/main.nf'
include {   RUNMULTIQC      } from '../modules/multiqc/main.nf'

workflow FASTQGENERATE {
    take:
    BCL_INPUT
    rundir_ch

    main:
    BCLCONVERT ( BCL_INPUT, rundir_ch )
    //RUNMULTIQC ( BCL_INPUT, BCLCONVERT.out.reads )

    BCLCONVERT.out.reads.view()

    PROJECTS = BCLCONVERT.out.ch_multiqc_projects.flatten()

    emit:
    PROJECTS
}

