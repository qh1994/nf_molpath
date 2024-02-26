#!/bin/bash -ue
awk -F ',' '{print $1 * $2}' /home/quirin/Desktop/nextflow_test/out_2.txt >/home/quirin/Desktop/nextflow_test/output_2.txt
echo /home/quirin/Desktop/nextflow_test/output_2.txt
