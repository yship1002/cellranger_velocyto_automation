#!/bin/bash
##################################################################

#BEFORE YOU START:
#This script combines cellranger and velocyto so that user only need to submit the script and wait for result. If your job exceeds the time limit simply resubmit your job by following the instructions at the end of user input region. Cellranger will pick up where it was but it will leave _lock file. This program will handle this case by checking if _lock file exists, then _lock file will be deleted

################################################################


#SBATCH --qos=normal            # Quality of Service
#SBATCH --job-name=cellrangerVelocyto          # Job Name
#SBATCH --nodes=5              # Number of Nodes
#SBATCH --ntasks-per-node=5     # Number of tasks (MPI processes)
#SBATCH --cpus-per-task=8    # Number of threads per task (OMP threads)
#SBATCH --mem=100000            # Request memory per node
#SBATCH --mail-type=ALL
#SBATCH --output=onscreenoutput.out


#These parameters have been populated by run_me.sh
email=${1}
data=${2}
transcriptome=${3}
ID=${4}
sample_name=${5}
maskfile1=${6}
maskfile2=${7}
outputloom=${8}



#Notify user your job has started
mail -s 'Your script has started!' ${1}






#############################################################
#START OF DATA PROCESSING REGION DO NOT EDIT BEYOND THIS LINE!
#############################################################






module load cellranger/6.0.0
module load samtools/1.10
#Activate conda environment Instructions are on the website below
#https://wiki.hpc.tulane.edu/trac/wiki/cypress/AnacondaInstallPackage
export CONDA_ENVS_PATH=/lustre/project/wdeng7/jyang10/anaconda3:$CONDA_ENV
export PATH=/lustre/project/wdeng7/jyang10/anaconda3/bin:$PATH
export LD_LIBRARY_PATH=/lustre/project/wdeng7/jyang10/samtools/htslib-1.12$LD_LIBRARY_PATH
#unset PYTHONPATH
#source activate my_root



cd ${data}
if [[ -e ${data}/${ID}/_lock ]]; then
    echo "Cellranger has been interrupted deleting _lock file now!"
    rm ${data}/${ID}/_lock
    echo "_lock file has been deleted"
fi

echo "Cellranger pre-run check completed! You are free to go!"
cellranger count --transcriptome=${transcriptome}  --id=${ID}  --fastqs=${data} --sample=${sample_name}

echo " "
echo "This is the end of Cellranger!"
echo " "


#Extract the absolute path of barcode file we will use in velocyto
barcode=${data}/${ID}/outs/filtered_feature_bc_matrix/barcodes.tsv.gz


#Extract the absolute path of bam file we will use in velocyto
bamfile=${data}/${ID}/outs/possorted_genome_bam.bam


echo " "
echo "Start of samtools"
echo " "
#Use samtool to precompute cellsorted version of bam file
samtools sort -l 7 -m 2000M -t CB -O BAM -@ 16 -o ${data}/${ID}/outs/cellsorted_possorted_genome_bam.bam ${bamfile}
echo " "
echo "End of samtools"
echo " "



#Start processing using velocyto
velocyto run -b ${barcode} -o ${outputloom} -m ${maskfile1} ${bamfile} ${maskfile2}






#############################################################
#END OF DATA PROCESSING REGION
#############################################################





#Notify user when job is done
mail -s 'Your script has finished!' ${1}

