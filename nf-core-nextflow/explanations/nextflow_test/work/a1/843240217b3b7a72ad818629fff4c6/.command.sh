#!/bin/bash -ue
python
awk -F ',' '{print $1","$2","$2}' /home/quirin/Desktop/nextflow_test/out.txt >/home/quirin/Desktop/nextflow_test/tmp.txt 
cat /home/quirin/Desktop/nextflow_test/tmp.txt >/home/quirin/Desktop/nextflow_test/out.txt
cat /home/quirin/Desktop/nextflow_test/out.txt >out_new.txt
