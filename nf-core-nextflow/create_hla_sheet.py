import sys
import os

runName="/media/data/old/WES_Pilot/230929_A01542_0078_BHWNTKDRX2"

dirName=runName + "/results/preprocessing/mapped/"

list_of_dirs = os.listdir(runName)

if not(os.path.isdir(runName + "/result/")):
    os.system("mkdir -p " + runName + "/result/")
if not(os.path.isdir(runName + "/result/HLA/")):
    os.system("mkdir -p " + runName + "/result/HLA/")
if not(os.path.isdir(runName + "/result/HLA/config/")):
    os.system("mkdir -p " + runName + "/result/HLA/config/")
if not(os.path.isdir(runName + "/results/HLA/hla_results/")):
    os.system("mkdir -p " + runName + "/results/HLA/hla_results/")

file1 = open(dirName + 'result/HLA/config/hla_samplesheet.csv', 'w')
file1.write("sample,fastq_1,fastq_2,bam,seq_type")

for curr_dir in list_of_dirs:
    list_of_files_curr = os.listdir(os.path.join(run_name,curr_dir))
    found = False
    filename = ""
    samplename = ""
    for file_curr in list_of_files_curr:
        if(found == True):
            break
        if(".bam" in file_curr and not(".bai" in file_curr)):
            found = True
            filename = os.path.join(run_name,curr_dir,file_curr)
            samplename = file_curr.split(".")[0]
    if not(filename == "" or samplename == ""):
        file1.write("" + samplename + ",,," + filename + ",dna")

file1.close()

print(runName + '/result/HLA/config/hla_samplesheet.csv')
print("\t")
print(runName + "/results/HLA/hla_results/")


