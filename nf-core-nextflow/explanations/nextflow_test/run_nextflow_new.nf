
nextflow.enable.dsl=2

params.pwd = """$PWD"""
params.in = params.pwd + 'phytoy-nf-master/data/*.tfa'
params.out = params.pwd +'/results'

process start_other_script {
    output:
    stdout

    """
    bash $params.pwd/run_new.sh $params.pwd
    """

}


workflow {

    start_other_script()

}
