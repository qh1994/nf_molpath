#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    nf-core/nextflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/nf-core/nextflow
    Website: https://nf-co.re/nextflow
    Slack  : https://nfcore.slack.com/channels/nextflow
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    GENOME PARAMETER VALUES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// TODO nf-core: Remove this line if you don't need a FASTA file
//   This is an example of how to use getGenomeAttribute() to fetch parameters
//   from igenomes.config using `--genome`

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    VALIDATE & PRINT PARAMETER SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { validateParameters; paramsHelp } from 'plugin/nf-validation'

// Print help message if needed
if (params.help) {
    def logo = NfcoreTemplate.logo(workflow, params.monochrome_logs)
    def citation = '\n' + WorkflowMain.citation(workflow) + '\n'
    def String command = "nextflow run ${workflow.manifest.name} --input samplesheet.csv --genome GRCh37 -profile docker"
    log.info logo + paramsHelp(command) + citation + NfcoreTemplate.dashedLine(params.monochrome_logs)
    System.exit(0)
}

// Validate input parameters
if (params.validate_params) {
    validateParameters()
}

WorkflowMain.initialise(workflow, params, log, args)

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOW FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { NEXTFLOW } from './workflows/nextflow'


process runHLA{

input: path("/home/quirin/git/nf_molpath/quirin/nf-core-nextflow/fastq_file.fastq")
output: path("fastq_output_file.fastq")

"""
echo "done" >/home/quirin/git/nf_molpath/quirin/nf-core-nextflow/fastq_output_file.fastq
cp /home/quirin/git/nf_molpath/quirin/nf-core-nextflow/fastq_output_file.fastq fastq_output_file.fastq
"""

}

process run_HLA_future {

input: val(fastq_file)

output: stdout

"""
### note: code does not work

tmp1="/config/hla_samplesheet.csv"


hlares="/hla-res"

nextflow run nf-core/hlatyping -r 2.0.0 -work-dir /home/qheiss/old/old/tmp --input $base_workdir$tmp1 --outdir $base_workdir$hlares --genome GRCh37 -profile docker --igenomes_base /home/qheiss/old/old/igenomes --max_cpus 10 >/dev/null

tmp2="/hla-res"

echo "$base_workdir$tmp"

"""

}

process run_1 {

input: val(base_workdir)

output: stdout

"""
tmp1="/config/hla_samplesheet.csv"


hlares="/hla-res"

nextflow run nf-core/hlatyping -r 2.0.0 -work-dir /home/qheiss/old/old/tmp --input $base_workdir$tmp1 --outdir $base_workdir$hlares --genome GRCh37 -profile docker --igenomes_base /home/qheiss/old/old/igenomes --max_cpus 10 >/dev/null

tmp2="/hla-res"

echo "$base_workdir$tmp"

"""

}

process trigger {

input: val(run_nbr)

output: tuple val("fastq_file"), val("bamfile"), val("i_vcf_file")

"""
"""

}

process runFusionCatcher {

input: val(bamfile)

output: val("outputX")

"""
echo "done"
"""

}

process runArriba{


input: val(bamfile)

output: val("outputY")

"""
echo "done"
"""
}

process runTranslocations{


input:
val(file1)
val(file2)

output: val("Done with translocation")

"""
echo "done"
"""

}

process runMSI{

input: val(bamfile)

output: val("Done MSI!")

script:
"""
"""

}

process runMutect{

input: val(bamfile)

output: val("m_vcf_file")

script:
"""
echo "done"
"""

}

process runNormalization{

input:
val(file1)
val(file2)

output: val("vcf_file_1")

script:
"""
"""
}

process mergevcf{

input: val(vcf_file_1)

output: val("vcf_merged")
script:
"""
"""
}

process run_vep{

input: val(vcf_merged)

output: val("vep_output")

script:
"""
"""
}


process runCNV{

input:
val(bamfile)
val(vep_output)

output: val("Done CNV running!")

script:
"""
"""
}

process run_TERT_detection{

input: val(vep_output)

output: val("Done TERT!")

script:
"""
"""
}

process run_TMB{

input: val(vep_output)

output: val("done TMB")

script:
"""
"""
}

process run_pVACtools{

input: val(vep_output)

output: val("Done pVACtools!")

script:
"""
"""
}

process run_mutsig{

input: val(vep_output)

output: val("Done with running mutsig!")

script:
"""
"""

}

process filter_vcf{

input: val(vep_output)

output: val("filtered_vcf")

script:
"""
"""
}

process triggerOutput{

input: val(run_nbr)

output: val("Done with all steps of analysis!")

script:

"""

# send mail to: abc@def.com subject: run was processed correctly. Results at directory: \$run_nbr

"""

}

//
// WORKFLOW: Run main nf-core/nextflow analysis pipeline
//
workflow NFCORE_NEXTFLOW {
    /*NEXTFLOW ()*/
    run_nbr = Channel.of("1")
    outputs_1 = trigger(run_nbr).collect()
    fastq_file=outputs_1.map{it->it[0]}
    bamfile=outputs_1.map{it->it[1]}
    i_vcf_file=outputs_1.map{it->it[2]}
    fastq_file_2=Channel.fromPath("/home/quirin/fastq_file.fastq").first()
    fastq_output_file = runHLA(fastq_file_2).collect()
    outputX = runFusionCatcher(bamfile).collect()
    outputY = runArriba(bamfile).collect()
    runTranslocations(outputX.first(),outputY.first())
    runMSI(bamfile)
    m_vcf_file = runMutect(bamfile).collect()
    vcf_file_1 = runNormalization(i_vcf_file,m_vcf_file).collect()
    vcf_merged = mergevcf(vcf_file_1).collect()
    vep_output = run_vep(vcf_merged).collect()
    runCNV(bamfile,vep_output)
    run_TERT_detection(vep_output)
    run_TMB(vep_output)
    run_pVACtools(vep_output)
    run_mutsig(vep_output)
    filtered_vcf = filter_vcf(vep_output).collect()
    triggerOutput(filtered_vcf).view()


}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN ALL WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOW: Execute a single named workflow for the pipeline
// See: https://github.com/nf-core/rnaseq/issues/619
//
workflow {
    NFCORE_NEXTFLOW ()
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
