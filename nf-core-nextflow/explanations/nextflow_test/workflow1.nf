

params.curr_dir = """$PWD"""
params.input1 = params.curr_dir + "/results_test.txt"
params.input2 = params.curr_dir + "/results_test_2.txt"
params.outfile = params.curr_dir + "/out.txt"
params.tmpout = params.curr_dir + "/tmp.txt"
params.startpos = 1
params.stoppos = 8


process write_line_to_file {
    input:
    tuple val(text1),val(text2)
    
    output:
    path("out.txt")
    """
    echo $text1,$text2 >>$params.outfile
    cat $params.outfile >out.txt
    """
}


process multiply {
    input:
    val(val1)
    val(val2)
    
    output:
    stdout
    
    when: 1 == 1

    """
    echo "$val1*$val2" | bc -l
    """
}


process newfunction {
    input:
    val(infile)

    output:
    stdout

    """
    cat $infile
    """
}

process rep_column {
    input:
    val(infile)
    val(column)
    
    output:
    path("out_new.txt")
    
    """
    awk -F ',' '{print \$1","\$$column","\$$column}' $infile >$params.tmpout 
    cat $params.tmpout >$params.outfile
    cat $params.outfile >out_new.txt
    """


}



def fib(int n) {
return n < 2 ? 1 : fib(n - 1) + fib(n - 2)
}

def multiply_2(int n, int o) {
return n*o
}



workflow {
    
    if( !file(params.input1).exists() ) {
       exit 1, "The specified input file does not exist: ${params.input1}"
    }

    
    /* for line in file: column1[i] = line.split()[0]; column2[i] = lineSplit[1]; */
    column1 = Channel.fromPath(params.input1).splitCsv().map{  row -> "${row[0]}" }
    column2 = Channel.fromPath(params.input1).splitCsv().map{  row -> "${row[1]}" }
    
    /* TWO IDENTICAL OUTPUTS: */
    column3 = Channel.fromPath(params.input2).splitCsv().map{  row -> "${row[0]}" }
    /* column3 = ['A','B','...'] ; */
    column3 = Channel.of('A','B','C','D','E','F','G','H')
    
    /* FOO: First column + letters, BAZ: Second column + letters
    foo = [column3[i],column1[i] for i in range(0,len(column3))] ;
    */

    foo = column3.merge(column1.map{it->it.toInteger()})
    baz = column3.merge(column2.map{it->it.toInteger()})
    
    /* res = [{foo[0]:(foo[1],baz[1])} for i in range(0,len(foo));
    mix = concat, groupTuple = match elements with same key letter into tuple */
    channel1 = foo.mix(baz)
    res = channel1.groupTuple().map{it->[it.first(),it.last().sum()]}
    
    
    /* params.outfile.write["x[0],x[1]" for x in res]; */
    res.map{a,b->a+','+b.toString()+'\n'}.collectFile(name:params.outfile,sort:true)

    rep_column(params.outfile,2)
    files_to_collect = Channel.fromPath('/home/quirin/Desktop/nextflow_test/a{1,2,3}.txt')
    newfunction(files_to_collect).collectFile(name:params.tmpout)
    println("Collected results into:" + params.tmpout)


    /* small = []; large = [] ;column1.splitIntoTwoArrays(dest = small if x < 11 else large); */
    column1
    .branch {
        small: it < 11
        large: it > 10
    }
    .set { result }
    

    /*Sum of all elements < 11:*/
    /*result.small.map{it->it.toInteger()}.sum().view()*/
    /*Sum of all elements > 11:*/
    /*result.large.map{it->it.toInteger()}.sum().view()*/
    result.small.map{it -> multiply_2(it.toInteger(),22)}.view()
    
    /*Double all small elements ;
    x = sum(result.small)*2; */
    x = result.small.map{it -> it.toInteger()*2}.sum()
    y = result.large.map{it -> it.toInteger()}.sum()
    z = multiply(x,y)


    list1 = [1,2,3,4]
    list2 = ['a','b','c','d']
    map = [a: 0, b: 1, c: 2, d: 3]
    
    for (String elem : list2) {
        println "Next Fibonacci Number:"
        println fib(map[elem]+1)
    }
    
}
