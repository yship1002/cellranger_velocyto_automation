#!/bin/bash
#SBATCH --qos=normal            # Quality of Service
#SBATCH --job-name=PF           # Job Name
#SBATCH --nodes=10              # Number of Nodes
#SBATCH --ntasks-per-node=2     # Number of tasks (MPI processes)
#SBATCH --cpus-per-task=8       # Number of threads per task (OMP threads)

cd /lustre/project/wdeng7/deep/CellRangerData/

cellranger count --transcriptome=/lustre/project/wdeng7/deep/CellRangerData/refgenome4cellranger/ --id=PM --fastqs=/lustre/project/wdeng7/scRNA_RAW/Wu-Min_Deng_12-13-2019_10X-pool/Deng_10XRNA-Seq/ --sample=PM_1,PM_2,PM_3,PM_4 --indices=TACTCTTC,CCTGTGCG,GGACACGT,ATGAGAAA
