

params.pwd = """$PWD"""
params.curr_dir = """$PWD"""
params.input2 = params.curr_dir + "/results_test_2.txt"
params.outfile = params.curr_dir + "/out_2.txt"
params.in = params.pwd + "/phytoy-nf-master/data/*.tfa"

include { task1 } from './modules.nf'
include { task2 } from './modules.nf'
include { task3 } from './modules.nf' addParams(input_2: 'Hi!')

process start_other_script {
    output:
    stdout

    """
    bash $params.curr_dir/run_nextflow.sh $params.curr_dir
    """

}


workflow my_workflow {
    take:
    inputfile1

    main:
    task1(ALPHA,params.outfile)
    task2(params.outfile,BETA)
    
    emit:
    task2.out
}


workflow {
    tempres = start_other_script()
    task3().view()
    my_workflow(Channel.of(params.input2))
    println "Result file written to:\t "
    result = my_workflow.out.collect()
    result.view()

}


workflow.onComplete { print("Workflow was executed correctly!") }
