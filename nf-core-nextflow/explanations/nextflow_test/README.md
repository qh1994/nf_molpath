workflow1.nf: Some easy nextflow commands and parameters with "translation" to python.
nextflow run workflow1.nf

nextflow_2.nf: Easy modular workflow with config and modules file. Goal: calculate square of every entry in file.
nextflow run nextflow_2.nf -c my_config.config

phytoy-nf-master:
phytoy.nf: Workflow with docker image.
nextflow run phytoy.nf -with-docker --in test.fasta --out results/
