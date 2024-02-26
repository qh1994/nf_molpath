

params.curr_dir = """$PWD"""
params.input_2 = ""

process task1 {
    memory = '10 MB'
    time = '1 min'
    cpus = 1
    input:
    val(file1)
    val(outfile)
    
    output:
    stdout
    
    """
    awk -F ',' '{print \$1","\$1}' $file1 >$outfile
    echo $outfile
    """
}


process task2 {
    input:
    val(file1)
    val(outfile)
    
    output:
    stdout
    
    """
    awk -F ',' '{print \$1 * \$2}' $file1 >$outfile
    echo $outfile
    """
}


process task3 {

    output:
    stdout

    """
    echo $params.input_2
    """
}
