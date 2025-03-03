#!/bin/bash
#SBATCH --job-name=install_cosmology
#SBATCH --output=/cluster/scratch/ebobrova/cosmology-app/logs/install-%j.out
#SBATCH --error=/cluster/scratch/ebobrova/cosmology-app/logs/install-%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=4GB

# Load necessary modules
module purge
module load stack/2024-06
module load gcc/12.2.0
module load cmake/3.27.7
module load openmpi/4.1.6
module load gsl/2.7.1
module load hdf5/1.14.3

# Set paths
SCRATCH_DIR=/cluster/scratch/$USER/cosmology
SRC_DIR=$SCRATCH_DIR/src
BIN_DIR=$SCRATCH_DIR/bin

mkdir -p $BIN_DIR

# --- Install IPPL ---
cd $SRC_DIR/ippl
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$BIN_DIR/ippl
make -j$(nproc)
make install

# --- Install N-GenIC ---
cd $SRC_DIR/ngenic
make -j$(nproc)
cp N-GenIC $BIN_DIR/

echo "Installation complete!"

