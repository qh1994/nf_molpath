

currwordir=$(dirname $0)

#cd $currwordir/phytoy-nf-master
#nextflow run phytoy.nf --tmpout $currwordir/temp_out.txt

nextflow run $currwordir/phytoy-nf-master/phytoy.nf -with-docker --pwd $1 --in $currwordir/phytoy-nf-master/test.fasta --out $currwordir/phytoy-nf-master/results/
