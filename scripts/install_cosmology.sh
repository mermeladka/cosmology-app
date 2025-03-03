#!/bin/bash
#SBATCH --job-name=install_cosmology
#SBATCH --output=/cluster/scratch/ebobrova/cosmology-app/logs/install-%j.out
#SBATCH --error=/cluster/scratch/ebobrova/cosmology-app/logs/install-%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4GB

# Load necessary modules
module purge
module load stack/2024-06
module load gcc/12.2.0
module load cmake/3.27.7
module load openmpi/4.1.6
module load kokkos/3.6.01
module load gsl/2.7.1
module load hdf5/1.14.3

# Define paths
SCRATCH_DIR=$SCRATCH/cosmology-app
BUILD_DIR=$SCRATCH_DIR/build
SRC_DIR=$SCRATCH_DIR/src
BIN_DIR=$SCRATCH_DIR/bin
LOG_DIR=$SCRATCH_DIR/logs
IC_DIR=$SCRATCH_DIR/data/ICs
GADGET_DIR=$SCRATCH_DIR/src/ngenic/gadget2

mkdir -p $BUILD_DIR $SRC_DIR $BIN_DIR $LOG_DIR $IC_DIR

# Ensure submodules are initialized (useful if running after cloning)
# cd $SCRATCH_DIR
# git submodule update --init --recursive

# --- Step 1: Install FFTW 2.1.5 (Required for N-GenIC) ---
FFTW_DIR=$BUILD_DIR/fftw2_install
cd $SRC_DIR/fftw
tar -xvzf fftw-2.1.5.tar.gz
cd fftw-2.1.5

./configure --prefix=$FFTW_DIR --enable-shared --enable-mpi
make -j$(nproc)
make install

export LD_LIBRARY_PATH=$FFTW_DIR/lib:$LD_LIBRARY_PATH
export FFTW_INCL="-I $FFTW_DIR/include"
export FFTW_LIBS="-L $FFTW_DIR/lib"

echo "FFTW 2.1.5 installation completed."

# --- Step 2: Install HeFFTe (Required for IPPL) ---
HEFFTE_DIR=$BUILD_DIR/heffte_install
cd $SRC_DIR/heffte
mkdir -p build
cd build

cmake .. -DCMAKE_INSTALL_PREFIX=$HEFFTE_DIR -DBUILD_SHARED_LIBS=ON
make -j$(nproc)
make install

export PATH=$HEFFTE_DIR/bin:$PATH
export LD_LIBRARY_PATH=$HEFFTE_DIR/lib:$LD_LIBRARY_PATH

echo "HeFFTe installation completed."

# --- Step 3: Install IPPL with Cosmology Enabled ---
IPPL_INSTALL_DIR=$BUILD_DIR/ippl_install
cd $SRC_DIR/ippl
mkdir -p build
cd build

cmake .. -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_CXX_STANDARD=20 \
         -DENABLE_TESTS=ON \
         -DIPPL_PLATFORMS=openmp \
         -DENABLE_FFT=ON \
         -DENABLE_SOLVERS=ON \
         -DENABLE_ALPINE=ON \
         -DHeffte_ENABLE_FFTW=ON \
         -DHeffte_DIR=$HEFFTE_DIR \
         -DENABLE_COSMOLOGY=ON \
         -DCMAKE_INSTALL_PREFIX=$IPPL_INSTALL_DIR

make -j$(nproc)
make install

export PATH=$BIN_DIR:$PATH
export LD_LIBRARY_PATH=$IPPL_INSTALL_DIR/lib:$LD_LIBRARY_PATH

echo "IPPL installation with Cosmology completed successfully."

# --- Step 4: Install N-GenIC ---
NGENIC_INSTALL_DIR=$BUILD_DIR/ngenic_install
cd $SRC_DIR/ngenic/ngenic  # Fixing path to correct location

# Modify Makefile for FFTW paths
sed -i "s|FFTW_INCL=.*|FFTW_INCL=${FFTW_INCL}|" Makefile
sed -i "s|FFTW_LIBS=.*|FFTW_LIBS=${FFTW_LIBS}|" Makefile

# Compile N-GenIC
make -j$(nproc)

# Move binary to bin directory
cp N-GenIC $BIN_DIR/

export PATH=$BIN_DIR:$PATH

echo "N-GenIC installation completed successfully."

# --- Step 5: Compile Gadget2 (Optional but Needed for Some Simulations) ---
cd $GADGET_DIR

# Modify Makefile for FFTW paths
sed -i "s|FFTW_INCL=.*|FFTW_INCL=${FFTW_INCL}|" Makefile
sed -i "s|FFTW_LIBS=.*|FFTW_LIBS=${FFTW_LIBS}|" Makefile

make -j$(nproc)

# Move Gadget2 binary
cp Gadget2 $BIN_DIR/

echo "Gadget2 compiled successfully!"


