#!/bin/bash
#SBATCH --qos=normal            # Quality of Service
#SBATCH --job-name=Velo_PF      # Job Name
#SBATCH --nodes=8               # Number of Nodes
#SBATCH --ntasks-per-node=2     # Number of tasks (MPI processes)
#SBATCH --cpus-per-task=4       # Number of threads per task (OMP threads)

export CONDA_ENVS_PATH=/lustre/project/wdeng7/jyang10/condaenvs/conda-envs
unset PYTHONPATH
source activate my_root

velocyto run -b /lustre/project/wdeng7/deep/CellRangerData/PF/outs/filtered_feature_bc_matrix/barcodes.tsv.gz -o /lustre/project/wdeng7/deep/CellRangerData/PF/outs/velocyto/ -m /lustre/project/wdeng7/deep/dm6/dm6_rmsk.gtf /lustre/project/wdeng7/deep/CellRangerData/PF/outs/possorted_genome_bam.bam /lustre/project/wdeng7/deep/dm6/genes/Drosophila_melanogaster.BDGP6.28.100.chr_filtered.GAL4.EGFP.gtf
