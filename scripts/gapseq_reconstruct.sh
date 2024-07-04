#!/bin/bash

# Metabolic model reconstruction script for the cross-feeding-prediction protocol. More information here:
# https://github.com/mpredl/cross-feeding-prediction-protocol
# Reconstructs metabolic models based on input genomes using gapseq.

# Variables
TARGETDIR="/path/to/ouput_dir"  # Where to place the output files
ENVDIR="/path/to/conda_env"  # The path to the conda environment
DATADIR="/path/to/input_genomes"  # The path to the input genome files (directory with .fasta files)

conda activate $ENVDIR

if [ ! -d $TARGETDIR ]; then
	echo "Creating directory $TARGETDIR"
	mkdir $TARGETDIR
fi

cd $TARGETDIR

for file in $DATADIR/*fasta; do
  # In case gapseq is not in your PATH, either call it with full path, or add gapseq to PATH beforehand
  gapseq doall $file
done
