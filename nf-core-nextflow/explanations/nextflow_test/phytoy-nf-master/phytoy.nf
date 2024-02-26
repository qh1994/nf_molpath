
nextflow.enable.dsl=2

params.pwd = """$PWD"""
params.in = params.pwd + "/data/*.tfa"
params.out = params.pwd + '/results'




process align {
  input:
      file(seq)
  output:
      file("*.phy")
  
  """
      clustalw -infile=$seq -output=phylip -outfile=${seq.baseName}.phy
      clustalw -infile=$seq -output=phylip -outfile=$params.pwd/${seq.baseName}.phy
      cat $params.pwd/${seq.baseName}.phy>${seq.baseName}.phy
  """
}



process get_raxml_tree{
  publishDir params.out, mode: 'copy'
  cpus 2 
  
  input:
      file(msa)
  output:
      file "RAxML_bestTree.test"
      val(1)
  
  """
      raxmlHPC -f d -j -p 9 -T ${task.cpus} -m PROTGAMMALG -s $msa -n ${msa.baseName}
  """
}

workflow{
    seq_files = Channel.fromPath(params.in)
    seq_files.view()

    outtemp = align(seq_files).collect()
    get_raxml_tree(outtemp)
    
}
