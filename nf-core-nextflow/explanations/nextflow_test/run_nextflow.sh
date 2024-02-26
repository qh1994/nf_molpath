

currwordir=$(dirname $0)

nextflow run $currwordir/workflow1.nf --tmpout $currwordir/temp_out.txt --curr_dir $currwordir
