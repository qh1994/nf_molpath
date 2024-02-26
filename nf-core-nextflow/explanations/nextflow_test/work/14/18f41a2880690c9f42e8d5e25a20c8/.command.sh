#!/bin/bash -ue
awk -F ',' '{print $1","$1}' /home/quirin/Desktop/nextflow_test/results_test.txt >/home/quirin/Desktop/nextflow_test/out_2.txt
echo /home/quirin/Desktop/nextflow_test/out_2.txt
