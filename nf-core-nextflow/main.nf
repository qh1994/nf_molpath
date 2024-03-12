#!/usr/bin/env nextflow


params.curr_dir = """$PWD"""
params.input = "bla.csv"
params.outdir = "some_value"
params.fasta = "genome.fa"
params.monochromeLogs = "some_value"
params.workdir = """$PWD"""

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    nf-core/nextflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/nf-core/nextflow
    Website: https://nf-co.re/nextflow
    Slack  : https://nfcore.slack.com/channels/nextflow
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    GENOME PARAMETER VALUES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// TODO nf-core: Remove this line if you don't need a FASTA file
//   This is an example of how to use getGenomeAttribute() to fetch parameters
//   from igenomes.config using `--genome`

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    VALIDATE & PRINT PARAMETER SUMMARY
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

WorkflowMain.initialise(workflow, params, log, args)

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOW FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { NEXTFLOW } from './workflows/nextflow'

process runHLA{

input: path("fastq_file.fastq")
output: path("fastq_output_file.fastq")

"""
pwd1=\$PWD
inputfolder="/home/qheiss/old/old/WES_Pilot/230929_A01542_0078_BHWNTKDRX2"
echo "done" >$params.curr_dir/fastq_output_file.fastq
cp $params.curr_dir/fastq_output_file.fastq fastq_output_file.fastq
python3 /opt/nf_molpath/nf-core-nextflow/create_hla_sheet.py \$inputfolder
cd /home/qheiss/old/old
sudo nextflow run nf-core/hlatyping -r 2.0.0 -work-dir /home/qheiss/old/old/tmp --input /opt/nf_molpath/nf-core-nextflow/hla_samplesheet.csv --outdir /opt/nf_molpath/nf-core-nextflow/hla_res/ --genome GRCh37 -profile docker --igenomes_base /home/qheiss/old/old/igenomes --max_cpus 4
cd \$pwd1
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

output: tuple path("fastq_file.fastq"), path("bamfile.fastq"), path("i_vcf_file.vcf")

"""
cp $params.workdir/fastq_file.fastq fastq_file.fastq
echo bla >$params.workdir/bamfile.fastq
echo bla >$params.workdir/i_vcf_file.vcf
cp $params.workdir/bamfile.fastq bamfile.fastq
cp $params.workdir/i_vcf_file.vcf i_vcf_file.vcf
"""

}

process runFusionCatcher {

input: path(bamfile)

output: path("outputX.txt")

"""
echo "done" >$params.workdir/outputX.txt
cp $params.workdir/outputX.txt outputX.txt
"""

}

process runArriba{

input: path(bamfile)

output: path("outputY.txt")

"""
echo "done" >$params.workdir/outputY.txt
cp $params.workdir/outputY.txt outputY.txt
"""
}

process runTranslocations{


input:
path(file1)
path(file2)

output: val("Done with translocation")

"""
echo "done"
"""

}

process runMSI{

input: path(bamfile)

output: val("Done MSI!")

script:
"""
"""

}

process runMutect{

input: path(bamfile)

output: path("m_vcf_file.txt")

script:
"""
echo "done" >$params.workdir/m_vcf_file.txt
cp $params.workdir/m_vcf_file.txt m_vcf_file.txt
"""

}

process runNormalization{

input:
path(i_vcf_file)
path(file2)

output: path("vcf_file_1.txt")

script:
"""
echo done >$params.workdir/vcf_file_1.txt
cp $params.workdir/vcf_file_1.txt vcf_file_1.txt
"""
}

process mergevcf{

input: path(vcf_file_1)

output: path("vcf_merged.txt")
script:
"""
echo done >$params.workdir/vcf_merged.txt
cp $params.workdir/vcf_merged.txt vcf_merged.txt
"""
}

process run_vep{

input: path(vcf_merged)

output: path("vep_output.txt")

script:
"""
echo done >$params.workdir/vep_output.txt
cp $params.workdir/vep_output.txt vep_output.txt
"""
}


process runCNV{

input:
path(bamfile)
path(vep_output)

output: val("Done CNV running!")

script:
"""
"""
}

process run_TERT_detection{

input: path(vep_output)

output: val("Done TERT!")

script:
"""
sudo python3 /home/qheiss/extract_TERTprom.py $vep_output
"""
}

process run_TMB{

input: path(vep_output)

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

input: path(vep_output)

output: val("Done with running mutsig!")

script:
"""
"""

}

process filter_vcf{

input: path(vep_output)

output: path("filtered_vcf.txt")

script:
"""
echo done >$params.workdir/filtered_vcf.txt
cp $params.workdir/filtered_vcf.txt filtered_vcf.txt
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
    run_nbr.view()
    outputs_1 = trigger(run_nbr).collect()
    fastq_file=outputs_1.map{it->it[0]}
    bamfile=outputs_1.map{it->it[1]}
    i_vcf_file=outputs_1.map{it->it[2]}
    fastq_file.view()
    /*fastq_file_2=Channel.fromPath("/home/quirin/fastq_file.fastq").first()*/
    fastq_output_file = runHLA(fastq_file).collect()
    outputX = runFusionCatcher(bamfile).collect()
    outputY = runArriba(bamfile).collect()
    runTranslocations(outputX.first(),outputY.first())
    runMSI(bamfile)
    m_vcf_file = runMutect(bamfile).collect()
    vcf_file_1 = runNormalization(i_vcf_file,m_vcf_file).collect()
    vcf_merged = mergevcf(vcf_file_1).collect()
    vep_output = run_vep(vcf_merged).collect()
    runCNV(bamfile,vep_output)
    new_channel=Channel.fromPath("/mnt/panda23/seq_data/nextseq/231017_NDX550280_0316_AHG7J3BGXV/CurrentDragenHRDAnalysis/Results/V-2023-01902/V-2023-01902_DNA/V-2023-01902_DNA.hard-filtered.vcf")
    run_TERT_detection(new_channel)
    run_TMB(vep_output)
    run_pVACtools(vep_output)
    run_mutsig(vep_output)
    filtered_vcf = filter_vcf(vep_output).collect()
    triggerOutput(filtered_vcf).view()


}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN ALL WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOW: Execute a single named workflow for the pipeline
// See: https://github.com/nf-core/rnaseq/issues/619
//
workflow {
    NFCORE_NEXTFLOW ()
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
