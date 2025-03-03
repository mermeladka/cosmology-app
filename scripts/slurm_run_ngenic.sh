#!/bin/bash
#SBATCH --job-name=run_ngenic
#SBATCH --output=logs/ngenic_run-%j.out
#SBATCH --error=logs/ngenic_run-%j.err
#SBATCH --time=00:30:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=4GB

# Load necessary modules
module purge
module load stack/2024-06
module load gcc/12.2.0
module load openmpi/4.1.6
module load gsl/2.7.1
module load hdf5/1.14.3

# Set paths
SCRATCH_DIR=/cluster/scratch/$USER/cosmology
BIN_DIR=$SCRATCH_DIR/bin
DATA_DIR=$SCRATCH_DIR/data

mkdir -p $DATA_DIR

# Run N-GenIC
srun $BIN_DIR/N-GenIC $DATA_DIR/lsf_32.param

